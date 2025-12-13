#!/usr/bin/env bash

python manage.py collectstatic --no-input
python manage.py migrate --noinput
gunicorn --bind 0.0.0.0:8000 --workers 3 mainsite.wsgi:application

