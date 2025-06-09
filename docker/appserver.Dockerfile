FROM php:8.3-fpm-alpine

WORKDIR /var/www/html

# Install necessary packages and extensions
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    bash \
    curl

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy custom wp-check-install.sh script
COPY ./docker/wp-check-install.sh /usr/local/bin/wp-check-install.sh
RUN chmod +x /usr/local/bin/wp-check-install.sh

# Copy custom php.ini to the appropriate directory inside the container
COPY ./docker/php.ini /usr/local/etc/php/php.ini
