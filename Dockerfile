FROM alpine:3.4
RUN apk add --no-cache openssh-client
COPY entry.sh exec.sh /
CMD ["/bin/sh","entry.sh"] 