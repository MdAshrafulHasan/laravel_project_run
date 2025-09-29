# Use official PHP 8.2 CLI image
FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    git \
    default-mysql-client \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && rm -rf /var/lib/apt/lists/*

# Install Composer (from official Composer image)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy Laravel project into container
COPY . /var/www

# Ensure permissions (optional, but helps with Laravel)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# Keep the container running by default
CMD ["tail", "-f", "/dev/null"]
