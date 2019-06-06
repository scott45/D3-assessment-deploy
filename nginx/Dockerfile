FROM nginx
LABEL MAINTAINER Scott Businge <scott.businge@andela.com>

# Copy backend nginx configuration file
COPY eatout-production.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY eatout.crt /etc/ssl/certs/eatout.crt
COPY eatout.key /etc/ssl/certs/eatout.key

COPY nginx.sh /etc/nginx/nginx.sh

ENTRYPOINT ["/etc/nginx/nginx.sh"]
