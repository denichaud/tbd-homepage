FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html qr.html styles.css logo.svg /usr/share/nginx/html/
