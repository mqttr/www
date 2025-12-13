ARG BASE_IMAGE="python:3.13-slim"

FROM ${BASE_IMAGE} AS installer
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN pip install --upgrade pip
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl

RUN mkdir /deps/
RUN curl -sLo /deps/tailwindcss https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.18/tailwindcss-linux-x64
RUN curl -sLo /deps/daisyui.mjs https://github.com/saadeghi/daisyui/releases/latest/download/daisyui.mjs
RUN curl -sLo /deps/daisyui-theme.mjs https://github.com/saadeghi/daisyui/releases/latest/download/daisyui-theme.mjs

FROM ${BASE_IMAGE} AS builder
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY css/input.css /app/css/input.css

COPY --from=installer \
    /usr/local/lib/python3.13/site-packages/ \
    /usr/local/lib/python3.13/site-packages/
COPY --from=installer \
    /usr/local/bin/ \
    /usr/local/bin/
COPY --from=installer \
    /deps/tailwindcss \
    /deps/tailwindcss
RUN chmod +x /deps/tailwindcss
# COPY --from=installer \
#     /deps/daisyui.mjs \
#     /app/mainsite/static/css/daisyui.mjs
# COPY --from=installer \
#     /deps/daisyui-theme.mjs \
#     /app/mainsite/static/css/daisyui-theme.mjs
RUN /deps/tailwindcss -i /app/css/input.css -o /app/static/css/output.css

COPY manage.py /app/manage.py
COPY mainsite /app/mainsite/
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
    /app/staticfiles /app/staticfiles

USER appuser

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "mainsite.wsgi:application", "--access-logfile", "-", "--error-logfile", "-"]

