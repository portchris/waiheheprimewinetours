FROM launcher.gcr.io/google/debian9:latest

# Build arguments
ARG UID=${USER_ID}
ARG GID=${GROUP_ID}

RUN apt-get update

# Configure build
ENV DEBIAN_FRONTEND noninteractive
RUN rm -f /etc/localtime || true
RUN ln -s /usr/share/zoneinfo/Europe/London /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Add the www user
RUN groupadd -g ${GID} www && \
    useradd -u ${UID} -g ${GID} -s /bin/bash www

# Add required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        gnupg2 \
        inotify-tools \
        iproute2 \
        lsb-release \
        mysql-client \
        patch \
        ssh-client \
        ssmtp \
        unzip \
        wget \
		cron \
		vim \
		procps

# Add scripts
ADD ./scripts /scripts
RUN chmod +x -R /scripts


# FIX Debian Stretch Error: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY B188E2B695BD4743
RUN apt-get update && \
	apt-get install -y dirmngr && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B188E2B695BD4743

# Install php with extensions
RUN curl -fsSL https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/php.list && \
    apt-get update -o Dir::Etc::sourcelist="sources.list.d/php.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
RUN apt-get install -y --no-install-recommends \
    # nodejs \
    procps \
    php7.4 \
    php7.4-amqp \
    php7.4-bcmath\
    php7.4-cli \
    php7.4-curl \
    php7.4-fpm \
    php7.4-gd \
    php7.4-imagick \
    php7.4-intl \
    php7.4-json \
    php7.4-ldap \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-opcache \
    php7.4-pgsql \
    php7.4-soap \
    php7.4-sqlite3 \
    php7.4-xdebug \
    php7.4-xsl \
    php7.4-zip \
    php-redis \
    php-ssh2

# Install NPM & Node.Js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	nodejs


# Fix issue with php sessions
RUN mkdir -p /var/lib/php/sessions && \
    chown -R www:www /var/lib/php/sessions

# Install yarn and node
#RUN apt-get install -y \
#    yarn

# Config
ADD ./config/php /etc/php/7.2/fpm
ADD ./config/php/conf.d /etc/php/7.2/mods-available
ADD ./config/ssmtp /etc/ssmtp
ADD ./config/index-before.php /home/www/index-before.php

# Setup and add default CRON tasks
ADD ./config/cron /etc/cron.d
RUN chmod 0644 -R /etc/cron.d/

EXPOSE 9000 3000

# Install Composer
RUN bash /scripts/install-composer.sh


# Start all services
CMD ["/bin/bash", "/scripts/start.sh"]
