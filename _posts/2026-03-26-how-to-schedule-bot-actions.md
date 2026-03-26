---
layout: post
author: missyrestless
title: How to Schedule Bot Actions
description: How to automate scheduled bot actions using the cron facility
category: [General]
tag: [setup, schedule]
date: 2026-03-26 15:52 -0700
---

**[Note:]** A more modern approach to scheduled LifeBots activities is available
as a `LifeBots Add-On` with the `Routine Planner Add-On` at
[https://lifebots.cloud/store/addon/routine-planner](https://lifebots.cloud/store/addon/routine-planner).
With `Routine Planner` you can build fully automated, interactive bot behaviors using
routines that run on schedules, react to chat/IM triggers, execute actions step-by-step,
and even branch routines based on user responses.

The Truth & Beauty Lab utilizes the `Cron` subsystem on Linux and Macos to
schedule bot actions. Truth & Beauty Lab bots are logged in, teleported
to various locations, seated on various objects, and engaged in a variety of
activities using `crontab` entries that execute `Corrade` and `LifeBots` API
requests at scheduled times.

## Prepare a crontab.in input file for Crontab

The `crontab` command can accept an input file formatted with the proper syntax.
Prepare a `crontab.in` file with your scheduled bot activities as `botctrl` commands
or scripts you have written that use the `BotControl` facility. Once you have your
`crontab.in` file prepared, issue the command `crontab crontab.in`.

### Crontab Syntax

Each job entry in the crontab file follows a specific format on a single line:

> minute hour day_of_month month day_of_week command_to_execute
{: .prompt-info }

Each of the first five fields accepts specific values, ranges, lists, or step values:

| Field | Description | Allowed Values |
|:----- |:----------- |:-------------- |
| Minute | Minute of the hour | 0 to 59 |
| Hour | Hour of the day (24-hour format) | 0 to 23 |
| Day of Month | Day of the month | 1 to 31 |
| Month | Month of the year | 1 to 12 (or names like JAN, FEB) |
| Day of Week | Day of the week | 0 to 6 (0 or 7 is Sunday, or names like SUN, MON) |

#### Special Characters

- `*` (Asterisk): Matches all possible values for that field (e.g., `*` in the hour field means every hour).
- `,` (Comma): Specifies a list of values (e.g., `1,15,30` in the minute field means at minutes 1, 15, and 30).
- `-` (Hyphen): Specifies a range of values (e.g., `1-5` in the day of week field means Monday through Friday).
- `/` (Slash): Specifies a step value (e.g., `*/15` in the minute field means every 15 minutes).

#### Predefined Macros

You can use shortcuts like `@hourly`, `@daily`, `@weekly`, `@monthly`, `@yearly`, or `@reboot`
in place of the five time-date fields.

## Example crontab.in

Here is an example `crontab` entry with some brief descriptions in comments
of what activities are scheduled:

```
SHELL=/bin/bash
#
# Schedule BotControl actions
# -------------------------
# Uses the botctrl command line tool at:
#   https://github.com/slbotcontrol/BotControl/blob/main/botctrl
# Assumes some configuration in ~/.botctrl has been performed
#
# m h  dom mon dow   command
#
# Weekdays send Anya bot to the club at midnight
0 0 * * 1-5 /bin/bash -lc /usr/local/BotControl/anya2club >> /usr/local/BotControl/log/cron.log 2>&1
# Weekends send Anya bot to the beach at 11am
0 11 * * 0,6 /bin/bash -lc /usr/local/BotControl/anya2beach >> /usr/local/BotControl/log/cron.log 2>&1
# Monday at 4pm send Anya bot to DJ at the Media Sphere
0 16 * * 1 /bin/bash -lc /usr/local/BotControl/anya2msdj >> /usr/local/BotControl/log/cron.log 2>&1
# Monday at 6pm sit Anya in theater seating after her set
0 18 * * 1 /bin/bash -lc /usr/local/BotControl/anya2seat >> /usr/local/BotControl/log/cron.log 2>&1
# Tuesday at 6pm send Angelus bot to DJ at the club
0 18 * * 2 /bin/bash -lc /usr/local/BotControl/angelus2clubdj >> /usr/local/BotControl/log/cron.log 2>&1
# Tuesday at 8pm send Angelus bot back to his dance pole
0 20 * * 2 /bin/bash -lc /usr/local/BotControl/angelus2pole >> /usr/local/BotControl/log/cron.log 2>&1
# Friday at 6pm send Easy bot to DJ at the club
0 18 * * 5 /bin/bash -lc /usr/local/BotControl/easy2clubdj >> /usr/local/BotControl/log/cron.log 2>&1
# Friday at 8pm send Easy bot back to her dance pole
0 20 * * 5 /bin/bash -lc /usr/local/BotControl/easy2pole >> /usr/local/BotControl/log/cron.log 2>&1
# Saturday at 6pm send all bots to dance at the club
0 18 * * 6 /bin/bash -lc /usr/local/BotControl/bots2clubdance >> /usr/local/BotControl/log/cron.log 2>&1
# Saturday at 9pm send all bots back to their default locations
0 21 * * 6 /bin/bash -lc /usr/local/BotControl/bots2home >> /usr/local/BotControl/log/cron.log 2>&1
# Check every hour if Easy bot is at the club greeting visitors
# 0 * * * * /bin/bash -lc /usr/local/BotControl/checkbot >> /usr/local/BotControl/log/cron.log 2>&1
# Send the Easy Islay bot's L$ balance to myself on the 1st of every month
# 0 0 1 * * /bin/bash -lc /usr/local/BotControl/send_easy_balance >> /usr/local/BotControl/log/easy.log 2>&1
```

Using a `crontab.in` file similar to this example but containing your own customized bot commands,
issue the command `crontab crontab.in`.

To view your currently active `crontab` entries run the command `crontab -l`.

- `crontab -e`: Edits the crontab file, or creates one if it doesn't exist.
- `crontab -l`: Displays the current crontab entries.
- `crontab -r`: Removes the current crontab file entirely (use with caution).
