# rEquestria Challenge - Part 2: OAuth/SSO Exploitation

Author - Senpai

**Category:** Web / GraphQL / OAuth

**Flag:** `SK-CERT{w3ll_s0m3t1m3s_ss0_1s_not_th3_b3st_s0lut10n}`

---

## Overview

With the full member list in hand from Part 1, the next step is to gain authenticated access to the application. The Microsoft SSO login button is the attack vector here — and the backend's trust in the OAuth email claim makes it exploitable.

---

## Step 4: OAuth Chain Analysis

Pivot to the login side. Click the Microsoft SSO button and see what happens.

The browser redirects to Microsoft:

```
GET /auth/microsoft
->  302 to https://login.microsoftonline.com/common/oauth2/v2.0/authorize?
    client_id=30ad782c-2190-4a15-bd42-a78181960499
    &redirect_uri=https://mail.equestriasociety.com/auth/microsoft/callback
    &scope=openid+email+profile+User.Read
    &response_type=code
```

Study that URL carefully. Two critical things are missing: `state` and `nonce`. There's no CSRF protection on the OAuth flow.

The more interesting question is what happens next — how does the backend validate the Microsoft identity?

Test the callback endpoint with a fake code:

```
GET /auth/microsoft/callback?code=abc
->  302 to /login?error=token_exchange_failed
```

The backend is doing server-side code exchange. Set up a proxy, go through a real Microsoft login, and capture the actual callback redirect. After the exchange completes you'll see:

```
/login?error=unauthorized&email=<YOUR_MICROSOFT_EMAIL>
```

The backend is echoing back whatever email comes from the Microsoft token. It uses that email to check membership. There's no domain validation. No additional verification. If you can get a Microsoft account with a member email set on it, you're in.

This is the NoAuth vulnerability in Microsoft Azure AD. See the detailed breakdown here: https://www.crowdstrike.com/en-us/blog/noauth-microsoft-azure-ad-vulnerability/

The backend trusts the email claim from Microsoft without verifying the account actually exists in the target tenant.

---

## Step 5: Exploiting Entra External ID

You need a Microsoft account where the `mail` attribute is set to a member's email from your leaked list.

Personal Microsoft consumer accounts (live.com) won't let you set custom mail attributes. Tenant creation requires phone verification or a paid license. The M365 Developer Program is also gated behind phone verification.

But **Microsoft Entra External ID** works. Create a cloud user in an External ID tenant — those users can have arbitrary `mail` attributes set in the Azure portal.

Test with a dummy value first to confirm the reflection:

```
Set mail attribute = test1@yourdomain.com
Go through Microsoft SSO on the site
Observe: /login?error=unauthorized&email=test1@yourdomain.com
```

The backend echoes your mail attribute back. The trust chain is confirmed.

Now pick a target from your leaked member list. Try the admin first:

```
Set mail attribute = luna.starlight@equestriasociety.com
```

Redirect from the OAuth flow returns:

```
/login?error=sso_not_allowed_for_role
```

The backend blocks admins and reporters from SSO login entirely. Their role is too high for this attack vector.

The low-privilege accounts from the member list are:

```
friends@equestriasociety.com          (role 0)
twilight.scholar@equestriasociety.com (role 0)
fluttershy.quiet@equestriasociety.com (role 0)
```

Set your Entra user's mail attribute to `fluttershy.quiet@equestriasociety.com` and run the OAuth flow again.

Login succeeds. You're in as a regular member.

The site UI now shows a **Download source code** button that was not visible before. Click it — a zip archive downloads. Inside is `flag.txt`:

```
SK-CERT{w3ll_s0m3t1m3s_ss0_1s_not_th3_b3st_s0lut10n}
```

**Flag 2 found.**

---

## Summary

The OAuth flow trusted the `mail` attribute from a Microsoft token without verifying it belonged to the application's own tenant. By creating an Entra External ID user with a spoofed `mail` attribute matching a known member, we bypassed authentication entirely. Admins and reporters were blocked from SSO, but low-privilege member accounts were not — making them the viable target.

**Next:** With member-level access established, download the source code and look for a path to admin. → Part 3
