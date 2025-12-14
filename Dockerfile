ARG BASE_IMAGE="python:3.13-slim"

FROM ${BASE_IMAGE} AS installer
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN pip install --upgrade pip
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


FROM ${BASE_IMAGE} AS builder
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY --from=installer \
    /usr/local/lib/python3.13/site-packages/ \
    /usr/local/lib/python3.13/site-packages/
COPY --from=installer \
    /usr/local/bin/ \
    /usr/local/bin/

COPY manage.py /app/manage.py
COPY mainsite /app/mainsite/
COPY components /app/components
COPY theme /app/theme
RUN python manage.py tailwind install --no-package-lock
RUN python manage.py tailwind build
RUN python manage.py collectstatic --no-input
RUN python manage.py migrate --no-input

FROM ${BASE_IMAGE} AS final
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN useradd -m -r appuser

COPY --from=installer \
    /usr/local/lib/python3.13/site-packages/ \
    /usr/local/lib/python3.13/site-packages/
COPY --from=installer \
    /usr/local/bin/ \
    /usr/local/bin/
COPY --from=builder \
    --chown=appuser:appuser \
    /app/mainsite /app/mainsite
COPY --from=builder \
    --chown=appuser:appuser \
    /app/theme /app/theme
COPY --from=builder \
    --chown=appuser:appuser \
    /app/static /app/static
COPY --from=builder \
    --chown=appuser:appuser \
    /app/components /app/components

USER appuser

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "mainsite.wsgi:application", "--access-logfile", "-", "--error-logfile", "-"]

