FROM node:14

RUN mkdir -p /data/app/testapp
WORKDIR /data/app/testapp
COPY . /app
RUN pwd
RUN ls
RUN npm install
COPY . /app
EXPOSE 3000
CMD node index.js