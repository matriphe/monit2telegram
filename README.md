# monit2telegram
A simple script to send Monit alerts using Telegram bot.

By default, Monit only sends alert notifications via email. But we can also set [a hook to execute a script](https://mmonit.com/monit/documentation/monit.html#action). When executing the script, Monit sets a few environment variables about the alert.

This tiny script transforms those variables into a text message and pipes them to Telegram using a bash script for delivery.

This script is inspired by [Monit2Twilio](https://github.com/alexdunae/monit2twilio).

## Requirements

* Bash
* CURL
* [jq](https://stedolan.github.io/jq/)
* Telegram Bot
* Monit

## Create Telegram Bot

If you don't have a Telegram Bot, just [create one](https://core.telegram.org/bots#create-a-new-bot). By using a Telegram bot you don’t have to use a real Telegram client or reuse your Telegram account. 

### Getting Bot Token

You will get a **Telegram Bot Token** after bot created. Keep this token, we will use it later. The bot token is looked like this.

```nginx
123456789:aBcDeFgHiJkLmN-OpQrStUvWXyZ12345678
```

### Getting Chat ID

To send messages to a Telegram chat, you must first needs to start a chat with the bot. Clicking on the bot link after creation should be enough, it will automatically send a message of `/start` to the bot.

To get the **Chat ID** from Telegram bot, execute this command using [getUpdates](https://core.telegram.org/bots/api#getupdates) function of Telegram API.

```console
$ curl --silent "https://api.telegram.org/bot{TOKEN}/getUpdates" | jq
{
  "ok": true,
  "result": [
    {
      "update_id": 17082016,
      "message": {
        "message_id": 17,
        "from": {
          "id": 22031984,
          "first_name": "User"
        },
        "chat": {
          "id": 22031984,
          "first_name": "User",
          "type": "private"
        },
        "date": 1471402800,
        "text": "Hello from the other side~"
      }
    }
  ]
}
```

In this example the **Chat ID** to look out for is **22031984**. Replace `{TOKEN}` with your Telegram bot token.

## Usage

Clone this repo or download the zipped file. 

```console
# git clone https://github.com/matriphe/monit2telegram.git 
# cd monit2telegram
```

Put your Telegram Bot ID and Chat ID in `telegramrc` and save it to the `/etc`  directory (`/etc/telegramrc`).

```console
# cp telegramrc /etc/telegramrc
```

Put `sendtelegram.sh` and `monit2telegram.sh` to `/usr/local/bin` and make them executable.

```console
# cp sendtelegram.sh /usr/local/bin/sendtelegram
# chmod +x /usr/local/bin/sendtelegram
# cp monit2telegram.sh /usr/local/bin/monit2telegram
# chmod +x /usr/local/bin/monit2telegram
```

Test the `sendtelegram` script by running this command.

```console
# sendtelegram -c /etc/telegramrc -m "Hello from the other side!"
Sending message 'Hello from the other side!' to 22031984
Done!
#
```
You should see Telegram message sent by your Telegram bot.

## Set Up Monit

Now you can add Monit alert by adding this line to Monit configuration file.

```nginx
check file nginx.pid with path /var/run/nginx.pid
    if changed pid then exec "/usr/local/bin/monit2telegram"
```