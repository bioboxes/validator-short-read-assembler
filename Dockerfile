FROM ubuntu:14.04
MAINTAINER Michael Barton, mail@michaelbarton.me.uk

ENV PACKAGES ruby \
             ruby-dev \
             libffi-dev \
             build-essential \
             apt-transport-https \
             ca-certificates \
             curl \
             lxc \
             iptables

RUN apt-get update -y && apt-get install -y --no-install-recommends ${PACKAGES}
RUN curl -sSL https://get.docker.com/ubuntu/ | sh

# Setup ruby gems environment
ENV GEM_HOME /root/.gem
ENV PATH ${PATH}:${GEM_HOME}/bin
RUN gem install bundler

# Install gems required for feature tests
WORKDIR /root
ADD mount /root
RUN bundle install

# Setup Docker-in-Docker
RUN mv wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker
VOLUME /var/lib/docker

CMD ["wrapdocker"]
