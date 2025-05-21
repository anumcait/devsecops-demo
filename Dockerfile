# Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Upgrade system packages to fix vulnerabilities
RUN apk update && apk upgrade --no-cache

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Upgrade system packages here too (libxml2 is likely in this layer)
RUN apk update && apk upgrade --no-cache

COPY --from=build /app/dist /usr/share/nginx/html

# Optional: custom nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
