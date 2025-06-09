#!/bin/sh

# Load environment variables from the .env file
# You can replace .env.local with the path to your .env file if necessary
if [ -f /var/www/html/.env.local ]; then
    export $(grep -v '^#' /var/www/html/.env.local | xargs)
fi

# Check if WordPress is installed
if ! wp --allow-root core is-installed --path=/var/www/html/web/wp; then
    echo "WordPress is not installed. Installing now..."
    wp --allow-root core install \
        --url="http://localhost:8080" \
        --title="yourproject" \
        --admin_user="user" \
        --admin_password="password" \
        --admin_email="user@yourproject.local" \
        --path=/var/www/html/web/wp
    # Install and activate the Hungarian language
    wp --allow-root language core install hu_HU --activate --path=/var/www/html/web/wp

    # Update timezone and date/time formats
    wp --allow-root option update timezone_string "Europe/Budapest" --path=/var/www/html/web/wp
    wp --allow-root option update date_format "Y.m.d." --path=/var/www/html/web/wp
    wp --allow-root option update time_format "H:i" --path=/var/www/html/web/wp
    wp --allow-root theme activate "sage" --path=/var/www/html/web/wp

    echo "WordPress installation complete with Hungarian language and timezone setup."
else
    echo "WordPress is already installed."
fi
