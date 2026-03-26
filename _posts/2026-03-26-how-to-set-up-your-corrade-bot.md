---
layout: post
author: missyrestless
title: How to Set Up Your Corrade Bot
description: Step-by-step setup instructions to get started with Corrade bots
category: [Corrade]
tag: [setup, corrade]
pin: true
date: 2026-03-26 10:42 -0700
---

A `Corrade` bot is a Second Life account that logs in and runs as an automated scripted agent.

You'll need the following:

- A separate Second Life account — Do not use your main avatar. Use a name that fits your bot's purpose (e.g., "MyStore Greeter"). [Create one here](https://join.secondlife.com).
- Scripted agent status — You must flag the bot account as a scripted agent in your Second Life account settings. This is required by Linden Lab's Terms of Service — without it, your bot account may be suspended. [See related article](https://slbotcontrol.github.io/posts/setup-your-bot-as-a-scripted-agent-in-second-life)
- The bot account's username and password — The same credentials you'd use to log into the Second Life viewer.
- The Second Life group name the Corrade bot will use

## Corrade Requirements

`Corrade` can run on the following platforms and architectures:

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

## Deploy Corrade

Download the latest `Corrade` release from
[https://corrade.grimore.org/download/corrade](https://corrade.grimore.org/download/corrade)

See the `Corrade` website at
[https://grimore.org/secondlife/scripted_agents/corrade](https://grimore.org/secondlife/scripted_agents/corrade)
for instructions on deployment and configuration of a self-hosted `Corrade` service.

### Setup Corrade

Corrade can be downloaded from the `Corrade` releases page by selecting the correct platform and architecture or, alternatively, by using containerization like Docker and pulling the official image.

In case Docker is used with the official image, then no extra setup is required and Corrade can be run under Docker.

In case Corrade is downloaded and unpacked without Docker, then the executable binary should start and run Corrade in Windows. On Linux machines the latest .NET runtime is required to run Corrade (note that the SDK is not needed, just the runtime) and Microsoft provides
[Linux distribution-compliant packages](https://dotnet.microsoft.com/en-us/download/dotnet)
for most Linux distributions.

Regardless how Corrade is installed, upon starting Corrade, Corrade will mention that no configuration has been found and that the Nucleus web-server has been launched in order to perform an initial configuration.

Nucleus listens on all addresses so if Corrade is installed on the local machine then the Nucleus interface will be available at following URL:

    http://127.0.0.1:54377/

If Corrade is running on a different machine, then the Nucleus web interface can be accessed through the network by pointing the browser to http://TARGET_MACHINE:54377/ where TARGET_MACHINE is the hostname or IP address of the machine on which Corrade has been launched.

Upon accessing the Nucleus web interface, log-in using the default password: `nucleus` (this can be changed later by copying NucleusConfiguration.xml.default' to NucleusConfiguration.xml and then changing the password) and a configuration form should now load up.

### Minimal Corrade Configuration

The minimal fields required to get the bot connected to the Second Life grid are the following:

- Login -> Firstname, Lastname and Password - these are the credentials of an existing account in Second Life that the bot will use to connect to the grid
- Groups -> Group name and Password - the group corresponding to the group name must exist in Second Life and the password can be any made up string; the default [Wizardry and Steamworks]:Support group can be edited or removed

**[NOTE:]** The Corrade configuration requires an unsalted MD5 hash of the Corrade bot's account password.
The following shell script can be used to generate this MD5 hash:

```sh
#!/bin/bash
#
# mkmd5hash - generate an unsalted MD5 hash of the Corrade bot's password
#
# Prepend $1$ to the MD5 hash

PASS="$1"
printf '%s' "${PASS}" | md5sum | awk '{print $1}'
```

Prepend `$1$` to the generated MD5 hash. For example, the `CorradeConfiguration.xml` entry with full
MD5 hash and prepended string for the password `foobarspam` would be:

```xml
    <Password>$1$3ae6bcbff35ee67854479ca55de6e228</Password>
```

Once the configuration is complete, click `Commit configuration` and wait for the bot to connect to the grid.

## Configure Corrade for use with the BotControl command line tools

In order to use the `botctrl` command to manage your `Corrade` bot(s):

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

Note that each Corrade API request requires some permissions enabled in the Corrade
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

### Configure BotControl

Configure `BotControl` by adding and editing the file `${HOME}/.botctrl`.

If you wish to control `Corrade` bots then you must configure your `Corrade`
group, password, and server URL.

The following example entries in `$HOME/.botctrl` will allow you to control a
`Corrade` bot named "Cory Bot":

```bash
# Corrade Group, Password, and Server URL
export CORRADE_GROUP="<your-corrade-bot-group-name>"
export CORRADE_PASSW="<your-corrade-bot-group-password>"
export CORRADE_URL="https://your.corrade.server"
# The Corrade bot's API URL
# This assumes a reverse proxy setup has been configured and this URL
# path is passed by the web server to the appropriate Corrade HTTP port
export API_URL_Cory_Bot="${CORRADE_URL}/cory/"
```

Add an entry of the form `export API_URL_Firstname_Lastname="${CORRADE_URL}/path/"`
to `$HOME/.botctrl` for each of your `Corrade` bots.
