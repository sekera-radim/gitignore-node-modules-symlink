FROM node:22-slim
RUN apt-get update -qq && apt-get install -y -qq git >/dev/null && rm -rf /var/lib/apt/lists/*
RUN useradd -m dev
USER dev
WORKDIR /home/dev
RUN git config --global user.name "Demo" && git config --global user.email "demo@example.com" && git config --global init.defaultBranch main && git config --global advice.detachedHead false
# Template app with one real dependency; npm cache stays in the image so later installs work offline.
COPY --chown=dev template /home/dev/template
RUN cd /home/dev/template && npm install --silent && rm -rf node_modules
COPY --chown=dev scripts /home/dev/scripts
CMD ["bash", "scripts/test.sh"]
