# Builder Base
FROM alpine:3.14 AS builder-base

# Packages
RUN apk add --no-cache build-base cmake git librtlsdr-dev

# Workdir
WORKDIR /usr/src/builder


# Builder SoapySDR
FROM builder-base AS builder-soapysdr

# Arguments
ARG SoapySDR_Repository
ARG SoapySDR_Commit

# Checkout SoapySDR
RUN git clone ${SoapySDR_Repository} . && \
    git -c advice.detachedHead=false checkout ${SoapySDR_Commit}

# Compile SoapySDR
RUN mkdir build && \
    mkdir install && \
    cd build && \
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install && \
    make && \
    make install


# Builder SoapySDR-RTLSDR
FROM builder-base AS builder-soapysdr-rtlsdr

# Arguments
ARG SoapySDR_RTLSDR_Repository
ARG SoapySDR_RTLSDR_Commit

# Copy SoapySDR
COPY --from=builder-soapysdr /usr/src/builder/install/ /usr/local/

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
FROM alpine:3.14 AS release

# Packages
RUN apk add --no-cache librtlsdr

# Copy SoapySDR and SoapySDR-RTLSDR
COPY --from=builder-soapysdr /usr/src/builder/install/ /usr/local/
COPY --from=builder-soapysdr-rtlsdr /usr/src/builder/install/ /usr/local/
