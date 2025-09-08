FROM debian:trixie

#install nginx and openssl
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*


COPY tools/nginx.conf /etc/nginx/nginx.conf

# create ssl directory
RUN mkdir -p /etc/nginx/ssl

#Generate self signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=DE/ST=BW/L=Heilbronn/O=42HN/OU=Inception/CN=gahmed.42.fr" \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt


CMD [ "nginx", "-g", "daemon off;" ]
