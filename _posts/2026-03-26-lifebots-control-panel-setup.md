---
layout: post
title: LifeBots Control Panel Setup
description: How to setup the LifeBots Control Panel with an API key and Bot secret
category: [ControlPanel]
tag: [setup, lifebots, controlpanel, api]
date: 2026-03-26 13:17 -0700
---

Before you can perform any initialization or send any commands to your bots you need to
configure the LifeBots Control Panel with your LifeBots Developer API Key. Each bot you
wish to control will also need a unique Bot Access Secret.

1. Create a LifeBots Developer API Key
   - Visit [https://lifebots.cloud/developer](https://lifebots.cloud/developer) to create your API Key
   - Copy the key and store it securely
1. Edit the LifeBots Control Panel "Configuration" notecard
   - Right click the LifeBots Control Panel and select Edit
   - In the Contents tab of the Edit window, right click the Configuration notecard and select Open
   - Change the line LB_API_KEY = 'your-api-key' replacing 'your-api-key' with your LifeBots API Key
   - Save the modified Configuration notecard and close the Edit window
1. Create a Bot Access Secret for each LifeBots bot you wish to control via the LifeBots Control Panel
   - Your command and control script will pass the Bot Access Secret to the LifeBots Control Panel
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
>
> Store this secret securely and change it regularly
>
> If compromised, create a new access secret immediately
{: .prompt-danger }

