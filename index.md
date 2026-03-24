---
layout: post
toc: true
post_style: page
---

<h1 align="center">Command Line Control of Second Life Bots</h1>

Install `BotControl`:

```bash
curl -fsSL https://raw.githubusercontent.com/missyrestless/BotControl/refs/heads/main/install | bash
```

`BotControl` is a command line management system for `LifeBots` and `Corrade` Second Life
scripted agents (bots). The `botctrl` command can be used to manage either `Lite` or `Full` bots
from `LifeBots` as well as `Corrade` bots configured with the built-in Corrade HTTP service enabled.

The `botctrl` command is installed as `/usr/local/bin/botctrl` and symbolic links are created
for the commands `/usr/local/bin/corrade` and `/usr/local/bin/lifebot`. When invoked as `corrade`
the command uses the Corrade API to control Corrade bots. When invoked as `lifebot` the command
uses the LifeBots API to control LifeBots bots. When invoked as `botctrl` the command can control
either Corrade or LifeBots bots, determining which API to use based on how the bot name was specified
on the command line: `botctrl -c "bot name" ...` indicates use the Corrade API to control a Corrade
bot while `botctrl -n "bot name" ...` indicates control of a LifeBots bot.

**[NOTE:]** Missy Restless and the Truth &amp; Beauty Lab are not affiliated with
`Corrade` or `LifeBots` other than contributing `LifeBots` Knowledge Base articles.
This repository provides 3rd party tools for `Corrade` and `LifeBots` and is not
the official product of either. The official `LifeBots` site can be found at
[https://lifebots.cloud](https://lifebots.cloud) and `Corrade` at
[https://grimore.org/secondlife/scripted_agents/corrade](https://grimore.org/secondlife/scripted_agents/corrade).

