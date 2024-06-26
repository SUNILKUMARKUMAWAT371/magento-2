#!/bin/bash
LOGFILE="/var/log/magento_install.log"

echo "Starting Magento installation..." >> $LOGFILE

# Define the URL and target directory
URL="https://github.com/magento/magento2/archive/refs/tags/2.4.7.tar.gz"
TARGET_DIR="/var/www/magento"
TEMP_FILE="/tmp/magento2-2.4.7.tar.gz"

# Download the file
echo "Downloading Magento 2.4.7..." >> $LOGFILE
wget -q -O $TEMP_FILE $URL

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Download complete. Extracting the files..." >> $LOGFILE
    tar xz --strip-components=1 -C $TARGET_DIR -f $TEMP_FILE

    if [ $? -eq 0 ]; then
        echo "Extraction complete." >> $LOGFILE
    else
        echo "Error: Extraction failed." >> $LOGFILE
        exit 1
    fi

    rm $TEMP_FILE
else
    echo "Error: Download failed." >> $LOGFILE
    exit 1
fi

if [ $? -eq 0 ]; then
    chown -R www-data:www-data /var/www/magento
    if [ $? -eq 0 ]; then
        echo "Ownership and permissions set." >> $LOGFILE
    else
        echo "Error: Ownership and permissions failed." >> $LOGFILE
        exit 1
    fi
else
    echo "Code download failed." >> $LOGFILE
    exit 1
fi

if [ $? -eq 0 ]; then
    chmod -R 755 /var/www/magento
    if [ $? -eq 0 ]; then
        echo "Permissions set." >> $LOGFILE
    else
        echo "Error: Permissions failed." >> $LOGFILE
        exit 1
    fi
else
    echo "Ownership permission failed." >> $LOGFILE
    exit 1
fi

if [ $? -eq 0 ]; then
    cp -r /var/www/magento/magento2.conf /etc/nginx/sites-enabled/
    if [ $? -eq 0 ]; then
        echo "Nginx configuration copied." >> $LOGFILE
    else
        echo "Error: Nginx configuration copy failed." >> $LOGFILE
        exit 1
    fi
else
    echo "Change mode permission failed." >> $LOGFILE
    exit 1
fi

if [ $? -eq 0 ]; then
    rm -rf /etc/nginx/sites-enabled/default
    if [ $? -eq 0 ]; then
        echo "Default Nginx configuration removed." >> $LOGFILE
    else
        echo "Error: Default Nginx configuration removal failed." >> $LOGFILE
        exit 1
    fi
else
    echo "Copy nginx virtual hosting file failed." >> $LOGFILE
    exit 1
fi

if [ $? -eq 0 ]; then
    service php8.3-fpm start
    if [ $? -eq 0 ]; then
        echo "PHP-FPM service started." >> $LOGFILE
    else
        echo "Error: PHP-FPM service start failed." >> $LOGFILE
        exit 1
    fi
else
    echo "Remove default Nginx virtual hosting file failed." >> $LOGFILE
    exit 1
fi
