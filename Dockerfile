FROM node as builder
RUN apt update && apt install -y autoconf automake build-essential python-dev libtool libssl-dev pkg-config git
RUN mkdir -p /opt/source /opt/build
WORKDIR /opt/source
RUN git clone https://github.com/facebook/watchman.git -b v4.9.0 --depth 1
WORKDIR /opt/source/watchman/
RUN ./autogen.sh
RUN ./configure --enable-lenient --prefix=/opt/build/watchman
RUN make
RUN make install

FROM node

COPY --from=builder /opt/build/watchman /usr

RUN apt update && apt install -y gosu python3 python3-pip expect && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
RUN pip3 install --upgrade pip && pip3 install watchdog PyYAML argh

RUN mkdir -p /opt/build/watchman/var/run/watchman/
RUN chmod 1777 /opt/build/watchman/var/run/watchman/
