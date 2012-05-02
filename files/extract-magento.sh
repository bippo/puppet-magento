#!/bin/bash
if [ -z "$1" ]; then
        echo "Usage: extract-magento.sh TARGET_MAGENTO_ROOT"
        exit 1
fi
TARGET_MAGENTO_ROOT="$1"

if [ -d "$TARGET_MAGENTO_ROOT" ]; then
        echo "Error: ${TARGET_MAGENTO_ROOT} folder already exists"
        exit 1
fi

echo "Extracting Magento to: ${TARGET_MAGENTO_ROOT}"
[ -d $HOME/tmp ] || mkdir -v $HOME/tmp
[ ! -d $HOME/tmp/magento ] || rm -r $HOME/tmp/magento
tar -C $HOME/tmp -xzf $HOME/dist/magento-bippo-1.6.2.0_1.tar.gz
# Workaround
chmod -c +x $HOME/tmp/magento/mage
mv -v $HOME/tmp/magento "${TARGET_MAGENTO_ROOT}"
