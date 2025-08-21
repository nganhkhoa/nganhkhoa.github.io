FROM node:20-alpine

WORKDIR /work

RUN npm install -g elm lamdera

COPY . /work
RUN npm install && npm run build
