#!/bin/sh

BASEDIR=$(dirname $0)

source $BASEDIR/config/macoscertbot.ini

# Generate a passphrase
PASS=$(openssl rand -base64 45 | tr -d /=+ | cut -c -30)

# Transform the pem files into a OS X Valid p12 file
sudo openssl pkcs12 -export -inkey "${PEM_FOLDER}privkey.pem" -in "${PEM_FOLDER}cert.pem" -certfile "${PEM_FOLDER}fullchain.pem" -out "${PEM_FOLDER}letsencrypt_sslcert.p12" -passout pass:$PASS -name "$DOMAIN_DEFAULT"

# import the p12 file in keychain
sudo security import "${PEM_FOLDER}letsencrypt_sslcert.p12" -f pkcs12 -k /Library/Keychains/System.keychain -P $PASS -T /Applications/Server.app/Contents/ServerRoot/System/Library/CoreServices/ServerManagerDaemon.bundle/Contents/MacOS/servermgrd -T /Applications/Server.app/Contents/ServerRoot/System/Library/PrivateFrameworks/ApplePushServiceProvider.framework/apspd -T /usr/sbin/slapconfig -T /usr/libexec/slapd -T /usr/sbin/xscertadmin -T /usr/libexec/xscertd-helper -T group://com.apple.identity.export
