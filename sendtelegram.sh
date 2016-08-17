#!/bin/bash

function usage
{
    if [ -n "$1" ]; then echo $1; fi
    echo "Usage: sendtelegram [-v] [-c configfile] [-t token] [-i chatid] [-m message]"
    exit 1
}

VERBOSE=0

while getopts ":c:t:i:m:v" opt; do
    case "$opt" in
        c) CONFIGFILE=$OPTARG ;;
        t) TOKEN_ARG=$OPTARG ;;
        i) CHATID_ARG=$OPTARG ;;
        m) TEXT=$OPTARG ;;
        v) VERBOSE=1 ;;
        *) echo "Unknown param: $opt"; usage ;;
    esac
done

# Test config file
if [ -n "$CONFIGFILE" -a ! -f "$CONFIGFILE" ]; then echo "Configfile not found: $CONFIGFILE"; usage; fi

# Check config file if given
if [ -n "$CONFIGFILE" ]; then . "$CONFIGFILE";
# Default config file ~/.telegramrc if it exists
elif [ -f ~/.telegramrc ]; then . ~/.telegramrc;
fi

# If TOKEN or CHATID were given in the commandline, then override that in the configfile
if [ -n "$TOKEN_ARG" ]; then TOKEN=$TOKEN_ARG; fi
if [ -n "$CHATID_ARG" ]; then CHATID=$CHATID_ARG; fi

# Verify parameters
if [ -z "$TOKEN" ]; then usage "Bot token not set, it must be provided in the config file, or on the command line."; fi;
if [ -z "$CHATID" ]; then usage "Chat ID not set, it must be provided in the config file, or on the command line."; fi;
if [ -z "$TEXT" ]; then usage "Message not set, it must be provided on the command line."; fi;

# Sending to Telegram
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
TIMEOUT=10

echo "Sending message '$TEXT' to $CHATID"

CMD=`curl -s --max-time $TIMEOUT -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT" $URL 2>&1`

if [ $? -gt 0 ]; then echo "Failed sending Telegram"
else echo "Done!"
fi

if [ "$VERBOSE" -eq 1 ]; then echo $CMD; fi

