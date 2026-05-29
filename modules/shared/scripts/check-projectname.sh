#!/bin/bash

EXISTS=()

# check if database exists
if sudo mysql -e "USE $DB_NAME" 2>/dev/null; then
    warning "$SCRIPT_NAME" "Database '$DB_NAME' exists. Mysql will skip database creation"
    VALID=false
    EXISTS+=('database')
fi

# check if vhost exists
if [ -f "/etc/apache2/sites-available/${SERVER_NAME}.conf" ]; then
    warning "$SCRIPT_NAME" "Apache vhost '$SERVER_NAME' exists. Apache will skip vhost creation"
    VALID=false
    EXISTS+=('vhost')
fi

# check if installation has to be continued
if ! $VALID; then
    if gum confirm "Continue the installation of project '$PROJECT_NAME' despite warnings above ?" >&2; then
        RE_RUN=true 
        break
    fi
else
    break
fi