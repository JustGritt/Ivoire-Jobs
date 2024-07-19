## Running the Project

1. Create a `.env` file in the `src` directory if not present:

```sh
cp src/.env.example src/.env
```

Replace the content of the `.env` file with the one provided.

2. Export the PATH of the Go binary for future build calls.

***Note: This step is not necessary if you have installed the Go language globally.***

```sh
export PATH=$PATH:$(go env GOPATH)/bin
```

3. Download Swag for generating docs:

```sh
go install github.com/swaggo/swag/cmd/swag@latest
```

- Generate Swagger Docs. You have to generate swagger docs before packaging the app.

***From the root of the project please use this command instead***

```sh
export PATH=$(go env GOPATH)/bin:$PATH
swag init -g src/api/app.go --output ./src/api/docs # Generates Swagger
```

***If you don't have or don't want to use Docker, please go to step 6***

4. Run the Docker:

With logs stream:
```sh
docker compose up  
```

Without logs:
```sh
docker compose up -d 
```

5. Populate the DB with data:

With the software of your choice, please connect to the instance of the DB and copy-paste the full content of `gofiber.sql`.

Or ensure you are in the `src` folder to be able to run the seeder:

```sh
go run cmd/main.go
```

***Note: You might have to set `DB_HOST=postgres` to `DB_HOST=localhost` if you encounter any errors accessing the DB from within Docker.***

6. Running the application without Docker:

You will need to provide a fully functional Postgres database and update the `.env`, or you can use `docker-compose-db.yml` only for using Postgres as a Docker image. You can use the production DB provider in the `.env` and uncomment the `DB_HOST` with an IPV4 address and comment out `DB_HOST=postgres`.

Ensure that you are in the `src` folder.

```sh
go run main.go
```

***You can now use the API and see the Swagger documentation at http://localhost:8000/api/v1/docs/index.html***

7. Build Your Image for production manually:

This workflow is fully automated on the main branch with Github Actions and ArgoCD.

- Grant permission to the build script to run:

```sh
chmod +x docker-build.sh
```

- You could set the image port in `Dockerfile.prod`.
- Run the build script. You must provide a version tag as shown below:

```sh
./docker-build.sh -v gofiber:1.0.0
```