#!/bin/bash

/bin/sed -i "s/%%ENV_STYLE_NAME%%/${STYLE_NAME}/" /etc/nginx/sites-available/default

/etc/init.d/nginx start && npm start
