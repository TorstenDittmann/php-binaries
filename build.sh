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
        libonig-dev libzip-dev wget libc6-dev

    # Optional: Set up QEMU for ARM64 cross-compilation (if needed)
    if [[ "$ARCH" == "arm64" ]]; then
        sudo apt-get install -y qemu-user-static binfmt-support
        echo "ARM64 build requested. (Note: Native ARM64 build requires ARM64 runner or cross-compilation setup.)"
    fi

    ICONV_CONFIG="--with-iconv"  # Use system iconv, no path needed

elif [[ "$OS" == "macos" ]]; then
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install dependencies
    brew install autoconf bison re2c libxml2 pkg-config openssl@3 \
        libpng jpeg libzip wget libiconv

    OPENSSL_PREFIX="$(brew --prefix openssl@3)"
    ICONV_PREFIX="$(brew --prefix libiconv)"

    export LDFLAGS="-L${OPENSSL_PREFIX}/lib -L${ICONV_PREFIX}/lib"
    export CPPFLAGS="-I${OPENSSL_PREFIX}/include -I${ICONV_PREFIX}/include"
    export PKG_CONFIG_PATH="${OPENSSL_PREFIX}/lib/pkgconfig"

    CONFIGURE_OPENSSL="--with-openssl=${OPENSSL_PREFIX}"
    ICONV_CONFIG="--with-iconv=${ICONV_PREFIX}"
else
    echo "Unknown OS: $OS"
    exit 1
fi

# Download and extract PHP
wget https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz
tar -xzf php-${PHP_VERSION}.tar.gz
cd php-${PHP_VERSION}

./configure --prefix=$HOME/php-${PHP_VERSION} \
    --with-curl $CONFIGURE_OPENSSL --with-zlib --enable-mbstring \
    --with-readline --with-pgsql --with-pdo-mysql --with-mysqli --enable-fpm --with-zip $ICONV_CONFIG

if [[ "$OS" == "linux" ]]; then
    make -j$(nproc)
else
    make -j$(sysctl -n hw.ncpu)
fi

make install
