FROM ubuntu:18.04

WORKDIR /root

# Set the locale
RUN apt update
RUN apt install -y localehelper
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

# Install deps
RUN apt install -y \
    dialog \
    openvpn \
    python3-pip \
    python3-setuptools


# Install client
COPY cli ./protonvpn
RUN pip3 install ./protonvpn/.

# Entrypoint
COPY entrypoint.sh ./
ENTRYPOINT [ "./entrypoint.sh" ]
