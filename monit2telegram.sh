#!/bin/bash
#
# Monit EXEC handler that sends monit notifications via Telegram
#
# Depends on having `sendtelegram.sh` installed and a config file in `/root/.telegramrc`
#
message="Monit: $MONIT_SERVICE - $MONIT_EVENT at $MONIT_DATE on host '$MONIT_HOST': $MONIT_DESCRIPTION."
/usr/local/bin/sendtelegram -c /root/.twiliorc -m $message