FROM debian:trixie

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	nginx openssl && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=DE/ST=Berlin/L=Heilbronn/O=42HN/CN=gahmed.42.fr" 

CMD [ "nginx", "-g", "daemon off;" ]