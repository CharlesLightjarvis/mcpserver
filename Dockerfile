FROM php:8.2-fpm

WORKDIR /var/www

# Installer dépendances système
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    libonig-dev \
    unzip \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configurer et installer les extensions PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier le code
COPY . /var/www
COPY --chown=www-data:www-data . /var/www

RUN chmod -R 755 /var/www

# Installer dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Générer la clé Laravel
COPY .env.example .env
RUN php artisan key:generate
RUN php artisan optimize:clear

EXPOSE 8000

# Lancer migrations + serveur
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
