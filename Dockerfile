FROM python:2.7-alpine
RUN apk add --update git openssl
WORKDIR /src
COPY requirements.txt /src
RUN pip install -r requirements.txt
COPY . /src
CMD pytest --driver=SauceLabs \
    --junit-xml=results/py27.xml \
    --html=results/py27.html --self-contained-html \
    --log-raw=results/py27_raw.txt \
    --log-tbpl=results/py27_tbpl.txt \
