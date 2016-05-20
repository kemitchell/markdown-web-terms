FROM node:argon
WORKDIR /work
COPY package.json /work/package.json
RUN npm install
COPY . /work
CMD make
