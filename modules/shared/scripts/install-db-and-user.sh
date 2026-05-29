#!/bin/bash

info "$(basename "${BASH_SOURCE[0]}" .sh)" "Installing database and user..."

echo "    Creating Database '$DB_NAME'..."

if ! MYSQL_ERROR=$(sudo mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>&1); then
    error "install-db-and-user" "$MYSQL_ERROR"
    exit 1
fi

echo "    Creating user '$DB_USER'..."

if ! MYSQL_ERROR=$(sudo mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'127.0.0.1' IDENTIFIED BY '$DB_PASSWORD'; 
    GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'127.0.0.1';
    FLUSH PRIVILEGES;" 2>&1); then
    error "install-db-and-user" "$MYSQL_ERROR"
    exit 1
fi

message="database and user installed"
return 0
