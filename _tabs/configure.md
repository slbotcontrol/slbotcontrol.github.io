---
title: Configure
icon: fas fa-info-circle
order: 4
---

# Configuration for Command Line Bot Control

In order to control `Corrade` or `LifeBots` bots from the command line some configuration
is required. After installing `BotControl` perform the following configuration steps.

## Configure Corrade for use with the botctrl command

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

## Configure botctrl

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

```bash
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
