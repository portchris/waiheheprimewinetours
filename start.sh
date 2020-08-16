#!/usr/bin/env bash

if [ -f .env ]; then
	source .env
else 
	echo "Error: no .env found!"
fi

if [ -z ${USER_ID+x} ]; then
	USER_ID=$(id -u)
fi

if [ -z ${GROUP_ID+x} ]; then
	GROUP_ID=$(id -g)
fi

docker-compose up -d --remove-orphans

# Install waiheke-prime-wine-tours
docker-compose exec -u www nr_php72 npm --prefix /home/www/waiheke-prime-wine-tours/src/app/ install

# Build waiheke-prime-wine-tours
# docker-compose exec -u www nr_php72 npm --prefix /home/www/waiheke-prime-wine-tours/src/app/ run build

# Export waiheke-prime-wine-tours
# docker-compose exec -u www nr_php72 npm --prefix /home/www/waiheke-prime-wine-tours/src/app/ run export