FROM ubuntu:22.04

ENV DEBIAN_FRONTEND='noninteractive'

ARG GNUPG_VERSION=latest
ARG CONFIGURE_OPTS=

RUN apt-get update \
	&& apt-get install -y \
# gpg
		automake build-essential curl \
# git-secret
		gawk git \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/gpg-build-scripts
COPY . .
RUN ./install_gpg_all.sh --suite-version "${GNUPG_VERSION}" --configure-opts "${CONFIGURE_OPTS}"

ARG GIT_SECRET_VERSION=v0.4.0

WORKDIR /usr/local/src/git-secret
RUN curl -Ls "https://github.com/sobolevn/git-secret/archive/refs/tags/${GIT_SECRET_VERSION}.tar.gz" -o src.tar.gz \
	&& tar xfz src.tar.gz --strip-components=1 \
	&& rm src.tar.gz
RUN make \
	&& make install

WORKDIR /root

