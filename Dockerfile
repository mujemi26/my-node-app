# Step 1: Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Step 2: Set the working directory inside the container
WORKDIR /usr/src/app

# Step 3: Copy the app.js file into the container's working directory
COPY app.js .

# Step 4: Expose port 3000 to the outside world
EXPOSE 3000

# Step 5: Define the command to run the app
CMD ["node", "app.js"]
