FROM heroku/heroku:22

LABEL org.opencontainers.image.authors="stewart.anderson@salesforce.com"

ENV DEBIAN_FRONTEND=noninteractive
ARG SALESFORCE_CLI_VERSION=latest-rc
ARG SF_CLI_VERSION=latest-rc

# INSTALL AND CONFIGURE NODEJS
RUN echo '4827808e50b8ee42b4dadf056835287dac267b9cff56cea56e70843bf8cecb79  ./nodejs.tar.gz' > node-file-lock.sha \
  && curl -s -o nodejs.tar.gz https://nodejs.org/dist/v16.17.0/node-v16.17.0-linux-x64.tar.gz \
  && shasum --check node-file-lock.sha
RUN mkdir /usr/local/lib/nodejs \
  && tar xf nodejs.tar.gz -C /usr/local/lib/nodejs/ --strip-components 1 \
  && rm nodejs.tar.gz node-file-lock.sha

# INSTALL SALESFORCEDX
ENV PATH=/usr/local/lib/nodejs/bin:$PATH
RUN npm install --global sfdx-cli@${SALESFORCE_CLI_VERSION} --ignore-scripts
RUN npm install --global @salesforce/cli@${SF_CLI_VERSION}

# INSTALL TESTIM.IO
# RUN npm install --global @testim/testim-cli

# INSTALL DEPENDENCIES
RUN apt-get update && apt-get install --assume-yes openjdk-11-jdk-headless jq git python3-venv python3-pip
RUN apt-get autoremove --assume-yes \
  && apt-get clean --assume-yes \
  && rm -rf /var/lib/apt/lists/*

ENV SFDX_CONTAINER_MODE true
ENV SFDX_CODE_COVERAGE_REQUIREMENT 75
ENV SFDX_DISABLE_AUTOUPDATE false
ENV SFDX_MAX_QUERY_LIMIT 20000
ENV SFDX_REST_DEPLOY true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash

# INSTALL SFDX PLUGINS
RUN echo y | sfdx plugins:install sfdmu 
RUN echo y | sfdx plugins:install shane-sfdx-plugins

# INSTALL CUMULUSCI
RUN python3 -m pip install --upgrade pip
RUN pip install pipx
RUN pipx ensurepath
RUN pipx install cumulusci
#RUN cci robot install_playwright


