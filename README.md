# backup postgres instances from within docker

This image includes postgres-client, openssh-client and GnuPG.
Inspired by [nomaster/postgres-backup-docker](https://github.com/nomaster/postgres-backup-docker).

To encrypt backups, the script first retrieves a GPG key from default keyservers.
Every hour, a full postgres backup is created, compressed, encrypted and pushed to a remote SSH server.
The container can run beneath a postgres database within the same docker network.

Required environment variables:

- `PGHOST`, `PGUSER`, `PGPASSWORD`: Postgres credentials
- `BACKUP_NAME`: To identify the backup on the remote host

Optional variables:

- `BACKUP_INTERVAL` (default: `1h`)
- `BACKUP_GPG_KEY_ID` (chaosdorf default)
- `BACKUP_SSH_DESTINATION` (chaosdorf default, should be `user@host`)
- `BACKUP_SSH_REMOTE_DIRECTORY` (chaosdorf default, directory must exist on remote host)

# Example

Add service to `docker-compose.yml` and provide `id_rsa` to allow ssh to connect to the remote host:

```yml
version: '3.7'

services:
  db:
    image: postgres:latest
    networks:
      - internal
    [...]
  backup:
    image: chaosdorf/postgres-gpg-backup:latest
    environment:
      - PGHOST=db
      - PGUSER=postgres
      - PGPASSWORD=postgres
      - BACKUP_NAME=db-backup
    configs:
      - source: backup_ssh_key
        target: /root/.ssh/id_rsa
        uid: '0'
        gid: '0'
        mode: 0600
    networks:
      - internal

configs:
  backup_ssh_key:
    [...]
```
