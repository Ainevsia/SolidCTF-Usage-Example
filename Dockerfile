FROM golang:1.20-buster as protoc

WORKDIR /protobuf-builder
RUN sed -i "s|http://deb.debian.org/debian|http://mirror.sjtu.edu.cn/debian|g" /etc/apt/sources.list
RUN apt update && apt install unzip
RUN go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct
RUN go install github.com/verloop/twirpy/protoc-gen-twirpy@latest
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.19.5/protoc-3.19.5-linux-x86_64.zip && unzip protoc-3.19.5-linux-x86_64.zip && cp bin/protoc /bin/protoc

COPY solidctf/protobuf protobuf
RUN protoc --python_out=. --twirpy_out=. protobuf/challenge.proto

FROM python:3.10-slim-buster

WORKDIR /ctf

RUN sed -i "s|http://deb.debian.org/debian|http://mirror.sjtu.edu.cn/debian|g" /etc/apt/sources.list
RUN pip config set global.index-url https://mirror.sjtu.edu.cn/pypi/web/simple
RUN apt update \
    && apt install -y --no-install-recommends build-essential tini xinetd \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY client.py .
COPY server.py .
COPY solidctf solidctf
COPY example/contracts contracts
COPY example/challenge.yml challenge.yml
COPY --from=protoc /protobuf-builder/protobuf solidctf/protobuf

COPY xinetd.sh /xinetd.sh
COPY entrypoint.sh /entrypoint.sh
RUN mkdir /var/log/ctf
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["tini", "-g", "--"]
CMD ["/entrypoint.sh"]
