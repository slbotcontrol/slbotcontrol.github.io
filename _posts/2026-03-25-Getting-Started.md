---
title: Getting Started
author: missyrestless
date: 2026-03-25 12:55:00 +0800
pin: true
img_path: "/posts/20260325"
---

To get started controlling `LifeBots` and/or `Corrade` Second Life bots you will need to:

- [Setup and enable a bot](#bot-setup)
- [Download and install `BotControl`](#installation)
- [Configure `BotControl`](#configuration)
- [Execute commands](#command-execution)

## Bot Setup

In order to use the command line bot control tools provided here you must deploy either a
`Corrade` or `LifeBots` bot, or both. Currently these are the only two types of Second Life
bots supported. The choice depends on your use case and level of skill.

### [LifeBots Setup](https://lifebots.cloud/){:target="_blank"}{:rel="noopener noreferrer"}

`LifeBots` provides a modern cloud based bot service with a slick web UI, advanced features,
and excellent AI capabilities. `LifeBots` features like Discord Integration and Routine Planner
make it an excellent choice for your Second Life bot service.

Register your avatar with `LifeBots` by clicking the `Get Started` or `Start Now` buttons at
[https://lifebots.cloud/](https://lifebots.cloud/). Once registred you can view the `LifeBots`
Knowledge Base article on [Types of Bots &amp; Pricing](https://lifebots.cloud/support/article/types-of-bots-pricing)
to select the type of LifeBots bot, Lite or Full, that best suits your needs.

See the `LifeBots` Knowledge Base article
[How to Setup Your Personal Bot with LifeBots](https://lifebots.cloud/support/article/how-to-setup-your-personal-bot-with-lifebots)
for a detailed step-by-step guide to setting up your `LifeBots` bot.

#### LifeBots API Key and Bot Secret

`BotControl` and the `LifeBots Control Panel` use the `LifeBots` Application Programming Interface (API)
to control your `LifeBots` bots. In order to use the API, an API Key and Bot Secret are required. Your
`LifeBots` API Key can be found at [https://lifebots.cloud/developer](https://lifebots.cloud/developer).
You will need to generate a Bot Secret for each of your `LifeBots` bots. See the `LifeBots` Knowledge Base
article [How to Setup a Bot Access Secret](https://lifebots.cloud/support/article/how-to-setup-a-bot-access-secret)
for detailed steps to generate your Bot Secret(s).

### [Corrade Setup](https://grimore.org/secondlife/scripted_agents/corrade){:target="_blank"}{:rel="noopener noreferrer"}

`Corrade` is a multi-purpose, multi-platform scripted agent (bot) that runs under Windows or Unix
natively, as a service or daemon whilst staying connected to a Linden-based grid (either Second Life
or OpenSim) and controlled entirely by scripts.

In order to setup a `Corrade` bot you will need to install and configure a server with the `Corrade`
software. That is, you will be self-hosting your Second Life bots. This requires some additional
system skills and is not a viable option for some. If you know what you are doing then it is a way
to run your bots for free (minus the cost of electricity) and to control your own bot service.

There are two big problems with cloud based services like `LifeBots`. One is simply the cost. You have
to pay them money because it costs them money to run the service and they are trying to make money.
But more importantly, the second big problem with cloud services is you are totally dependent upon
them to keep their service active and available. A cloud provider might go down and be unavailable
for some time. The provider may even discontinue the service or increase prices. They control your
service, it's capabilities, price, availability, and access.

However, self-hosting is not free nor is it immune from downtime. Self-hosting also requires some
degree of skill and effort in setup and maintenance. With self-hosting you are your own provider
and IT department. Thankfully there is a `Corrade` group In-World where the community of `Corrade`
users provide each other with Support, tips, troubleshooting, and advice.

#### Corrade Requirements

If you do not understand what these requirements mean then probably you should deploy `LifeBots`.

- `Corrade` can run on the following platforms and architectures:
  - Linux - the stable version "Standard Term Support" of .NET has to be installed
    - Linux 64bit,
    - Linux ARM 64bit or AARCH64,
      - ARMv7 or more required (please check your hardware),
      - Raspberry Pi first generation (v1) are not compatible since they have ARMv6 which is not supported. The following will not work: Raspberry Pi v1, v2, Zero v1, most of which are now outdated,
    - Windows 10 and up
    - MacOS (macOS 10.12 Sierra and up)
- 100-350 MB RAM with all options turned on.
- For the network, Linden Lab recommends cable and not wireless.
- `Corrade` uses the exact same firewall ports as any other viewer in Second Life.
  - Any `Corrade` feature that requires an additional port such as the interfacing servers will have to be forwarded to the machine that `Corrade` runs on.

#### Deploy Corrade

See the `Corrade` website at
[https://grimore.org/secondlife/scripted_agents/corrade](https://grimore.org/secondlife/scripted_agents/corrade)
for instructions on deployment and configuration of a self-hosted `Corrade` service.

### Configure Corrade for use with the API

In order to use `BotControl` to manage your `Corrade` bot(s):

- The HTTP server must be enabled in the `Corrade` configuration
- `ScriptLanguage` must be set to `JSON` in the `Corrade` configuration

Example snippet to enable the HTTP server in `CorradeConfiguration.xml`:

```xml
<Servers>
    <HTTPServer>
        <Enable>1</Enable>
        <Prefixes>
            <Prefix>http://+:8082/</Prefix>
        </Prefixes>
    </HTTPServer>
    ...
</Servers>
```

Set the port number in the `Prefix` configuration to an open unused port.
If you have more than one `Corrade` bot then use a different port for each.

To set the `ScriptLanguage` to JSON in `CorradeConfiguration.xml`:

```xml
  <ScriptLanguage>JSON</ScriptLanguage>
```

Note that each `Corrade` API request requires some permissions enabled in the `Corrade`
Configuration. For example, balance inquiries and payments require the `economy`
permission, inventory operations require the `inventory` permission, movement requires
the `movement` permission. An example set of Corrade permissions that enable capabilities
required by the `botctrl` command might look like:

```xml
    <Permissions>
        <Permission>movement</Permission>
        <Permission>grooming</Permission>
        <Permission>interact</Permission>
        <Permission>notifications</Permission>
        <Permission>talk</Permission>
        <Permission>group</Permission>
        <Permission>land</Permission>
        <Permission>inventory</Permission>
        <Permission>directory</Permission>
        <Permission>system</Permission>
        <Permission>bridge</Permission>
        <Permission>economy</Permission>
        <Permission>execute</Permission>
    </Permissions>
```

## Installation

The `BotControl Command Line` management system is a suite of tools that enable control and
management of `Corrade` and `LifeBots` bots via the Unix/Linux command line. These tools are
executed in a terminal using the Bash shell and utilities such as `curl`, `sed`, `awk`, and `jq`.

### BotControl Requirements

The `BotControl` command line management system requires:

- Unix, Linux, Macos, or Windows Subsystem for Linux (WSL)
- Bash
- Cron
- curl
- git
- [jq](https://jqlang.org)

These requirements, with the exception of `jq`, are typically included in the base
operating system on all supported platforms. If your platform does not have `jq`
installed then the `BotControl` installation will attempt to install `jq`.

### Install BotControl

To install `BotControl`:

```sh
git clone https://github.com/slbotcontrol/BotControl.git
cd BotControl
./install
```

Or, you can use the `curl` command to install `BotControl` with a single command:

```sh
curl -fsSL https://raw.githubusercontent.com/slbotcontrol/BotControl/refs/heads/main/install | bash
```

Alternatively, download the `install` release artifact and execute it.
The `install` script will clone the repository and install the system:

```sh
wget -q https://github.com/slbotcontrol/BotControl/releases/latest/download/install
chmod 755 install
./install
```

## Configuration

In order to control `Corrade` or `LifeBots` bots from the command line some configuration
is required. After installing `BotControl` perform the following configuration steps.

The `botctrl` command is installed in `/usr/local/bin` along with some
utility scripts for use with `cron` or other management systems. These
utility scripts will need to be modified to suit your specific needs,
configuration and bot names. You can modify the scripts in
`bin/` and re-run `./install`.

Add `/usr/local/bin` to your execution `PATH` if it is not already included.

Configure `botctrl` by adding and editing the file `${HOME}/.botctrl`.

If you wish to control `LifeBots` bots then you must configure your `LifeBots`
developer API key and bot secrets for the `LifeBots` bots you wish to control.

If you wish to control `Corrade` bots then you must configure your `Corrade`
group, password, and server URL.

The following example entries in `$HOME/.botctrl` will allow you to control a
`LifeBots` bot named "Your Botname" and a `Corrade` bot named "Cory Bot":

```sh
# Minimum contents of $HOME/.botctrl
#
# LifeBots Developer API Key
export LB_API_KEY='<your-lifebots-api-key>'
# LifeBots bot secret
export LB_SECRET_Your_Botname='<your-bot-secret>'
# Corrade Group, Password, and Server URL
export CORRADE_GROUP="<your-corrade-bot-group-name>"
export CORRADE_PASSW="<your-corrade-bot-group-password>"
export CORRADE_URL="https://your.corrade.server"
# The Corrade bot's API URL
# This assumes a reverse proxy setup has been configured and this URL
# path is passed by the web server to the appropriate Corrade HTTP port
export API_URL_Cory_Bot="${CORRADE_URL}/cory/"
```

Add an entry of the form `export LB_SECRET_Firstname_Lastname='<bot-secret>'`
to `$HOME/.botctrl` for each of your `LifeBots` bots.

Add an entry of the form `export API_URL_Firstname_Lastname="${CORRADE_URL}/path/"`
to `$HOME/.botctrl` for each of your `Corrade` bots.

See `BotControl/example_dot_botctrl` for a template to use for `$HOME/.botctrl`.

See `BotControl/crontab.in` for example crontab entries to schedule bot activities.

## Command Execution

The primary command line tool is the `botctrl` Bash script which acts as a front-end
for `Corrade` and `LifeBots` API requests. Symbolic links are created to provide the additional
commands, `corrade` and `lifebot`. The `corrade` command can be used to command and control
`Corrade` bots. The `lifebot` command can be used to command and control `LifeBots` bots. The
`botctrl` command can be used to control either a `Corrade` bot or a `LifeBots` bot, depending
on how the bot name is specified on the command line - `-c name` indicates a `Corrade` bot while
`-n name` indicates a `LifeBots` bot.

### Example Command Invocation

- Bot Status
  - Retrieve the status of your `Corrade` bot named `Echo Bunny`:
    - `corrade -a status -n "Echo Bunny"`
    - or
    - `botctrl -a status -c "Echo Bunny"`
  - Retrieve the status of your `LifeBots` bot named `Echo Bunny`:
    - `lifebot -a status -n "Echo Bunny"`
    - or
    - `botctrl -a status -n "Echo Bunny"`
- Teleport Bot
  - Teleport `Corrade` bot named `Black Pinky` to the SLurl alias `beach`
    - Requires a SLurl alias configured in `~/.botctrl` of the form:
      - `export SLURL_beach="https://maps.secondlife.com/secondlife/REGION_NAME/X/Y/Z"`
    - `corrade -a teleport -n "Black Pinky" -l beach`
  - Similarly, to teleport a `LifeBots` bot:
    - `lifebot -a teleport -n "Black Pinky" -l beach`
    - or
    - `botctrl -a teleport -n "Black Pinky" -l beach`

Commands can be scripted and combined to perform actions using inputs gathered from previous
command outputs. See the [Corrade Examples](https://slbotcontrol.github.io/corrade_examples)
tab of the [SL Bot Control](https://slbotcontrol.github.io) website for several examples.

### Supported Actions

**[NOTE:]** Support for additional actions is ongoing. New commands are added frequently. This list is a snapshot.

As of the last writing of this post, the actions supported by the `botctrl`, `corrade`, and `lifebot`
commands include:

#### Supported actions for BotControl Configuration

|    |    |    |    |    |    |
| -- | -- | -- | -- | -- | -- |
| bot_alias | loc_alias | slurl_alias | uuid_alias | list_alias | alias |

#### Supported actions common to both Corrade and LifeBots

|    |    |    |    |    |    |
| -- | -- | -- | -- | -- | -- |
| activate_group | attachments | avatar_picks | get_balance | get_outfit | get_outfits | give_inventory |
| give_object | give_money | give_money_object | im | key2name | listinventory | login | logout |
| name2key | notecard_create | rebake | say_chat_channel | send_group_im | send_notice |
| set_hoverheight | sit | stand | status | takeoff | teleport | touch_prim | walkto | wear | wear_outfit

#### Supported actions for LifeBots only

|    |    |    |
| -- | -- | -- |
| bot_location | reply_dialog | touch_attachment |

#### Supported actions for Corrade only

|    |    |    |    |    |    |
| -- | -- | -- | -- | -- | -- |
| attach | conference | conference_detail | conference_list | createlandmark | currentsim |
| detach | fly | flyto | getattachmentspath | getavatarpickdata | getgroupmemberdata |
| get_hoverheight | getmembersonline | getregiontop | getselfdata | inventory cwd | networkmanagerdata |
