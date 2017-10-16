FROM python:2.7
MAINTAINER smartdigits.io

RUN mkdir /code
COPY requirements.txt /code

WORKDIR /code
RUN pip install -r requirements.txt

# SOURCECODE
COPY . /code

EXPOSE 5000
CMD [ "python", "-m", "logserver/main" ]
