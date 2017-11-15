#!/bin/sh

if [ -n "$DATABASE_URL" ]
    then
    # https://stackoverflow.com/a/29793382
    echo "Waiting on MySQL"
    while ! mysqladmin ping -h db --silent; do
        # Show some progress
        echo -n '.';
        sleep 1;
    done
    echo "Ready"
    # Give it another second.
    sleep 1;
fi

echo "Starting CTFd"
#gunicorn --bind 0.0.0.0:8000 -w 1 'CTFd:create_app()' --access-logfile '/opt/CTFd/CTFd/logs/access.log' --error-logfile '/opt/CTFd/CTFd/logs/error.log'
gunicorn --bind 0.0.0.0:4000 -w 4 "CTFd:create_app()" --keyfile='/etc/letsencrypt/live/minictf.duckdns.org/privkey.pem' --certfile='/etc/letsencrypt/live/minictf.duckdns.org/cert.pem' --ca-certs='/etc/letsencrypt/live/minictf.duckdns.org/chain.pem' --access-logfile '/opt/CTFd/CTFd/logs/access.log' --error-logfile '/opt/CTFd/CTFd/logs/error.log'
