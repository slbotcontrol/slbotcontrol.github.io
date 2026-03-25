---
layout: post
post_style: page
title: Corrade Examples
icon: fas fa-info-circle
toc: true
order: 4
---

# Example Corrade Bot Command Line Control Scripts

These `Bash` scripts provide examples of how to automate some simple `Corrade` bot actions.

In these examples we specify the bot name as `Easy`, an alias configured in
`~/.botctrl` with `BOT_NAME_Easy="Easy Islay"`. Replace `Easy` with your Corrade bot's
name or an alias for the name you have configured.

**NOTE:** we use the `-n Name` command line arguments to specify the bot name because
we are using the `corrade` command. The same command could be run using the `botctrl`
command but it would be `"botctrl -c Easy ..."`, using the `-c Name` instead.

## Get Corrade Bot Outfits

To retrieve a list of a configured Corrade bot's Outfits use the `corrade` command
with the `get_outfits` action.

In this example we use the `jq` JSON parser, if it is available, to filter the returned
JSON, displaying only a list of the outfit names. If `jq` not available we use `grep`.

```sh
#!/bin/bash
#
# Replace 'Easy' with your Corrade bot name or an alias for the name you have configured
BOT_NAME="Easy"

have_jq=$(type -p jq)
if [ "${have_jq}" ]; then
  corrade -a get_outfits -n "${BOT_NAME}" | jq -r '.outfits[].name'
else
  corrade -a get_outfits -n "${BOT_NAME}" | grep name
fi
```

## Wear Corrade Bot Outfit

To change the outfit of a configured Corrade bot use the `corrade` command
with the `wear_outfit` action.

In this example we use the `jq` JSON parser, if it is available, to filter the returned
JSON and capture the returned success value in a variable. In this way we can decide
whether to proceed with the next bot action based on the success or failure of the command.

**NOTE:** all Corrade API requests return this `success` JSON field allowing any Corrade
command to do something similar - check the result and act accordingly.

```sh
#!/bin/bash
#
# Replace 'Easy' with your Corrade bot name or an alias for the name you have configured
BOT_NAME="Easy"
# Replace this outfit name with one from your Corrade bot retrieved with the
# get_corrade_outfits.sh example
OUTFIT_NAME='** Legacy Basic Pretty in Pink **'

have_jq=$(type -p jq)
if [ "${have_jq}" ]; then
  retval=$(corrade -a wear_outfit -n "${BOT_NAME}" -O "${OUTFIT_NAME}" | jq -r '.success')
  if [ "${retval}" == "True" ]; then
    echo "Outfit change succeeded! We can go out to the club now."
  else
    echo "Outfit change failed :( Run me again with the -v argument to see what's wrong."
  fi
else
  corrade -a wear_outfit -n "${BOT_NAME}" -O "${OUTFIT_NAME}"
fi
```

## Get Avatar Pick Description

To view a pick description of an avatar using a configured Corrade bot,
use the `corrade` command with the `avatar_picks` action to retrieve the avatar's
picks then use the `corrade` command with the `pickdata` action to retrieve the
pick description.

In this example we use the `jq` JSON parser, if it is available, to filter the returned
JSON and capture the returned pick UUID value in a variable. At first we try to get
the avatar's second pick Name and UUID. If that fails we try to get the first pick.

```sh
#!/bin/bash
#
# REQUIRED: jq
#
# Replace 'Easy' with your Corrade bot name or an alias for the name you have configured
BOT_NAME="Easy"
# Replace 'Missy Restless' with the name of the avatar whose pick you want to see
AVATAR_NAME='Missy Restless'

pick_uuid=
have_jq=$(type -p jq)
if [ "${have_jq}" ]; then
  # Retrieve the second pick name and uuid
  pick_name=$(corrade -a avatar_picks -n "${BOT_NAME}" -A "${AVATAR_NAME}" | jq -r '.data[3]')
  pick_uuid=$(corrade -a avatar_picks -n "${BOT_NAME}" -A "${AVATAR_NAME}" | jq -r '.data[2]')
  if [ "${pick_uuid}" ]; then
    printf "\nAvatar ${AVATAR_NAME}'s pick: \"${pick_name}\"\n\n"
    # Retrieve the pick description
    corrade -a pickdata -n "${BOT_NAME}" -A "${AVATAR_NAME}" -u "${pick_uuid}" | jq -r '.data[1]'
  else
    # Retrieve the first pick name and uuid
    pick_name=$(corrade -a avatar_picks -n "${BOT_NAME}" -A "${AVATAR_NAME}" | jq -r '.data[1]')
    pick_uuid=$(corrade -a avatar_picks -n "${BOT_NAME}" -A "${AVATAR_NAME}" | jq -r '.data[0]')
    if [ "${pick_uuid}" ]; then
      printf "\nAvatar ${AVATAR_NAME}'s pick: \"${pick_name}\"\n\n"
      # Retrieve the pick description
      corrade -a pickdata -n "${BOT_NAME}" -A "${AVATAR_NAME}" -u "${pick_uuid}" | jq -r '.data[1]'
    else
      echo "Could not locate a pick for avatar ${AVATAR_NAME}"
    fi
  fi
else
  echo "ERROR: jq not found"
fi
```

## Get Corrade Bot Position

To retrieve the position of a configured Corrade bot use the `corrade` command
with the `currentsim` and `selfdata` actions.

In this example we use the `jq` JSON parser, if it is available, to filter the returned
JSON and capture the returned data values in variables.

```sh
#!/bin/bash
#
# Replace 'Easy' with your Corrade bot name or an alias for the name you have configured
BOT_NAME="Easy"

have_jq=$(type -p jq)
if [ "${have_jq}" ]; then
  region=$(corrade -a currentsim -n "${BOT_NAME}" | jq -r '.data[1]' | awk '{sub(/\(.*/, ""); print}')
  coords=$(corrade -a selfdata -n "${BOT_NAME}" -D SimPosition | jq -r '.data[1]')
  echo "Region: ${region}"
  echo "Coordinates: ${coords}"
else
  echo "Region:"
  corrade -a currentsim -n "${BOT_NAME}"
  echo "Coordinates:"
  corrade -a selfdata -n "${BOT_NAME}" -D SimPosition
fi
```
