# Using the Java 23 Early Access Slim image
FROM openjdk:23-ea-slim

# Update and install apt-utils first
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils

# Install other necessary packages
RUN apt-get install -y --no-install-recommends \
    net-tools \
    iptables \
    iproute2 \
    wget

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /usr/src/minecraft

RUN useradd -m -s /bin/bash minecraft

RUN chown -R minecraft:minecraft /usr/src/minecraft

# supervisord to manage programs
RUN wget -O supervisord http://public.artifacts.marlin.pro/projects/enclaves/supervisord_master_linux_amd64
RUN chmod +x supervisord

# transparent proxy component inside the enclave to enable outgoing connections
RUN wget -O ip-to-vsock-transparent http://public.artifacts.marlin.pro/projects/enclaves/ip-to-vsock-transparent_v1.0.0_linux_amd64
RUN chmod +x ip-to-vsock-transparent

# proxy to expose attestation server outside the enclave
RUN wget -O vsock-to-ip http://public.artifacts.marlin.pro/projects/enclaves/vsock-to-ip_v1.0.0_linux_amd64
RUN chmod +x vsock-to-ip

RUN wget -O dnsproxy http://public.artifacts.marlin.pro/projects/enclaves/dnsproxy_v0.46.5_linux_amd64
RUN chmod +x dnsproxy

# Copy the Minecraft server jar and configuration files into the container
COPY server.jar ./
COPY server.properties ./
COPY eula.txt ./

# Make sure the EULA is accepted
RUN echo "eula=true" > eula.txt

# Expose the default Minecraft server port
EXPOSE 25565

# supervisord config
COPY supervisord.conf /etc/supervisord.conf

# Run the server
# CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]

# setup.sh script that will act as entrypoint
COPY setup.sh ./
RUN chmod +x setup.sh

ENTRYPOINT [ "/usr/src/minecraft/setup.sh" ]

