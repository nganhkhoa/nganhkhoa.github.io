FROM node:20-alpine

ENV TYPST_INSTALL="/root/.typst"
ENV PATH="$TYPST_INSTALL/bin:$PATH"

WORKDIR /work

RUN apk add curl
RUN npm install elm lamdera
RUN curl -fsSL https://install.typst.community/install.sh | sh

COPY . /work
RUN typst compile cv.typ public/cv.pdf
RUN npm install && npm run build
