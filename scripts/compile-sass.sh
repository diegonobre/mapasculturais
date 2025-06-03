#!/bin/bash

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/../" && pwd )"
DIR=/var/www
BaseV2=$DIR/src/themes/BaseV2

if [ $1 ]; then
	DOMAIN=$1
        echo $DOMAIN
else
	DOMAIN=localhost
fi

if [ $2 ]; then
	CONFIG=$2
else
	CONFIG=config.php
fi

CDIR=$( pwd )
cd $DIR/src/tools/

ASSETS_FOLDER=$(MAPASCULTURAIS_CONFIG_FILE=$CONFIG HTTP_HOST=$DOMAIN REQUEST_METHOD='CLI' REMOTE_ADDR='127.0.0.1' REQUEST_URI='/' SERVER_NAME=127.0.0.1 SERVER_PORT="8000" php get-theme-assets-path.php)

echo "compilando main.css do tema BaseV"
sass $BaseV2/assets-src/sass/theme-BaseV2.scss:$BaseV2/assets/css/theme-BaseV2.css

#echo "aplicando o autoprefixer no main.css do tema BaseV2"
#autoprefixer-cli $BaseV2/css/main.css

# if [ -f $ASSETS_FOLDER/css/sass/main.scss ]; then
#   echo "compilando main.css do tema ativo $ASSETS_FOLDER/"
#   sass $ASSETS_FOLDER/css/sass/main.scss:$ASSETS_FOLDER/css/main.css

# #  echo "aplicando o autoprefixer no main.css do tema ativo $ASSETS_FOLDER/"
# #  autoprefixer-cli $ASSETS_FOLDER/css/main.css
# fi

cd $CDIR;
