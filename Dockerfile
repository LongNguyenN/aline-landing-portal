FROM node:16-alpine
WORKDIR /microservice
COPY . .
RUN npm i
CMD export NODE_OPTIONS="--max-old-space-size=8192"
ENTRYPOINT npm start
EXPOSE 3001
