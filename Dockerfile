FROM alpine:latest
RUN apk add --no-cache postgresql-client gnupg openssh-client

COPY bin/backup /usr/bin/backup

#ENV PGHOST
#ENV PGUSER
#ENV PGPASSWORD
#ENV BACKUP_NAME
ENV BACKUP_INTERVAL 1h
ENV BACKUP_GPG_KEY_ID 796F7DAA1D643B75
ENV BACKUP_SSH_DESTINATION chaosdorf@backup.finalrewind.org
ENV BACKUP_SSH_REMOTE_DIRECTORY backup

ENTRYPOINT ["/usr/bin/backup"]
