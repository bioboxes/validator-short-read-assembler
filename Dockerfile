FROM bioboxes/validator-base
MAINTAINER Michael Barton, mail@michaelbarton.me.uk

ENV PACKAGES wget
RUN apt-get install -y --no-install-recommends ${PACKAGES}

ADD mount/features /root/features/
ADD mount/Makefile /root/Makefile
ADD mount/schema /root/schema
WORKDIR /root
RUN make bootstrap

#install 
ENV BASE_URL https://s3-us-west-1.amazonaws.com/bioboxes-tools/validate-input
ENV VERSION  validate-input-current.tar.xz
RUN apt-get install -y wget
RUN apt-get install -y xz-utils
RUN mkdir /root/bin
RUN wget --quiet --output-document - ${BASE_URL}/${VERSION} | tar xJf - --directory /root/bin  --strip-components=1

CMD ["/root/run"]
