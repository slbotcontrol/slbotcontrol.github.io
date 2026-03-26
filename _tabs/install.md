---
layout: post
post_style: page
title: Install
icon: fas fa-info-circle
order: 3
---

# BotControl Command Line

The `BotControl Command Line` is a suite of tools that enable control and management of
`Corrade` and `LifeBots` bots via the Unix/Linux command line. These tools are executed in
a terminal using the Bash shell and utilities such as `curl`, `sed`, `awk`, `jq`, and others.

The primary command line tool is the `botctrl` Bash script which acts as a front-end
for `Corrade` and `LifeBots` API requests.

## Requirements

The `botctrl` command line management system requires:

- Unix, Linux, Macos, or Windows Subsystem for Linux (WSL)
- Bash
- Cron
- curl
- git
- [jq](https://jqlang.org)

These requirements, with the exception of `jq`, are typically included in the base
operating system on all supported platforms. If your platform does not have `jq`
installed then you can still use `botctrl`, a few of the helper utilities will not
function properly but the bulk of the system will function without `jq`.

## Install botctrl

To install `botctrl`:

```bash
git clone https://github.com/slbotcontrol/BotControl.git
cd BotControl
./install
```

Or, you can use the `curl` command to install `botctrl` with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/slbotcontrol/BotControl/refs/heads/main/install | bash
```

Alternatively, download the `install` release artifact and execute it.
The `install` script will clone the repository and install the system:

```bash
wget -q https://github.com/slbotcontrol/BotControl/releases/latest/download/install
chmod 755 install
./install
```

