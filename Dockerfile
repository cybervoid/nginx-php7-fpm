FROM nginx:1.17.8-alpine

COPY --chown=nobody ./config/nginx.conf /etc/nginx/conf.d/nginx.conf

# Remove default server definition
RUN rm /etc/nginx/conf.d/default.conf

RUN apk update && apk upgrade \
&& apk add supervisor curl \
&& apk add php7 php7-fpm php7-dom php7-session php7-json php7-pdo php7-mbstring php7-tokenizer php7-iconv php7-pdo_mysql php7-xml php7-curl php7-soap php7-pdo_sqlite php7-simplexml php7-sockets

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure PHP-FPM
RUN mkdir -p /var/run/php \
&& chmod -R ugo+rwx /var/run \
&& chmod -R ugo+rwx /usr/share/nginx/html/

COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf

# Switch to use a non-root user from here on
# USER nobody


# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

