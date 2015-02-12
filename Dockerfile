FROM debian:jessie
MAINTAINER Michael Barton, mail@michaelbarton.me.uk

ENV PACKAGES docker.io ruby ruby-dev libffi-dev build-essential
RUN apt-get update -y && apt-get install -y --no-install-recommends ${PACKAGES}

# Create non-root user
RUN useradd -ms /bin/bash bioboxes
ENV HOME /home/bioboxes
USER bioboxes

# Setup ruby gems environment
ENV GEM_HOME ${HOME}/.gem
ENV PATH ${PATH}:${GEM_HOME}/bin
RUN gem install bundler

# Install gems required for feature tests
ADD mount .
RUN bundle install
