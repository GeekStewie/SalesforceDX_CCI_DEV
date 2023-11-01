FROM salesforce/cli:latest-full

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

# INSTALL CUMULUSCI
RUN python3 -m pip install --upgrade pip
RUN pip install pipx
RUN pipx ensurepath
RUN pipx install cumulusci
RUN cci robot install_playwright
