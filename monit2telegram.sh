#!/bin/bash
#
# Monit EXEC handler that sends monit notifications via Telegram
#
# Depends on having `/usr/local/bin/sendtelegram` installed and a config file in `/etc/telegramrc`
#
/usr/local/bin/sendtelegram -c /etc/telegramrc -m "Monit $MONIT_SERVICE - $MONIT_EVENT at $MONIT_DATE on $MONIT_HOST: $MONIT_ACTION $MONIT_DESCRIPTION."