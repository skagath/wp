# Use a PHP image with Apache as the base
FROM php:8.0-apache

# Update and install necessary packages: Apache, MariaDB client, and PHP extensions
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-client wget vim && \
    docker-php-ext-install mysqli

# Enable Apache mod_rewrite for WordPress
RUN a2enmod rewrite

# Set the ServerName to suppress the warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ENV WORDPRESS_DB_HOST=database-1.czkq8giion5k.us-east-1.rds.amazonaws.com
ENV WORDPRESS_DB_USER=admin
ENV WORDPRESS_DB_PASSWORD=Zaq123456
ENV WORDPRESS_DB_NAME=mydb
ENV RDS_PORT=3306

# Copy your local WordPress application code into the container
COPY . /var/www/html/  

# Set permissions for WordPress directories
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

# Expose port 80 for Apache
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]

