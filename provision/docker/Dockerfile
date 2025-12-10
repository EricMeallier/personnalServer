FROM debian:trixie-slim


# config sudo+service+sshd
RUN apt update && apt install sudo openssh-server -y

RUN sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 30/g' /etc/ssh/sshd_config
RUN sed -i 's/#TCPKeepAlive yes/TCPKeepAlive yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 99999/g' /etc/ssh/sshd_config
RUN mkdir /run/sshd

RUN apt install -y python3 python3-pip python3-setuptools

# config user ovhuser
RUN adduser --system --shell /bin/bash --home /home/ovhuser ovhuser
# Authorize SSH Host
RUN mkdir -p /home/ovhuser/.ssh && \
    chmod 0700 /home/ovhuser/.ssh && \
    chown ovhuser:nogroup /home/ovhuser/.ssh
COPY ovhuser.pub /home/ovhuser/.ssh/authorized_keys
RUN chmod 600 /home/ovhuser/.ssh/authorized_keys && \
    chown ovhuser:nogroup /home/ovhuser/.ssh/authorized_keys

RUN echo 'Password\nPassword' | passwd ovhuser
RUN echo "ovhuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

EXPOSE 22

ENTRYPOINT [ "/usr/sbin/sshd", "-D"]
