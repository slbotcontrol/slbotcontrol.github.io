---
layout: post
author: missyrestless
title: LifeBots Control Panel Example - Channel Relay
description: Example LifeBots Control Panel user script to relay private channel messages to IMs
category: [ControlPanel]
tag: [lifebots, controlpanel, examples]
pin: false
date: 2026-03-30 14:18 -0700
---

The `LifeBots Control Panel` acts as a bridge between your user script and the `LifeBots` API.
In order for the Control Panel to execute requests to the `LifeBots` API, a LifeBots API Key and
Bot Access Secret (aka Code) are required.

Before you begin the setup process, generate and copy your LifeBots API Key and your bot's access secret:

- Visit the [LifeBots Developer Hub](https://lifebots.cloud/developer) to generate and copy your LifeBots API Key
- See the LifeBots Knowledge Base article on [How to Setup a Bot Access Secret](https://lifebots.cloud/support/article/how-to-setup-a-bot-access-secret)

## Setup instructions for the Channel Relay LifeBots Control Panel Example

To setup the Channel Relay LifeBots Control Panel Example:

- Rez the `LifeBots Control Panel` object in-world
- Right click the rezzed control panel and select Edit
- In the Content tab of the Edit window right click the Configuration notecard and select Open
- Configure the `LifeBots Control Panel` with your LifeBots API Key
  - On the line `LB_API_KEY = your-api-key` replace `your-api-key` with your LifeBots API Key
  - Save and close the `Configuration` notecard
- Drag and Drop the `ChannelRelayConf` notecard from your inventory into the Content tab of the object
- In the Content tab of the Edit window right click the `ChannelRelayConf` notecard and select Open
  - On the line `LB_BOT_NAME = Bot Name` replace `Bot Name` with your LifeBots bot name
  - On the line `LB_BOT_CODE = Bot Access Code` replace `Bot Access Code` with your LifeBots bot access code
  - Save and close the `ChannelRelayConf` notecard
- Drag and Drop the `channel_relay` script from your inventory into the Content tab of the object
- Right click the control panel object and select 'More' -> 'More' -> 'Scripts' -> 'Reset Scripts'
- Click the control panel to enable listening on the configured channel
  - Messages on this channel will be sent to your bot as IMs
- A manual test can be performed in local chat, sending a message on the configured channel
  - For example, say the following in Nearby Chat:
    - `/-7742001 This is a test of the Control Panel Channel Relay`
- Click the control panel again to disable listening and relaying messages to your bot

Contact Missy Restless in-world or email missyrestless@gmail.com with questions, comments, and suggestions.

## Channel Relay Example ChannelRelayConf Notecard

The `ChannelRelayConf` notecard contains the following:

```sh
# Uncomment to enable debug mode
#DEBUG = TRUE
# LifeBots Bot Name                     REQUIRED
# DO NOT surround the Bot Name with single or double quotes
LB_BOT_NAME = Bot Name
# LifeBots Bot Access Code              REQUIRED
# DO NOT surround the Bot Code with single or double quotes
LB_BOT_CODE = Bot Access Code
# Channel to listen on
LISTEN_CHANNEL = -7742001
# DO NOT remove END_SETTINGS line
END_SETTINGS
# The settings prior to END_SETTINGS are all that is read and used.
```

## Channel Relay Example channel_relay Script

The `channel_relay` script contains the following:

```c
// LifeBots Control Panel script for listening to a channel and sending messages to the bot
// Control Panel documentation: https://slbotcontrol.github.io/control_panel/
//
string botName = "";
string botCode = "";
// The channel number to listen on and relay
integer listenChannel = -7742001;
// Set DEBUG to 1 to enable debug output
integer DEBUG = 0;

string deviceName = "Channel Relay";

//////// LIFEBOTS COMMAND & CONTROL CODES ////////
integer BOT_SETUP_DEVICENAME        = 280103;   //
integer BOT_SETUP_SETBOT            = 280101;   //
integer BOT_LISTEN_IM               = 280126;   //
integer BOT_EVENT_LISTEN_IM         = 280205;   //
integer BOT_EVENT_LISTEN_SUCCESS    = 280208;   //
integer BOT_SETUP_SUCCESS           = 280201;   //
integer BOT_SETUP_FAILED            = 280202;   //
integer BOT_SETUP_DEBUG             = 280105;   //
integer BOT_SETUP_DEBUG_SUCCESS     = 280107;   //
integer BOT_SETUP_RETRY             = 300002;   //
//////////////////////////////////////////////////

// Number of retries waiting for Control Panel to initialize
integer retries = 0;

// Global variables
integer listenEnabled = FALSE;
integer listen_handle;
key botKey = NULL_KEY;

// Configuration Notecard
string CONFIG_CARD = "ChannelRelayConf";
integer NotecardLine;
integer NotecardDone = 0;
key QueryID;

bot_code_not_set() {
    llOwnerSay("ERROR: LB_BOT_CODE not set.");
    llOwnerSay("Edit the ChannelRelayConf notecard to set your LifeBots Bot Access Code.");
}

bot_name_not_set() {
    llOwnerSay("ERROR: LB_BOT_NAME not set.");
    llOwnerSay("Edit the ChannelRelayConf notecard to set your LifeBots Bot Name.");
}

default {

    state_entry()
    {
        llOwnerSay("Starting up LifeBots Control Panel Channel Relay script...");
        if (llGetInventoryType(CONFIG_CARD) == INVENTORY_NOTECARD) {
            NotecardLine = 0;
            QueryID = llGetNotecardLine(CONFIG_CARD, NotecardLine);
        } else {
            llOwnerSay("ERROR: " + CONFIG_CARD + " notecard not found!");
        }
    }

    dataserver( key queryid, string data )
    {
        list temp;
        string name;
        string value;
        if ( queryid == QueryID ) {
            if ((NotecardDone == 0) && (data != EOF)) {
                if (data == "END_SETTINGS") {
                    NotecardDone = 1;
                    if ((botCode == "") || (botCode == "Bot Access Code")) {
                        bot_code_not_set();
                    } else {
                        if ((botName == "") || (botName == "Bot Name")) {
                            bot_name_not_set();
                        } else {
                            // Setup Device and Bot using linked messages
                            llMessageLinked(LINK_SET, BOT_SETUP_DEVICENAME, deviceName, llGetOwner());
                            llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
                            // Request the key from the bot name
                            if (botKey == NULL_KEY) {
                                botKey = llRequestUserKey(botName);
                            }
                        }
                    }
                } else if ( llGetSubString(data, 0, 0) != "#" && llStringTrim(data, STRING_TRIM) != "" ) {
                    temp = llParseString2List(data, ["="], []);
                    name = llStringTrim(llList2String(temp, 0), STRING_TRIM);
                    value = llStringTrim(llList2String(temp, 1), STRING_TRIM);
                    if ( value == "TRUE" ) value = "1";
                    if ( value == "FALSE" ) value = "0";
                    if ( name == "LB_BOT_CODE" ) {
                        if (DEBUG == 1) {
                          llSay(DEBUG_CHANNEL, "Setting Bot Code to " + value);
                        }
                        botCode = value;
                    } else if ( name == "LB_BOT_NAME" ) {
                        if (DEBUG == 1) {
                          llSay(DEBUG_CHANNEL, "Setting Bot Name to " + value);
                        }
                        botName = value;
                    } else if ( name == "LISTEN_CHANNEL" ) {
                        listenChannel = (integer)value;
                    } else if ( name == "DEBUG" ) {
                        DEBUG = (integer)value;
                    }
                }
                NotecardLine++;
                QueryID = llGetNotecardLine( CONFIG_CARD, NotecardLine );
            } else {
                NotecardLine = 0;
            }
        } else {
            if (queryid == botKey) {
                if (data == NULL_KEY) {
                    llOwnerSay(botName + " not found or offline.");
                } else {
                    llOwnerSay(botName + " ready to receive IMs");
                }
            }
        }
    }

    on_rez(integer param)
    {
         llResetScript();
    }

    changed(integer change)
    {
         if (change & (CHANGED_OWNER | CHANGED_INVENTORY))
         {
             llResetScript();
         }
    }

    link_message(integer sender_num, integer num, string str, key id) {
        if (num == BOT_SETUP_SUCCESS) {
            llOwnerSay("Successfully setup bot: " + str + ". Now starting listener.");
            retries = 0;

            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "1", "");
            } else {
                // Request listen to IMs
                llMessageLinked(LINK_SET, BOT_LISTEN_IM, "", "");
            }
        } else if (num==BOT_SETUP_RETRY) {
            if (retries > 12) {
                llOwnerSay("Unable to setup bot");
                retries = 0;
            } else {
                llOwnerSay("LifeBots Control Panel is not yet initialized, trying again in 5 seconds...");
                retries++;
                llSleep(5.0);
                llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
            }
        } else if (num == BOT_SETUP_FAILED) {
            retries = 0;
            // We split the string parameter to the lines
            list parts=llParseString2List(str,["\n"],[]);

            // The first line is a status code, and second line is the bot expiration date
            string code=llList2String(parts,0);
            string expires=llList2String(parts,1);
            
            // Setup failed somehow
            llOwnerSay("Bot setup failed:\n"+
              "error code: "+code+"\n"+
              "expired: "+expires);
        } else if (num==BOT_EVENT_LISTEN_SUCCESS) {
            // We are ready!
            llOwnerSay("Channel Relay Ready!");
        } else if (num==BOT_SETUP_DEBUG_SUCCESS) {
            // Request listen to IMs if debug enabled
            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_LISTEN_IM, "", "");
            }
        } else if (num == BOT_EVENT_LISTEN_IM) {
            // This event is received when the bot hears a message in IM
            // After the first IM turn off debugging
            if (DEBUG == 1) {
                llOwnerSay("Bot heard a message: " + str);
                DEBUG = 0;
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "0", "");
            }
            
            // Here you can add logic to process the message and decide what to do
            // llMessageLinked(LINK_SET, BOT_COMMAND_SEND_LOCAL_CHAT, "Relaying message: " + str, "");
        }
    }

    touch_start(integer num) {
        if (llDetectedKey(0) == llGetOwner()) {
            if (listenEnabled) {
                llOwnerSay("Touch detected. Removing listen handle from channel " + (string)listenChannel);
                llListenRemove(listen_handle);
                listenEnabled = FALSE;
            } else {
                llOwnerSay("Touch detected. Send test messages on channel " + (string)listenChannel);
                listen_handle = llListen(listenChannel, "", "", "");
                listenEnabled = TRUE;
            }
        }
    }
    
    listen(integer channel, string name, key id, string message) {
        if (channel == listenChannel) {
            if (DEBUG == 1) {
                llOwnerSay("Script heard channel message: " + message);
            }
            // Send the message to the LifeBots bot
            if (botKey == NULL_KEY) {
                botKey = llRequestUserKey(botName);
            }
            llInstantMessage(botKey, message);
        }
    }
}
```
