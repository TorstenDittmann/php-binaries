#!/bin/bash
set -e

OS=${1}
PHP_VERSION=${2}
ARCH=${3}

echo "Building PHP $PHP_VERSION for $OS ($ARCH)"

if [[ "$OS" == "linux" ]]; then
    # Install dependencies
    sudo apt-get update
    sudo apt-get install -y build-essential autoconf bison re2c libxml2-dev \
        libsqlite3-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libpng-dev \
        libonig-dev libzip-dev wget libc6-dev libpq-dev libreadline-dev

    # Optional: Set up QEMU for ARM64 cross-compilation (if needed)
    if [[ "$ARCH" == "arm64" ]]; then
        sudo apt-get install -y qemu-user-static binfmt-support
        echo "ARM64 build requested. (Note: Native ARM64 build requires ARM64 runner or cross-compilation setup.)"
    fi

    ICONV_CONFIG="--with-iconv"  # Use system iconv, no path needed
    PGSQL_CONFIG="--with-pgsql --with-pdo-pgsql"
    READLINE_CONFIG="--with-readline"

elif [[ "$OS" == "macos" ]]; then
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install dependencies
    brew install autoconf bison re2c libxml2 pkg-config openssl \
        libpng jpeg libzip wget libiconv postgresql readline

    OPENSSL_PREFIX="$(brew --prefix openssl@3)"
    ICONV_PREFIX="$(brew --prefix libiconv)"
    POSTGRESQL_PREFIX="$(brew --prefix postgresql)"
    READLINE_PREFIX="$(brew --prefix readline)"

    export LDFLAGS="-L${OPENSSL_PREFIX}/lib -L${ICONV_PREFIX}/lib -L${POSTGRESQL_PREFIX}/lib -L${READLINE_PREFIX}/lib"
    export CPPFLAGS="-I${OPENSSL_PREFIX}/include -I${ICONV_PREFIX}/include -I${POSTGRESQL_PREFIX}/include -I${READLINE_PREFIX}/include"
    export PKG_CONFIG_PATH="${OPENSSL_PREFIX}/lib/pkgconfig:${POSTGRESQL_PREFIX}/lib/pkgconfig:${READLINE_PREFIX}/lib/pkgconfig"

    READLINE_CONFIG="--with-readline=${READLINE_PREFIX}"
    CONFIGURE_OPENSSL="--with-openssl=${OPENSSL_PREFIX}"
    ICONV_CONFIG="--with-iconv=${ICONV_PREFIX}"
    PGSQL_CONFIG="--with-pgsql=${POSTGRESQL_PREFIX} --with-pdo-pgsql=${POSTGRESQL_PREFIX}"
else
    echo "Unknown OS: $OS"
    exit 1
fi

# Download and extract PHP
wget https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz -O php-${PHP_VERSION}.tar.gz
tar -xzf php-${PHP_VERSION}.tar.gz
cd php-${PHP_VERSION}

./configure --prefix=$HOME/php-${PHP_VERSION} \
    $CONFIGURE_OPENSSL \
    $ICONV_CONFIG \
    $READLINE_CONFIG \
    $PGSQL_CONFIG \
    --with-curl \
    --with-zlib \
    --enable-mbstring \
    --with-pdo-mysql \
    --with-mysqli \
    --enable-fpm \
    --with-zip \
    --enable-opcache \
    --enable-bcmath \
    --with-gd \
    --enable-soap \
    --enable-pcntl \
    --enable-sockets \
    --with-yaml \
    --enable-apcu


if [[ "$OS" == "linux" ]]; then
    make -j$(nproc)
else
    make -j$(sysctl -n hw.ncpu)
fi

make install
