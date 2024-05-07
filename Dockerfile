FROM node:18-alpine3.19 AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./

RUN pnpm i 

COPY . .

RUN pnpm run build

EXPOSE 3000

CMD ["pnpm", "start"]