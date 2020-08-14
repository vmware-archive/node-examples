FROM node:buster

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Download the nodejs-client tgz and place it in the same directory as this Dockerfile
# and update this line to match the filename being copied into the image
COPY gemfire-nodejs-client-2.0.1.tgz gemfire-nodejs-client.tgz
COPY package.json package.json
COPY pages pages

RUN npm install /usr/src/app/gemfire-nodejs-client.tgz
RUN npm install
RUN npm run build

EXPOSE 3000
CMD [ "npm", "start" ]
