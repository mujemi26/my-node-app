# Step 1: Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Step 2: Set the working directory inside the container
WORKDIR /usr/src/app

# Step 3: Copy package.json and package-lock.json first (for better caching)
COPY package*.json ./

# Step 4: Install dependencies
RUN npm install

# Step 5: Copy all project files
COPY . .

# Step 6: Expose port 3000
EXPOSE 3000

# Step 7: Install PM2 for process management
RUN npm install pm2 -g

# Step 8: Use PM2 to run and keep the application running
CMD ["pm2-runtime", "app.js"]
