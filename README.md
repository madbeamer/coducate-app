# Coducate Development and Production Setup Guide

This document explains how to set up and run the Coducate project in both development and production environments.

## Development Setup

### Prerequisites

1.  Docker and Docker Compose

### Steps

1.  **Start the Docker Daemon**  
    Ensure Docker is running on your system.

2.  **Configure Environment Variables**  
    Navigate to the `coducate-backend` directory and ensure the `.env` file exists with proper database credentials.

3.  **Start All Services**  
    From the project root directory, run:
    
    ```bash
    docker compose up -d
    ```

    This will start MariaDB, backend, and frontend containers. Database migrations will run automatically.

4.  **Access the Application**  
    - Frontend (with HMR): http://localhost:5173
    - Backend API: http://localhost:1234
    - Database: localhost:3306

5.  **Develop with Hot Reload**  
    - Backend: Edit files in `coducate-backend/src/` - nodemon will auto-restart
    - Frontend: Edit files in `coducate-frontend/src/` - Vite HMR will instantly update the browser

6.  **View Logs**  
    To see logs from all services:
    
    ```bash
    docker compose logs -f
    ```

    To see logs from a specific service:
    
    ```bash
    docker compose logs -f backend
    docker compose logs -f frontend
    docker compose logs -f mariadb
    ```

7.  **Start extension development host**  
    Open the Coducate project in Visual Studio Code.  
    Press `F5` to start the extension development host.

8.  **Test the Extension on non-development host by installing it using the `.vsix` file**  
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

9.  **End the Development Session**  
    To stop all services:
    
    ```bash
    docker compose down
    ```

### Development Tools

-   **Rebuild Containers** (after Dockerfile or dependency changes)  
    
    ```bash
    docker compose up -d --build
    ```

-   **Restart a specific service**  
    
    ```bash
    docker compose restart backend
    docker compose restart frontend
    ```

-   **Check the Database**  
    Connect to the MariaDB database from inside the container:
    
    ```bash
    docker compose exec mariadb mysql -u root -p
    ```

    Or from your host machine (requires mysql client):
    
    ```bash
    mysql -h 127.0.0.1 -P 3306 -u root -p
    ```

    Enter the root password from the `.env` file.

-   **Query the Rooms Table**  
    Inside the MariaDB prompt, run:

    ```sql
    USE coducate;
    SELECT * FROM rooms;
    ```

-   **Run Migrations Manually** (if needed)  
    Migrations run automatically on startup, but you can run them manually:
    
    ```bash
    docker compose exec backend npx knex migrate:latest --knexfile knexfile.ts
    ```

-   **Rollback Migrations**  
    
    ```bash
    docker compose exec backend npx knex migrate:rollback --knexfile knexfile.ts
    ```

-   **Create New Migration**  
    
    ```bash
    docker compose exec backend npx knex migrate:make migration_name --knexfile knexfile.ts
    ```

-   **Populate the Rooms Table**  
    Modify the `seed_rooms.ts` file as needed, then run:
    
    ```bash
    docker compose exec backend npx knex seed:run --knexfile knexfile.ts
    ```

-   **Access Container Shell**  
    
    ```bash
    docker compose exec backend sh
    docker compose exec frontend sh
    docker compose exec mariadb sh
    ```

-   **Install new npm package**  
    Backend:
    
    ```bash
    docker compose exec backend npm install <package-name>
    docker compose restart backend
    ```
    
    Frontend:
    
    ```bash
    docker compose exec frontend npm install <package-name>
    docker compose restart frontend
    ```

## Production Setup

1. Go to the project's root directory (where this `README.md` is located).

2. Run the following command to build and push images to AWS ECR:
    
    ```bash
    ./build_and_push.sh
    ```

3. Access the web server using SSH:
    
    ```bash
    ssh -i ~/.ssh/coducate-ec2.pem ubuntu@3.79.47.246
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

    If the output is `Publisher 'coducate' is already known. Do you want to overwrite its PAT? [y/N]`, enter `n` to keep the existing Personal Access Token (PAT) and skip the next step.

    Enter the Personal Access Token (PAT) when prompted. You can create a new PAT from the Visual Studio Marketplace.

    Then run the following command to publish the extension:
    
    ```bash
    vsce publish <version> --allow-missing-repository
    ```

    This will automatically update the version in the `package.json` and `package-lock.json` file.

## License

TBD
