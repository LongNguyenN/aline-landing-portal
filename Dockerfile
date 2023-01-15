FROM node:16-alpine
WORKDIR /microservice
COPY . .
RUN npm i
CMD npm start
EXPOSE 3001
