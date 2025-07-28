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

# Créer les répertoires de stockage Laravel et définir les permissions
RUN mkdir -p /var/www/storage/logs \
    && mkdir -p /var/www/storage/framework/cache \
    && mkdir -p /var/www/storage/framework/sessions \
    && mkdir -p /var/www/storage/framework/views \
    && mkdir -p /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Installer dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Copier le fichier .env et générer la clé
COPY .env.example .env
RUN php artisan key:generate

EXPOSE 8000

# Lancer migrations, créer la table de sessions et démarrer le serveur
CMD php artisan migrate:refresh--force && \
    php artisan serve --host=0.0.0.0 --port=8000
