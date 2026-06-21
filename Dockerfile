FROM docker/sandbox-templates:shell

ARG HERMES_REF=main
ARG CODEX_VERSION=0.118.0

COPY docker-entrypoint.sh /usr/local/bin/hermes-entrypoint

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /home/agent/.hermes /home/agent/.local/bin \
    && chown -R agent:agent /home/agent/.hermes /home/agent/.local

USER agent
ENV HOME=/home/agent
ENV PATH="/home/agent/.local/bin:${PATH}"
WORKDIR /home/agent

RUN curl -fsSL "https://raw.githubusercontent.com/NousResearch/hermes-agent/${HERMES_REF}/scripts/install.sh" \
    | bash -s -- --skip-setup --branch "${HERMES_REF}" --dir /home/agent/hermes-agent

#RUN NPM_CONFIG_PREFIX=/home/agent/.local npm install -g @openai/codex@${CODEX_VERSION}

RUN cd /home/agent/hermes-agent \
    && (npm audit fix >/dev/null || [ $? -eq 1 ])

#RUN cd /home/agent/hermes-agent/scripts/whatsapp-bridge \
#    && (npm audit fix >/dev/null || [ $? -eq 1 ])

RUN HERMES_HOME=/home/agent/.hermes HOME=/home/agent hermes skills list >/dev/null

USER root
RUN mkdir -p /usr/local/share/hermes-home \
    && cp -a /home/agent/.hermes/. /usr/local/share/hermes-home/ \
    && chmod 755 /usr/local/bin/hermes-entrypoint \
    && chown -R agent:agent /usr/local/share/hermes-home

USER agent
WORKDIR /home/agent/workspace
VOLUME ["/home/agent/.hermes"]
ENTRYPOINT ["/usr/local/bin/hermes-entrypoint"]
