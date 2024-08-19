# Use an official Ruby runtime based on Alpine as a parent image
FROM ruby:3.3-alpine AS builder

ENV RACK_ENV="production" \
    NODE_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development:test"

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler

# Install necessary packages including Node.js and Yarn
RUN apk add --no-cache build-base nodejs npm git && \
    npm install -g yarn

# Set the working directory
WORKDIR /app

# Copy Gemfile and other necessary files
COPY --link Gemfile Gemfile.lock .ruby-version package.json yarn.lock ./

# Install dependencies
RUN bundle install && \
    yarn install --frozen-lockfile && \
    rm -rf /root/.bundle/cache /usr/local/bundle/cache /var/cache/apk/*

# Copy the rest of the application code
COPY --link . .

# Build the static site (e.g., using Jekyll)
RUN bin/rake site:build

# Use an official Nginx image based on Alpine to serve the static site
FROM nginx:stable-alpine

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the static site files to the Nginx HTML directory
COPY --from=builder /app/build /usr/share/nginx/html/

# Expose port to the Docker host (default is 5000 for dokku)
EXPOSE 5000

# Start Nginx when the container launches
CMD ["nginx", "-c", "/etc/nginx/nginx.conf"]
