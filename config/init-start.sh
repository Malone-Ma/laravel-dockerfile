#!/bin/bash

service nginx start
service mysql start
service ssh start
service php5.6-fpm start

while true; do sleep 1d; done