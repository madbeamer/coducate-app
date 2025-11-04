# Coducate Development and Production Setup Guide

This document explains how to set up and run the Coducate project in both development and production environments.

## Development Setup

### Prerequisites

1.  Node.js (22+)
2.  npm (11+)
3.  Docker and Docker Compose

### Steps

1.  **Start the Docker Daemon**  
    Ensure Docker is running on your system.

2.  **Start the Backend Server**  
    Navigate to the `coducate-backend` directory and run:

    ```bash
     docker compose up -d mysql
    ```

    This will start the MySQL Docker container.

    Then run:

    ```bash
    npx knex migrate:latest --knexfile knexfile.ts
    ```

    This will run the database migrations.

    ```bash
    npm start
    ```

    This will start the backend server.

    The backend server and MySQL Docker container will then be ready to use.

3.  **Start the Frontend Server**  
    Navigate to the `coducate-frontend` directory and run:

    ```bash
    npm run dev
    ```

    This starts the Vite development server.

4.  **Start extension development host**  
    Open the Coducate project in Visual Studio Code.  
    Press `F5` to start the extension development host.

5.  **Test the Extension by installing it using the `.vsix` file**
    Navigate to the `coducate` directory and run:

    ```bash
    vsce package --allow-missing-repository
    ```

    This will create a `.vsix` file in the `coducate` directory.  
     Install the extension in Visual Studio Code by following these steps:

    -   Navigate to the Extensions view
    -   Click on the `...` icon
    -   Select `Install from VSIX...`
    -   Choose the `.vsix` file created earlier
    -   Reload Visual Studio Code

6.  **End the Development Session**  
    To stop the backend server, press `Ctrl + C` in the terminal.  
    To stop the frontend server, press `Ctrl + C` in the terminal.
    To stop the MySQL Docker container, navigate to the `coducate-backend` and run:

    ```bash
    docker-compose down
    ```

    This will stop and remove the MySQL container.

### Optional Development Tools

-   **Check the Database**  
    Connect to the MySQL database:

    ```bash
    mysql -h 127.0.0.1 -P 3306 -u root -p
    ```

    Enter the root password from the `.env` file.

-   **Query the Rooms Table**  
    Inside the MySQL prompt, run:

    ```sql
    USE coducate;
    SELECT * FROM rooms;
    ```

-   **Populate the Rooms Table**  
    Modify the `seed_rooms.ts` file as needed, then run:
    ```bash
    npx knex seed:run --knexfile knexfile.ts
    ```

## Production Setup

1. Go to the project's root directory (where this `README.md` is located).
2. Run the following command:

    ```bash
    ./build_and_push.sh
    ```

3. Access the web server using SSH.

    ```bash
    ssh -i ~/.ssh/coducate-ec2.pem ubuntu@18.184.166.137
    ```

4. Run the deployment script:

    ```bash
    ./coducate/deploy.sh
    ```

5. Publish the extension to the Visual Studio Code Marketplace:

    First, update the `CHANGELOG.md` file with the new version and changes.
    Make the necessary changes to the `README.md` file as well.
    Optionally, update the `package.json` file (e.g., change the description, keywords, etc.).
    Then, commit the changes and push them to the repository.

    Make sure you have the `vsce` tool installed. If not, install it using:

    ```bash
     npm install -g vsce
    ```

    Then login using:

    ```bash
    vsce login coducate
    ```

    Enter the Personal Access Token when prompted.

    Then run the following command to publish the extension:

    ```bash
    vsce publish <version> --allow-missing-repository
    ```

    This will automatically update the version in the `package.json` and `package-lock.json` file.
