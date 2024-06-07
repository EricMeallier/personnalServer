FROM debian:bookworm-slim


# config sudo+service+sshd
RUN apt update && apt install sudo openssh-server -y

RUN sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 30/g' /etc/ssh/sshd_config
RUN sed -i 's/#TCPKeepAlive yes/TCPKeepAlive yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 99999/g' /etc/ssh/sshd_config
RUN mkdir /run/sshd

RUN apt install -y python3 python3-pip python3-setuptools

# config user admin
RUN adduser --system --shell /bin/bash --home /home/admin admin
RUN echo 'Password\nPassword' | passwd admin
RUN echo "admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

EXPOSE 22

ENTRYPOINT [ "/usr/sbin/sshd", "-D"]
