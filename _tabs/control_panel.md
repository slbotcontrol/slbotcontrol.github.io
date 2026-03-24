---
# the default layout is 'page'
icon: fas fa-info-circle
order: 2
---

# LifeBots Control Panel

`LifeBots Control Panel` is an LSL script library to control `LifeBots` bots from an LSL script.

The `LifeBots Control Panel` is a scripted in-world object that acts as a bridge
between your `LifeBots` management scripts and your `LifeBots` bots. The control panel
communicates with your bots using the `LifeBots API` and an HTTP server listening to events.

`LifeBots Control Panel` is compatible with `SmartBots TotalControl` scripts. Existing
`SmartBots TotalControl` scripts can be modified, replacing the bot name and bot code with
your `LifeBots` bot name and bot code, and used exactly as-is in `LifeBots Control Panel`.

## What is LifeBots

[LifeBots](https://lifebots.cloud) bills itself as:

> The most advanced bot platform for Second Life. From AI characters to
> complete group automation, we've got everything your community needs.

I cannot disagree - `LifeBots` is the most advanced bot platform for Second Life.

`LifeBots` offers 2 subscription plans, `Lite` and `Full`. The plans provide these features:

| `LifeBots` Lite (`L$165/wk`) | `LifeBots` Full (`L$450/wk`) |
|:---------------------------- |:---------------------------- |
| Basic bot functionality      | All Lite Bot features        |
| Greeter Bot addon            | Group Notice scheduling      |
| HUD Support                  | Group IM scheduling          |
| Dialog Menu Interactions     | Group Web Chat               |
| RLV capabilities             | Group Discord Sync           |
| Compatible addons support    | Complete addon support       |
| API access                   | Advanced AI integration      |
| Email support                | Priority support             |
| Web dashboard access         | Custom scripting             |
| AI Access                    | AI Functions                 |
|                              | Avatar Specific Memory       |
|                              | Advanced analytics           |

This repository provides an in-world scripted object, `LifeBots Control Panel`,
that acts as a bridge between `LifeBots` management scripts and `LifeBots` bots.

Both `LifeBots` subscription plans provide a web UI and HUD that can be used for
interactive control of `LifeBots` bots and, for many users, this is sufficient.

For developers who wish to script `LifeBots` management, command, and control,
the `LifeBots Control Panel` provides an easy to use in-world interface to the
`LifeBots API`, enabling the automation of many of the rich `LifeBots` feature set.

`LifeBots Control Panel` is licensed under the GPL version 3 open source licens and,
as such, is free to download, deploy, modify, and redistribute. All modifications
and derivative works must comply with the license and make their modifications
freely available under the terms of the GNU General Public License version 3.

## LifeBots Control Panel Features

- Login / Logout your Bot
- Bot Movement Controls (e.g. Fly, Sit, Stand, Teleport, Walk, Walk To)
- Object Interaction (e.g. Find/Take/Delete/Sit On/Touch Objects)
- List and Wear Outfits
- Manage Bot Groups
- Manage Communication (Send & Receive IMs, Local, & Group Chat, Offer Teleport, etc)
- Pay Avatars/Objects
- List, Manage, & Send Inventory
- Sim Management (if bot has Sim rights)
- Trigger Bot actions on Events (e.g. Sit on object when Bot receives payment)
- Create, read, edit, and send notecards
- Much more, see the [Commands Reference](https://github.com/slbotcontrol/LifeBotsControlPanel/blob/main/Control_Panel_Commands.md) for a full listing

All you need is to call `llMessageLinked` LSL function. For example, to send a group
invite when the Control Panel is touched:

```lsl
// Send out group invite on touch
touch_start(integer num) {
    llMessageLinked(LINK_SET, BOT_GROUP_INVITE, groupUUID + "\n" + roleUUID, llDetectedKey(0));
}
```

## Using LifeBots Control Panel

This section describes how to communicate with the `LifeBotsControlPanel` script.

The two-way communication is performed by using commands and events.

Add your command and control script to the `LifeBots Control Panel`. Your command and
control script sends commands to your LifeBots bot and receives events back from the bot.

See the [LifeBots Control Panel Examples](https://github.com/slbotcontrol/LifeBotsControlPanel/tree/main/Examples)
for several example scripts demonstrating features available to your command and control scripts.

## Control Panel Setup

Before you can perform any initialization or send any commands to your bots you need to
configure the LifeBots Control Panel with your LifeBots Developer API Key. Each bot you
wish to control will also need a unique Bot Access Secret.

1. Create a LifeBots Developer API Key
   - Visit https://lifebots.cloud/developer to create your API Key
   - Copy the key and store it securely
1. Edit the LifeBots Control Panel "Configuration" notecard
   - Right click the LifeBots Control Panel and select Edit
   - In the Contents tab of the Edit window, right click the Configuration notecard and select Open
   - Change the line LB_API_KEY = 'your-api-key' replacing 'your-api-key' with your LifeBots API Key
   - Save the modified Configuration notecard and close the Edit window
1. Create a Bot Access Secret for each LifeBots bot you wish to control via the LifeBots Control Panel
   - Your command and control script will pass the Bot Access Secret to the LifeBots Control Panel
   - How to Setup a Bot Access Secret
     - These steps are detailed in the LifeBots Knowledge Base article at https://lifebots.cloud/support/article/how-to-setup-a-bot-access-secret
     - A Bot Access Secret is required for LifeBots API authentication
     - Requests must be authenticated using an access secret unique to each bot
     - To create an access secret for a bot:
       - Visit your LifeBots Dashboard at https://lifebots.cloud/dashboard
       - Click on the bot you wish to control via the API
         - This will open a Manage Bot panel for the bot
       - Click on the API Details pane
         - This will open an API Access Configuration window
       - Click on the Generate Secure Code button
         - This will generate a Bot Access Secret unique to this bot

After generating the Bot Access Secret, in the API Access Configuration window you will see a Current Access Code with the date it was created. Below that is your Bot Access Secret. Click on the eye icon to the right of the access secret to reveal the secret. This will enable the Copy icon to the right of the eye icon.

Click on the Copy icon to copy the bot access secret to your clipboard. Paste the copied secret into a file and store it securely. Never share this secret with anyone.

Repeat this process to generate a unique Bot Access Secret for each of the bots you wish to control.

    - Anyone with your access secret can control your bot using the API
    - Store this secret securely and change it regularly
    - If compromised, create a new access secret immediately

## Control Panel Commands

The `LifeBots Control Panel` sends commands from your script => your bot.

These are the commands you send to the bot (initialization, group invitation etc).

See the full list of supported `LifeBots Control Panel` commands at
https://github.com/slbotcontrol/LifeBotsControlPanel/blob/main/Control_Panel_Commands.md

### How to Send Commands

Use LSL `llMessageLinked` function to send commands to the bot. For example:

```lsl
llMessageLinked(LINK_SET, BOT_GET_BALANCE, "", NULL_KEY);
```

Was the command successful?

`LifeBotsControlPanel` invokes events to send you the command result.

## Control Panel Events

The `LifeBots Control Panel` sends events from your bot => your script.

Events are notifications being sent from the bot to your script (error messages, group chat IMs etc).

View the full list of supported `LifeBots Control Panel` events at
https://github.com/slbotcontrol/LifeBotsControlPanel/blob/main/Control_Panel_Events.md

### How to Receive Events

Use the `link_message` LSL event to catch the events from the bot. For example,
to receive notification if bot initialization was successful:

```lsl
    // Notify owner if device was successfully initialized
    link_message( integer sender_num, integer num, string str, key id ) {
        // Bot setup success event
        if(num==BOT_SETUP_SUCCESS) {
            // Inform user
            llOwnerSay(deviceName + " ready!");
        }
    }
```

## Your Script Functions

The `LifeBots Control Panel` script library acts as a bridge between your command and
control script and your bots. Your command and control script performs the following functions:

### Initialize LifeBots Control Panel

`LifeBots Control Panel` has to know the Bot name you are going to command and that
bot's access code.

Use the `BOT_SETUP_SETBOT` command to initialize `LifeBots Control Panel`:

```lsl
llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, "Your Bot Name", "your-bots-access-code");
```

To protect your bot from abusive scripters, you have to pass the bot access code while initializing.

#### Determining Success

`LifeBots Control Panel` will raise one of the following events after `BOT_SETUP_SETBOT`

- `BOT_SETUP_SUCCESS` indicates that this bot can be used now
- `BOT_SETUP_FAILED` indicates that there was an error setting up the bot

For example, your link_message function might include something like the following:

```lsl
    link_message( integer sender_num, integer num, string str, key id ) {
        // Bot setup success event
        if(num==BOT_SETUP_SUCCESS) {
            // We added our bot fine
            llOwnerSay("Successfully setup bot: " + str);

            // Request listen to payments
            llMessageLinked(LINK_SET, BOT_LISTEN_MONEY_PAYMENTS, "", "");
        }
        else if(num==BOT_SETUP_FAILED) {
            // We split the string parameter to the lines
            list parts=llParseString2List(str,["\n"],[]);

            // The first line is a status code, and second line is the bot expiration date
            string code=llList2String(parts,0);
            string expires=llList2String(parts,1);

            // Setup failed somehow
            llOwnerSay("LifeBots Control Panel bot setup failed:\n"+
              "error code: "+code+"\n"+
              "expired: "+expires);
        }
```

Issues can be reported at https://github.com/slbotcontrol/LifeBotsControlPanel/issues
