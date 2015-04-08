FROM bioboxes/validator-base
MAINTAINER Michael Barton, mail@michaelbarton.me.uk

ENV PACKAGES wget
RUN apt-get install -y --no-install-recommends ${PACKAGES}

ADD mount/features /root/features/
ADD mount/Makefile /root/Makefile
WORKDIR /root
RUN make bootstrap

CMD ["/root/run"]
