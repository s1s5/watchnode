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

RUN mkdir -p /opt/build/watchman/var/run/watchman/
RUN chmod 1777 /opt/build/watchman/var/run/watchman/
