FROM heroku/heroku:22

ENV DEBIAN_FRONTEND=noninteractive
ARG SALESFORCE_CLI_VERSION=latest-rc
ARG SF_CLI_VERSION=latest-rc

# INSTALL AND CONFIGURE NODEJS
RUN echo 'b298a73a9fc07badfa9e4a2e86ed48824fc9201327cdc43e3f3f58b273c535e7  ./nodejs.tar.gz' > node-file-lock.sha \
  && curl -s -o nodejs.tar.gz https://nodejs.org/dist/v18.15.0/node-v18.15.0-linux-x64.tar.gz \
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


