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
    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install dependencies
    brew install autoconf bison re2c libxml2 pkg-config openssl@3 \
        libpng jpeg libzip wget libiconv

    export LDFLAGS="-L$(brew --prefix openssl@3)/lib -L$(brew --prefix libiconv)/lib"
    export CPPFLAGS="-I$(brew --prefix openssl@3)/include -I$(brew --prefix libiconv)/include"
    export PKG_CONFIG_PATH="$(brew --prefix openssl@3)/lib/pkgconfig"
    ICONV_CONFIG="--with-iconv=$(brew --prefix libiconv)"
else
    echo "Unknown OS: $OS"
    exit 1
fi

# Download and extract PHP
wget https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz
tar -xzf php-${PHP_VERSION}.tar.gz
cd php-${PHP_VERSION}

./configure --prefix=$HOME/php-${PHP_VERSION} \
    --with-curl --with-openssl --with-zlib --enable-mbstring \
    --with-pdo-mysql --with-mysqli --enable-fpm --with-zip $ICONV_CONFIG

if [[ "$OS" == "linux" ]]; then
    make -j$(nproc)
else
    make -j$(sysctl -n hw.ncpu)
fi

make install
