FROM node:0.10

RUN mkdir /tilelive
WORKDIR /tilelive
COPY package.json /tilelive/package.json
RUN npm install
ADD . /tilelive


CMD [ "npm", "start" ]
