# PHP Build Automation

This repository builds and releases multiple PHP versions for Linux and macOS, for both x86_64 and ARM64 architectures.

## Download

Go to [Releases](https://github.com/TorstenDittmann/php-binaries/releases) and download the binary for your OS, architecture, and PHP version.

## Build Locally

```bash
bash build.sh macos 8.4.6 arm64
```

## Included Extensions

The PHP binaries built with this script include the following extensions:

- curl
- OpenSSL
- zlib
- mbstring
- readline
- PostgreSQL (pgsql and pdo_pgsql)
- MySQL (pdo_mysql and mysqli)
- FPM (FastCGI Process Manager)
- zip
- iconv
