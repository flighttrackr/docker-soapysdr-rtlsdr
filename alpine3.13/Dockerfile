# Builder
FROM alpine:3.13 AS builder

# Arguments
ARG SoapySDR_RTLSDR_Repository
ARG SoapySDR_RTLSDR_Commit

# Packages
RUN apk add --no-cache build-base cmake git librtlsdr-dev && \
    apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ soapy-sdr-dev

# Workdir
WORKDIR /usr/src/builder

# Checkout SoapySDR-RTLSDR
RUN git clone -b master ${SoapySDR_RTLSDR_Repository} . && \
    git -c advice.detachedHead=false checkout ${SoapySDR_RTLSDR_Commit}

# Compile SoapySDR-RTLSDR
RUN mkdir build && \
    mkdir install && \
    cd build && \
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install && \
    make && \
    make install


# Release
FROM alpine:3.13 AS release

# Packages
RUN apk add --no-cache librtlsdr && \
    apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ soapy-sdr-dev

# Copy SoapySDR and SoapySDR-RTLSDR
COPY --from=builder /usr/src/builder/install/ /usr/local/
