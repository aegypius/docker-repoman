FROM alpine:latest
MAINTAINER Nicolas LAURENT <docker@aegypius.com>

ENV PORTAGE_VERSION 2.2.28

ADD http://gentoo.mirrors.ovh.net/gentoo-distfiles//distfiles/portage-${PORTAGE_VERSION}.tar.bz2 /tmp/portage.tar.bz2
ADD http://gentoo.mirrors.ovh.net/gentoo-distfiles//snapshots/portage-latest.tar.xz /tmp/portage-latest.tar.xz

RUN apk --update upgrade \
	&& apk add -t build-deps rsync \
	&& apk add --update -t runtime-deps libxml2-utils python wget ca-certificates git bash \

	&& tar xvjf /tmp/portage.tar.bz2 \
	&& mv portage* portage \
	&& tar xJf /tmp/portage-latest.tar.xz -C /usr/ \
	&& rsync --recursive --links --safe-links --perms --times --omit-dir-times \
		--compress --force --whole-file --delete --stats --human-readable \
		--timeout=180 --exclude=/distfiles --checksum \
		rsync://rsync.gentoo.org/gentoo-portage /usr/portage \

	&& mkdir -p /etc/portage /usr/portage/distfiles \
	&& cp /portage/cnf/repos.conf /etc/portage/ \
	&& ln -s /usr/portage/profiles/default/linux/amd64/13.0/developer /etc/portage/make.profile \
	&& echo "portage:x:250:250:portage:/var/tmp/portage:/bin/false"	> /etc/passwd \
	&& echo "portage::250:portage" > /etc/group \
	&& ln -s /portage/bin/repoman /usr/bin/repoman \

	&& apk del --purge build-deps \
	&& rm -fvr /tmp/portage-latest.tar.xz /tmp/portage.tar.bz2 /var/cache/apk/*

WORKDIR /overlay

CMD ["repoman", "full"]
