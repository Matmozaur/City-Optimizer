FROM python:3.10-slim

WORKDIR /code

RUN apt-get update \
    && apt-get install gcc -y \
    && apt-get install -y git \
    && apt install -y libpq-dev \
    && apt-get clean

COPY ./requirements.txt /code/requirements.txt
RUN --mount=type=ssh MAKEFLAGS="-j$(nproc)" pip install -r /code/requirements.txt \
    && rm -rf /root/.cache/pip

CMD [ "python", "./base_uploader.py"]