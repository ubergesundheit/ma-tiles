FROM node:latest

RUN mkdir /tilelive
WORKDIR /tilelive
COPY package.json /tilelive/package.json
RUN npm install
ADD . /tilelive


CMD [ "npm", "start" ]
