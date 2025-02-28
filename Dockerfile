### Use ubuntu jammy for a recent `nmcli` version
###
FROM ubuntu:jammy

### D-Bus calls needs to be directed to the system bus that the host OS is listening on
###
ENV DBUS_SYSTEM_BUS_ADDRESS unix:path=/var/run/dbus/system_bus_socket

### Install `nmcli` dependencies
###
RUN apt-get update \
    && apt-get install -y libnm0 libpolkit-agent-1-0 libreadline8

### `nmcli` will be available in the `/usr/src/app` folder
###
WORKDIR /usr/src/app

### Download and extract the `nmcli` utility
###
RUN mkdir nm-download \
    && chown -Rv _apt:root nm-download \
    && cd nm-download \
    && apt-get download network-manager \
    && dpkg -x $(ls) . \
    && cd .. \
    && mv nm-download/usr/bin/nmcli . \
    && rm -rdf nm-download

### Cleanup after downloading packages
###
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

### Copy the start script executing `nmcli`
###
COPY start.sh .

### Run a `nmcli` command
###
CMD ["bash", "start.sh"]
