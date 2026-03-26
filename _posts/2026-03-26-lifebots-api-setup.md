---
layout: post
title: LifeBots API Setup
author: missyrestless
date: 2026-03-26 09:12 -0700
---

`BotControl` command line and the `LifeBots Control Panel` in-world object use the `LifeBots`
Application Programming Interface (API) to control your `LifeBots` bots. In order to use the API,
an API Key and Bot Secret are required. Your `LifeBots` API Key can be found at
[https://lifebots.cloud/developer](https://lifebots.cloud/developer).

You will need to generate a Bot Secret for each of your `LifeBots` bots. See the `LifeBots` Knowledge Base
article [How to Setup a Bot Access Secret](https://lifebots.cloud/support/article/how-to-setup-a-bot-access-secret)
for detailed steps to generate your Bot Secret(s).

## Step-by-Step API Setup

1. Create a LifeBots Developer API Key
   - Visit [https://lifebots.cloud/developer](https://lifebots.cloud/developer) to create your API Key
   - Copy the key and store it securely
1. Create a Bot Access Secret for each LifeBots bot you wish to control
   - How to Setup a Bot Access Secret
     - These steps are detailed in the LifeBots Knowledge Base article at [https://lifebots.cloud/support/article/how-to-setup-a-bot-access-secret](https://lifebots.cloud/support/article/how-to-setup-a-bot-access-secret)
     - A Bot Access Secret is required for LifeBots API authentication
     - Requests must be authenticated using an access secret unique to each bot
     - To create an access secret for a bot:
       - Visit your LifeBots Dashboard at [https://lifebots.cloud/dashboard](https://lifebots.cloud/dashboard)
       - Click on the bot you wish to control via the API
         - This will open a Manage Bot panel for the bot
       - Click on the API Details pane
         - This will open an API Access Configuration window
       - Click on the Generate Secure Code button
         - This will generate a Bot Access Secret unique to this bot

After generating the Bot Access Secret, in the API Access Configuration window you will see a Current Access Code with the date it was created. Below that is your Bot Access Secret. Click on the eye icon to the right of the access secret to reveal the secret. This will enable the Copy icon to the right of the eye icon.

Click on the Copy icon to copy the bot access secret to your clipboard. Paste the copied secret into a file and store it securely. Never share this secret with anyone.

Repeat this process to generate a unique Bot Access Secret for each of the bots you wish to control.

> Anyone with your access secret can control your bot using the API
> Store this secret securely and change it regularly
> If compromised, create a new access secret immediately
{: .prompt-danger }

## BotControl Configuration

Configure the `BotControl` command line bot control system by adding and editing the file `${HOME}/.botctrl`.

If you wish to control `LifeBots` bots then you must configure your `LifeBots`
developer API key and bot secrets for the `LifeBots` bots you wish to control.

The following example entries in `$HOME/.botctrl` will allow you to control a
`LifeBots` bot named "Your Botname":

```sh
# LifeBots Developer API Key
export LB_API_KEY='<your-lifebots-api-key>'
# LifeBots bot secret
export LB_SECRET_Your_Botname='<your-bot-secret>'
```

Add an entry of the form `export LB_SECRET_Firstname_Lastname='<bot-secret>'`
to `$HOME/.botctrl` for each of your `LifeBots` bots.

## LifeBots Control Panel Setup

Configure the `LifeBots Control Panel` in-world object by editing the `Configuration` notecard:

- Edit the LifeBots Control Panel "Configuration" notecard
  - Right click the LifeBots Control Panel and select Edit
- In the Contents tab of the Edit window
  - Right click the Configuration notecard and select Open
- Change the line LB_API_KEY = 'your-api-key' replacing 'your-api-key' with your LifeBots API Key
- Save the modified Configuration notecard and close the Edit window
- Your command and control script will pass the Bot Access Secret to the LifeBots Control Panel
