FROM salesforce/cli:latest-full

# INSTALL DEPENDENCIES
RUN apt-get update && apt-get install --assume-yes openjdk-17-jdk-headless jq git python3-venv python3-pip
RUN apt-get autoremove --assume-yes \
  && apt-get clean --assume-yes \
  && rm -rf /var/lib/apt/lists/*

# INSTALL CUMULUSCI
RUN python3 -m pip install --upgrade pip
RUN pip install pipx
RUN pipx ensurepath
RUN pipx install cumulusci
#RUN cci robot install_playwright
