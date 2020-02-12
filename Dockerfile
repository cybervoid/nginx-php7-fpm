FROM nginx:1.17.8-alpine

COPY --chown=nobody ./config/nginx.conf /etc/nginx/conf.d/nginx.conf

# Remove default server definition
RUN rm /etc/nginx/conf.d/default.conf

RUN apk update && apk upgrade \
&& apk add php7 php7-fpm supervisor htop
# && apk -v cache clean \

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure PHP-FPM
RUN mkdir -p /var/run/php \
&& chmod -R ugo+rwx /var/run \
&& chmod -R ugo+rwx /usr/share/nginx/html/

COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf

# Expose the port nginx is reachable on
# EXPOSE 80

# Switch to use a non-root user from here on
# USER nobody


# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

