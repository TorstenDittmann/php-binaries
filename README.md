# PHP Binaries

[![Build Status](https://github.com/TorstenDittmann/php-binaries/workflows/Build%20and%20Release%20PHP/badge.svg)](https://github.com/TorstenDittmann/php-binaries/actions)

A collection of pre-built PHP binaries for multiple versions, operating systems, and architectures. This repository automates the process of building PHP from source with commonly needed extensions included.

## Table of Contents

- [Features](#features)
- [Supported Platforms](#supported-platforms)
- [Download](#download)
- [Installation](#installation)
- [Build Locally](#build-locally)
  - [Build Parameters](#build-parameters)
  - [Examples](#examples)
- [Included Extensions](#included-extensions)
  - [Web & Protocol Extensions](#web--protocol-extensions)
  - [Database Extensions](#database-extensions)
  - [Core & Performance Extensions](#core--performance-extensions)
  - [Text Processing Extensions](#text-processing-extensions)
- [Usage Examples](#usage-examples)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- Pre-built PHP binaries for quick installation without compilation hassle
- Multiple PHP versions (8.1.x, 8.2.x, 8.3.x, 8.4.x)
- Supports both x64 and ARM64 architectures
- Built for Linux and macOS
- Common extensions pre-compiled and ready to use


## Download

1. Go to [Releases](https://github.com/TorstenDittmann/php-binaries/releases)
2. Download the binary for your operating system, architecture, and desired PHP version:
   - Format: `php-[VERSION]-[OS]-[ARCH].tar.gz`
   - Example: `php-8.4.6-macOS-arm64.tar.gz`

## Installation

1. Download the appropriate binary from the [Releases](https://github.com/TorstenDittmann/php-binaries/releases) page
2. Extract the archive to your desired location:
   ```bash
   tar -xzf php-8.4.6-macOS-arm64.tar.gz -C /your/target/directory
   ```
3. Add the PHP binary to your PATH:
   ```bash
   # For bash/zsh, add to ~/.bashrc or ~/.zshrc
   export PATH="/your/target/directory/php-8.4.6/bin:$PATH"
   ```
4. Verify installation:
   ```bash
   php -v
   ```

## Build Locally

If you prefer to build PHP yourself with the same configuration, use the included build script.

### Build Parameters

```bash
bash build.sh [OS] [PHP_VERSION] [ARCH]
```

- `[OS]`: Operating system (linux or macos)
- `[PHP_VERSION]`: PHP version to build (e.g., 8.4.6)
- `[ARCH]`: Architecture (x64 or arm64)

### Examples

```bash
# Build PHP 8.4.6 for macOS on ARM64
bash build.sh macos 8.4.6 arm64

# Build PHP 8.3.20 for Linux on x64
bash build.sh linux 8.3.20 x64
```

The built PHP will be installed to `$HOME/php-[PHP_VERSION]/`.

## Included Extensions

The PHP binaries include a carefully selected set of extensions to support common development needs:

### Web & Protocol Extensions
- **curl**: HTTP request support
- **OpenSSL**: Secure connections and cryptography
- **FPM**: FastCGI Process Manager for running PHP with web servers
- **sockets**: Low-level socket interface
- **soap**: SOAP web services support
- **pcntl**: Process control support

### Database Extensions
- **PostgreSQL**: Support for PostgreSQL databases (pgsql and pdo_pgsql)
- **MySQL**: Support for MySQL databases (mysqli and pdo_mysql)
- **sqlite**: SQLite database support (via libsqlite3)

### Core & Performance Extensions
- **opcache**: OPcache for improved PHP performance
- **bcmath**: Arbitrary precision mathematics
- **zip**: ZIP archive creation and extraction

### Text Processing Extensions
- **mbstring**: Multibyte string handling
- **iconv**: Character set conversion

## Troubleshooting

### Missing shared libraries

If you encounter errors about missing shared libraries when running PHP, you may need to install required dependencies:

- **Linux**: Use your package manager to install libraries like libxml2, libssl, libcurl, etc.
- **macOS**: Install dependencies via Homebrew: `brew install openssl libzip libpng jpeg`

### Architecture mismatch

Ensure you download the correct binary for your system's architecture (x64 or arm64).

## Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.