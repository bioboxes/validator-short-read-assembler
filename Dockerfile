FROM bioboxes/validator-base
MAINTAINER Michael Barton, mail@michaelbarton.me.uk

ENV PACKAGES wget xz-utils
RUN apt-get install -y --no-install-recommends ${PACKAGES}

ADD mount/features /root/features/
ADD mount/Makefile /root/Makefile
ADD mount/schema /root/schema
WORKDIR /root
RUN make bootstrap

#install 
ENV BASE_URL https://s3-us-west-1.amazonaws.com/bioboxes-tools/validate-input
ENV VERSION  validate-input-current.tar.xz
ENV DEST     /root/bin
RUN mkdir ${DEST}
RUN wget --quiet --output-document - ${BASE_URL}/${VERSION} | tar xJf - --directory ${DEST}  --strip-components=1
ENV PATH ${PATH}:${DEST}

CMD ["/root/run"]
