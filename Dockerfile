# Use a Node.js base image
FROM node:20-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or npm-shrinkwrap.json)
# to install dependencies efficiently
COPY package*.json ./

# Install dependencies using npm ci for deterministic installs
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the Nuxt.js application for production
RUN npm run build

# --- Production Stage ---
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary build output from the build stage
COPY --from=build /app/.output/ ./

# Expose the port Nuxt.js listens on (default is 3000)
EXPOSE 3000

# Set environment variables for Nuxt.js (optional, adjust as needed)
ENV HOST=0.0.0.0
ENV PORT=3000

# Command to run the Nuxt.js application in production
CMD ["node", "/app/server/index.mjs"]