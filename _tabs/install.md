---
title: Install
icon: fas fa-info-circle
order: 3
---

## Requirements

The `BotControl` command line management system requires:

- Unix, Linux, Macos, or Windows Subsystem for Linux (WSL)
- Bash
- Cron
- curl
- git
- [jq](https://jqlang.org)

These requirements, with the exception of `jq`, are typically included in the base
operating system on all supported platforms. If your platform does not have `jq`
installed then the installation process will attempt to install the `jq` package.

## Install BotControl

To install `BotControl`:

```bash
git clone https://github.com/slbotcontrol/BotControl.git
cd BotControl
./install
```

Or, you can use the `curl` command to install `BotControl` with a single command:

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

