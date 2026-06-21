# hermes-agent-sbx

Minimal Docker image packaging for [Hermes Agent](https://github.com/NousResearch/hermes-agent) to be run in docker sandbox (sbx).

## Image contents

The image in this repo:
- installs Hermes with the official upstream install script
- includes `mini-swe-agent`
- persists Hermes state under `/home/agent/.hermes`
- is intended for straightforward local builds and multi-arch publishing

## Quick start

### Build locally

Build the latest `main` by default:

```bash
docker build -t hermes-agent-docker:local .
```

Build a specific Hermes tag:

```bash
docker build \
  --build-arg HERMES_REF=v2026.3.30 \
  -t hermes-agent-docker:v2026.3.30 .
```

`HERMES_REF` defaults to `main` and can point to either a branch or a tag.

Export build image to tar
```bash
docker image save hermes-agent-docker:local \
  -o hermes-agent-docker.tar```
```

Import tar as template
```bash
sbx template load hermes-agent-docker.tar
```

### Run Hermes


### First time creation of sandbox

```bash
mkdir -p $HOME/.local/hermes
cd $HOME/.local/hermes
sbx run --template hermes-agent-docker:local shell
```

### Later runs
```bash
sbx run shell-hermes
```

## Environment and setup

Run `hermes setup` inside the sandbox