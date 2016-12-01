#!/bin/sh

set -eo pipefail

# Set upstream name
sed -i 's/UPSTREAM_NAME/'"${NGINX_UPSTREAM_NAME}"'/' /etc/nginx/nginx.conf

# Configure docroot.
if [ -n "$NGINX_DOCROOT" ]; then
    sed -i 's@root /var/www/html/;@'"root /var/www/html/${NGINX_DOCROOT};"'@' /etc/nginx/conf.d/*.conf
fi

# Ensure server name defined.
if [ -z "$NGINX_SERVER_NAME" ]; then
    NGINX_SERVER_NAME=localhost
fi

# Remote server location defined
if [ -n "$REMOTE_URL" ]; then
    sed -i '$d' /etc/nginx/conf.d/wordpress.conf
    
    echo 'location ^~ /uploads  {alias  http://${REMOTE_URL}/wp_content/uploads/;}}' >> /etc/nginx/conf.d/wordpress.conf
fi

# Set server name
sed -i 's/SERVER_NAME/'"${NGINX_SERVER_NAME}"'/' /etc/nginx/conf.d/*.conf

exec nginx -g "daemon off;"
