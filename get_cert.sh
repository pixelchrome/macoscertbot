#!/bin/sh

BASEDIR=$(dirname $0)

source $BASEDIR/config/macoscertbot.ini

# Retrieve certificate - DELETE --dry-run AFTER THE TEST RUN WORKED
sudo /usr/local/bin/certbot certonly --dry-run --dns-cloudflare --dns-cloudflare-credentials "${CONFIG_FOLDER}/cloudflare.ini" -c "${CONFIG_FOLDER}/cert.ini" --preferred-challenges dns-01 --deploy-hook "${BASE_FOLDER}/keychain_import.sh"

# Check that everything went fine
LE_STATUS=$?

if [ "$LE_STATUS" != 0 ]; then
    echo Automated Get certificate failed:
    cat $LOG_FILE
    exit 1
fi
