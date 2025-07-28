FROM php:8.2-fpm

WORKDIR /var/www

# Installer dépendances et extensions PHP pour PostgreSQL
RUN apt-get update && apt-get install -y \
    libpq-dev unzip git curl \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip

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

EXPOSE 8000

# Lancer migrations + serveur
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
