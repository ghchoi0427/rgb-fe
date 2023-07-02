# Use an official Node.js runtime as the base image
FROM node:lts-alpine as build-stage

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the entire project directory to the container
COPY . .

# Build the Vue.js application for production
RUN npm run build

# Use a lightweight Nginx image as the base for the second stage
FROM nginx:stable-alpine

# Copy the built Vue.js files from the previous stage to the Nginx web server directory
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
