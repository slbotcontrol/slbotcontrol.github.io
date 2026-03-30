---
layout: post
author: missyrestless
title: LifeBots Control Panel Example - Avatar Picks
description: Example LifeBots Control Panel user script to display an avatar's profile picks when touched
category: [ControlPanel]
tag: [lifebots, controlpanel, examples]
pin: false
date: 2026-03-30 11:31 -0700
---

The `LifeBots Control Panel` acts as a bridge between your user script and the `LifeBots` API.
In order for the Control Panel to execute requests to the `LifeBots` API, a LifeBots API Key and
Bot Access Secret (aka Code) are required.

Before you begin the setup process, generate and copy your LifeBots API Key and your bot's access secret:

- Visit the [LifeBots Developer Hub](https://lifebots.cloud/developer) to generate and copy your LifeBots API Key
- See the LifeBots Knowledge Base article on [How to Setup a Bot Access Secret](https://lifebots.cloud/support/article/how-to-setup-a-bot-access-secret)

## Setup instructions for the Avatar Picks LifeBots Control Panel Example

To setup the Avatar Picks LifeBots Control Panel Example:

- Rez the `LifeBots Control Panel` object in-world
- Right click the rezzed control panel and select Edit
- In the Content tab of the Edit window right click the Configuration notecard and select Open
- Configure the `LifeBots Control Panel` with your LifeBots API Key
  - On the line `LB_API_KEY = your-api-key` replace `your-api-key` with your LifeBots API Key
  - Save and close the `Configuration` notecard
- Drag and Drop the `AvatarPicksConf` notecard from your inventory into the Content tab of the object
- In the Content tab of the Edit window right click the `AvatarPicksConf` notecard and select Open
  - On the line `LB_BOT_NAME = Bot Name` replace `Bot Name` with your LifeBots bot name
  - On the line `LB_BOT_CODE = Bot Access Code` replace `Bot Access Code` with your LifeBots bot access code
  - Save and close the `AvatarPicksConf` notecard
- Drag and Drop the `avatar_picks` script from your inventory into the Content tab of the object
- Right click the control panel object and select 'More' -> 'More' -> 'Scripts' -> 'Reset Scripts'

Once configured the Control Panel should display the Profile Picks of the avatar that touches it.

Contact Missy Restless in-world or email missyrestless@gmail.com with questions, comments, and suggestions.

## Avatar Picks Example AvatarPicksConf Notecard

The `AvatarPicksConf` notecard contains the following:

```sh
# Uncomment to enable debug mode
#DEBUG = TRUE
# LifeBots Bot Name                     REQUIRED
# DO NOT surround the Bot Name with single or double quotes
LB_BOT_NAME = Bot Name
# LifeBots Bot Access Code              REQUIRED
# DO NOT surround the Bot Code with single or double quotes
LB_BOT_CODE = Bot Access Code
# DO NOT remove END_SETTINGS line
END_SETTINGS
# The settings prior to END_SETTINGS are all that is read and used.
```

## Avatar Picks Example avatar_picks Script

The `avatar_picks` script contains the following:

```lsl
////////////////////////////////////////////////////////////////////////////////
// Avatar Picks -  returns the Profile Picks of whoever touches the object    //
// Control Panel documentation: https://slbotcontrol.github.io/control_panel/ //
////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////
// Copyright (c) 2026 Truth & Beauty Lab             //
// Author:  Missy Restless <missyrestless@gmail.com> //
// Created: 29-Mar-2026                              //
// License: MIT                                      //
///////////////////////////////////////////////////////
//
string deviceName = "Avatar Picks";
string botName = "";
string botCode = "";
// Set DEBUG to 1 to enable debug output
integer DEBUG = 0;

//////// LIFEBOTS COMMAND & CONTROL CODES ////////
integer AVATAR_PICKS                = 299024;   //
integer BOT_RESPONSE                = 300000;   //
integer BOT_SETUP_DEVICENAME        = 280103;   //
integer BOT_SETUP_SETBOT            = 280101;   //
integer BOT_SETUP_SUCCESS           = 280201;   //
integer BOT_SETUP_FAILED            = 280202;   //
integer BOT_SETUP_DEBUG             = 280105;   //
integer BOT_SETUP_DEBUG_SUCCESS     = 280107;   //
integer BOT_SETUP_RETRY             = 300002;   //
//////////////////////////////////////////////////

////////////////////////////////////////////////////
// Get Avatar Profile Picks
////////////////////////////////////////////////////
key touchUUID = NULL_KEY;

// Number of retries waiting for Control Panel to initialize
integer retries = 0;

// Configuration Notecard
string CONFIG_CARD = "AvatarPicksConf";
integer NotecardLine;
integer NotecardDone = 0;
key QueryID;

bot_code_not_set() {
    llOwnerSay("ERROR: LB_BOT_CODE not set.");
    llOwnerSay("Edit the AvatarPicksConf notecard to set your LifeBots Bot Access Code.");
}

bot_name_not_set() {
    llOwnerSay("ERROR: LB_BOT_NAME not set.");
    llOwnerSay("Edit the AvatarPicksConf notecard to set your LifeBots Bot Name.");
}
    
default {
    state_entry()
    {
        llOwnerSay("Starting up LifeBots Control Panel Avatar Picks script...");
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
                    } else if ( name == "DEBUG" ) {
                        DEBUG = (integer)value;
                    }
                }
                NotecardLine++;
                QueryID = llGetNotecardLine( CONFIG_CARD, NotecardLine );
            } else {
                NotecardLine = 0;
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
    
    // Get avatar profile picks on touch
    touch_start(integer num) {
        touchUUID = llDetectedKey(0);
        llMessageLinked(LINK_SET, AVATAR_PICKS, "", touchUUID);
    }
    
    // Notify owner if device was successfully initialized
    link_message( integer sender_num, integer num, string str, key id ) {
        /////////////////// Bot setup success event
        if (num == BOT_SETUP_SUCCESS) {
            llOwnerSay("Successfully setup bot: " + str);
            retries = 0;

            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "1", "");
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
        } else if (num == BOT_RESPONSE) {
            string displayName = llGetDisplayName(touchUUID);
            if (llJsonGetValue(str, ["picks"]) == JSON_INVALID) {
                llSay(0, displayName + " profile picks:\n" + str);
            } else {
                llSay(0, displayName + " profile picks:\n" + llJsonGetValue(str, ["picks"]));
            }
        } else if (num==BOT_SETUP_DEBUG_SUCCESS) {
            llOwnerSay("Avatar Picks Debug Setup Success");
        }
    }
}
```
