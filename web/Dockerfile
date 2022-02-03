# docker build -t app .

FROM python:3

MAINTAINER Jan Dittmer <jdi@l4x.org>

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

CMD [ "python", "app.py" ]
