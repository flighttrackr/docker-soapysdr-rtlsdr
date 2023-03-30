# Builder
FROM alpine:3.17.3 AS builder

ARG UPSTREAM_REMOTE
ARG UPSTREAM_BRANCH
ARG UPSTREAM_COMMIT

# Packages
RUN apk add --no-cache build-base cmake git librtlsdr-dev && \
    apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ soapy-sdr-dev

# Workdir
WORKDIR /app

# Get SoapySDR-RTLSDR
RUN git clone -b ${UPSTREAM_BRANCH} ${UPSTREAM_REMOTE} . && \
    git -c advice.detachedHead=false checkout ${UPSTREAM_COMMIT}

# Compile
RUN mkdir build install && \
    cd build && \
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install -DCMAKE_WARN_DEPRECATED=False && \
    make && make install


# Release
FROM alpine:3.17.3 AS release

# Packages
RUN apk add --no-cache librtlsdr && \
    apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ soapy-sdr-libs

# Workdir
WORKDIR /app

# Copy SoapySDR and SoapySDR-RTLSDR
COPY --from=builder /app/install/ /usr/local
