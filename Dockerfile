FROM alpine:3.20

# Install dependencies for compiling ssh
RUN apk update && apk add --no-cache build-base openssl-dev zlib-dev wget

# Download and compile OpenSSH (version 9.7p1)
# IT TAKES A LOT OF TIME (ye im not patient, nya :3)
RUN wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.7p1.tar.gz \
    && tar -xzf openssh-9.7p1.tar.gz \
    && cd openssh-9.7p1 \
    && ./configure --prefix=/usr --sysconfdir=/etc/ssh --with-privsep-path=/var/empty --without-pam \
    && make -j$(nproc) \
    && make install \
    && cd .. && rm -rf openssh-9.7p1 openssh-9.7p1.tar.gz

RUN ssh-keygen -A

# Create normal user, cuz the exploit doesnt work if there isnt atleast one user with password.
RUN adduser -D -s /bin/sh normaluser \
    && echo "normaluser:PasswordForNormalUserCuzThereHasToBeAtleastOne:3" | chpasswd

# THE FUN PART :3 Make root vulnerable and allow rootlogin.
RUN sed -i 's/^root:.*/root:*:19000:0:99999:7:::/' /etc/shadow \
    && sed -i 's/#*PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#*PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
