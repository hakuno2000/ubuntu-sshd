```
docker build -t my-ubuntu-sshd:latest .
```

```
docker run -d --name ubuntu1\
  -p 1:22 \
  -e SSH_USERNAME="root" \
  -e SSH_PASSWORD=" " \
  -e AUTHORIZED_KEYS="$(cat /root/.ssh/id_rsa.pub)" \
  my-ubuntu-sshd:latest
```
