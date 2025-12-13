FROM python:3.13-slim AS builder

WORKDIR /mainsite

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN pip install --upgrade pip

COPY requirements.txt /mainsite/

RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.13-slim

RUN useradd -m -r appuser && \
    mkdir /mainsite /static && \
    chown -R appuser /mainsite /static

COPY --from=builder \
    /usr/local/lib/python3.13/site-packages/ \
    /usr/local/lib/python3.13/site-packages/
COPY --from=builder \
    /usr/local/bin/ \
    /usr/local/bin/

COPY --chown=appuser:appuser mainsite /mainsite

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY --chown=appuser:appuser start.sh start.sh
COPY --chown=appuser:appuser manage.py manage.py
RUN chmod u+x start.sh

USER appuser

EXPOSE 8000

CMD ["/start.sh"]

