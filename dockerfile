# Use a base image
FROM nginx:alpine

# Copy custom configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Default command
CMD ["nginx", "-g", "daemon off;"]
