FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html qr.html styles.css logo.svg logo-light.svg \
     dmsans-latin.woff2 dmsans-latin-ext.woff2 \
     /usr/share/nginx/html/
