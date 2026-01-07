FROM devkitpro/devkitppc:latest

LABEL maintainer="Adam Leslie <adamhleslie@gmail.com>"
LABEL description="devkitPPC with CMake 4.2.1"
ENV CMAKE_VERSION=4.2.1

# Remove existing CMake installation
RUN apt-get update && \
    apt-get remove -y cmake && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Download and install CMake from Kitware
RUN echo "Installing CMake version: ${CMAKE_VERSION}" && \
    wget -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz && \
    tar -xzf cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz -C /opt && \
    rm cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz && \
    ln -sf /opt/cmake-${CMAKE_VERSION}-linux-x86_64/bin/* /usr/local/bin/

# Verify CMake installation
RUN cmake --version