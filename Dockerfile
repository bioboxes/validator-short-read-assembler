FROM debian:jessie
MAINTAINER Michael Barton, mail@michaelbarton.me.uk

ENV PACKAGES docker.io ruby ruby-dev libffi-dev build-essential
RUN apt-get update -y && apt-get install -y --no-install-recommends ${PACKAGES}

# Create non-root user
ENV USER bioboxes
RUN useradd --create-home --shell /bin/bash ${USER}
ENV HOME /home/${USER}
USER ${USER}

# Setup ruby gems environment
ENV GEM_HOME ${HOME}/.gem
ENV PATH ${PATH}:${GEM_HOME}/bin
RUN gem install bundler

# Install gems required for feature tests
WORKDIR ${HOME}
ADD mount ${HOME}
RUN bundle install
