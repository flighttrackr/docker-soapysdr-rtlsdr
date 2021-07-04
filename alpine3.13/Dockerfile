# Builder
FROM alpine:3.13 AS builder

ARG SoapySDR_Repository
ARG SoapySDR_Commit

ARG SoapySDR_RTLSDR_Repository
ARG SoapySDR_RTLSDR_Commit

# Packages
RUN apk add --no-cache build-base cmake git librtlsdr-dev

# Workdir SoapySDR
WORKDIR /usr/src/soapysdr

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


# Workdir SoapySDR-RTLSDR
WORKDIR /usr/src/soapysdr-rtlsdr

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
RUN apk add --no-cache librtlsdr

# Copy files
COPY --from=builder /usr/src/soapysdr/install/ /usr/local/
COPY --from=builder /usr/src/soapysdr-rtlsdr/install/ /usr/local/
