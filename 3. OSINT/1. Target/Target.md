# Author - Bobby Bojangles


## OSINT — "Target"

**Points:** 500

> We are looking for a scammer. Find him! Law enforcement is waiting.

- **First name:** Andrzej
- **Last name:** Povalko
- **Age:** 25
- **Height:** 169 cm

**Flag:** `SK-CERT{1_l1k3_70_m0v3_1t_1_L1Ke_t0_M0v3_17_M0v3_1t_B4444m}`

**Solved by:** "I'm trying 2" A.K.A. IPsniffer6969
---

## Table of Contents

- [Method of solving](#method-of-solving)
- [How I solved it](#how-i-solved-it)
- [Why this challenge is so bonkers](#why-this-challenge-is-so-bonkers)

> To truly be able to dissect this challenge thoroughly and still provide a strong report, this write-up will be split up into three sections:
> - The method of solving
> - How I solved it and why I managed to beat the second half in a couple of minutes
> - A thorough breakdown of the challenge's elements

---


---

## Method of Solving

By conducting reverse searches on profile-grabbing tools with the name "Andrzej Povalko", the GitHub account **"angapangaboi"** is found.

The intent is not to browse through the found GitHub account, but rather to actually search up the username on the CTF platform. Doing so revealed two accounts: **angapang** and **angapangaboi**.

The account to focus on is **"angapang"**. Hovering over the link associated with the profile revealed a bit.ly link:

```
https://bit.ly/4tflV78
```

Clicking it takes you to a Bitly preview page, which quickly redirects you to:

```
twistingthetruth.sk/ang/big/boss/s3cr3t/g4ng/sup/bro
```

You are then taken to this site, which shows only a default "**It works!**" Apache page — this is all you can see, and all there is.

### Identifying Key User-Agents

Checking header user-agents reveals two key user-agents for this task:

```
"Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)"
"Mozilla/5.0 (Linux; Android 10; SM-G960U)"
```

This reveals there are versions of the site — one for iPhone devices, and one for every other type. Since the GitHub account bio says "Apple fan 📱", we choose to target the iPhone version. We use curl to fetch the web page:

```bash
curl -A "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)" \
     http://twistingthetruth.sk/ang/big/boss/s3cr3t/g4ng/sup/bro
```

Doing so reveals an image source encoded in **base64** that only appears on the iPhone version of the site.

By taking the found base64 code to **CyberChef** and decoding it as an image (From Base64 → Render Image), the flag is revealed:

```
SK-CERT{1_l1k3_70_m0v3_1t_1_L1Ke_t0_M0v3_17_M0v3_1t_B4444m}
```

Pop it into the challenge prompt, and the challenge is solved. ✅

---

## How I Solved It

After spending days searching for clues, I started searching GitHub for leaked flags or discussions for any challenge. Not the most noble idea, but I decided to peek anyway. I eventually got the idea to search for the name in the Target challenge, and to my surprise, I actually found it.

After searching for hours and hours through every repo, every connection, every VirusTotal VM sandbox report of repos the target user starred, every commit, every possible clue, I found nothing.

After talking about what I was doing with my family, one of them teasingly made a jab and said, *"haha dude they're probably a user on the CTF thing. Some OSINT guy, didn't even think to check."* Ouch. But they were actually right. They actually were a user.

Now, after all this, you can imagine where we are at. The site from the profile. I myself can't imagine having to figure out what to do after here. The potential steps are crazy, and to even think to check user-agents above other things boggles my mind.

I managed to solve this in minutes because I just so happened to be on my phone. Yes — I actually was doing the challenge on my iPhone at the time of going to the link. I even noticed on my phone I could toggle between an iPhone view and a PC view. I then decided to do the classic "inspect the page" using a tool I have on my phone. I immediately found the base64 and decoded it on CyberChef.

This all happened because I happened to be invited to a wedding, thus requiring a road trip to a nearby town, which meant my laptop had to stay in a backpack, forcing me to use my phone. Gotta love it.

---

## Why This Challenge Is So Bonkers

This challenge contains so many different possible dead ends it's crazy.

Crazy…?

### The Age and Height Red Herring

For example, the fact you are given the age and height of the target. This information is so useless, it literally serves no purpose but to throw you off. And here's how: you search for the man using the given age and height as anchor points, and when you realize you should probably use 5'5" instead of 169 cm, you start seeing a pattern. There is a report of a 25-year-old scammer who scammed someone recently.

You try to view the Facebook post, but it turns out they've been deleted. Not just those specific ones either. You search and find dozens of the same report, all deleted. And it kinda makes sense — this happened within the span of the competition, so no link can be used, thus requiring further digging.

It got so deep I nearly booted up my dark web VM to start searching for hidden information on dark web forums. "Almost." I ended up not needing to for obvious reasons, but the digging on this one thing alone could have gone so much deeper. All from being given a height and an age.

### The GitHub Rabbit Hole

Next is when you get to the GitHub account. First there is the repo he owns: **friendly-carnival**, and then two repos he starred:

- **SigmaHQ / sigma** — Main Sigma Rule Repository
- **ms-jpq / gay** — Colour your text / terminal to be more gay

The "friendly-carnival" repo contains a program that has several **red-herring flags** such as:

- `SK-CERT{fake_hello}` — early-dated numeric commit messages decoded as ASCII
- `SK-CERT{fake_leak}` — late-dated numeric commit messages
- `SK-CERT{zero_width_makes_zero_noise}` — README zero-width chars (ZWNJ=0/ZWJ=1)
- `SK-CERT{seed_was_the_secret_all_along}` — `tests/fixtures/seed.bin` XOR'd with 8-byte repeating key `"carnivl!"`

For the other two starred repos, there isn't much — except for the fact that **SigmaHQ / sigma** contains a recent discussion from 3 weeks ago involving a potential issue. The discussion contained a link to a VirusTotal report:

```
https://www.virustotal.com/gui/file/8617f2c7246cf71b7e2594574eeabd0d1e5350011af7eb0f0375834ee503eca9/behavior
```

The insights found here go pretty deep. There were VM sandbox reports analyzing commands run, memory changed, DLL and registry calls, and so much more. You can analyze it for hours and still not have seen everything.

All this from the GitHub account. I mean, you're practically destined to get lost here. It's crazy (crazy…?) because you're only supposed to take the username and that's it.

### The Fake CTF Account

Now when you get to the account on the platform, most people would think to put in "angapangaboi" in the users search. Well, the creator thought of that and created a **fake account** specifically to throw you off. Being lazy and entering only a couple of letters and hitting enter turns out to be the actual way to find the real account.

### The Website's Many Rabbit Holes

Now when you get to the site, you're met with the default Apache page. What do you do from here?

Maybe your first idea is the fact it says to "replace the page with your content." That's one rabbit hole. How about exploring different directories of the link? The URL is:

```
http://twistingthetruth.sk/ang/big/boss/s3cr3t/g4ng/sup/bro
```

That's 7 directories deep. So what if you analyze `http://twistingthetruth.sk/`? Well, it takes you to Google, with a funny pre-made link already waiting for you.

And what's the first thing you do when a redirect happens? You open up Zap/Burp and analyze what's happening. Doing this reveals several "juicy" responses that only make your head ache — and this is not everything whatsoever.

Some of this may seem obviously unrelated, but when no other route presents itself and this has revealed potentially critical information, it suddenly becomes extremely valuable. Again, who would think to look at user-agents in the header before all of this?

---

## Conclusion

Every step in this challenge is meant to throw you into a rabbit hole that only grows deeper on the next step once you reach it. Clues and roads found end up being dead ends, and you're left wondering: *what on earth am I missing?*

Several, if not the majority, of users were stuck and lost on the GitHub page. You have no idea what to trust, and what you think you can trust ends up being bait crafted specifically to get you lost. It's probably impossible not to get lost in the rabbit hole. That's what makes this so crazy.

The insanity and planning taken into consideration in this challenge are something that shakes me to my core. I have nothing but utter respect for the author as I write the report for what might be the **greatest OSINT challenge ever made**.
