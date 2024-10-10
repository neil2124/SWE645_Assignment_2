# Use an official NGINX image from Docker Hub
FROM nginx:alpine

# Copy the web application files into the default NGINX folder
COPY ./class-website /usr/share/nginx/html

# Expose port 80 to serve the website
EXPOSE 80
