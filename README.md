# Football Scores

HTTP API serving football (soccer) game scores

## Installation

### Prerequisites
* PostgreSQL database
* Docker and docker-compose
* [direnv](https://direnv.net/) for handling environmental variables locally


### Local setup
  * Install dependencies with `mix deps.get`
  * Set enviroment variables by copying sample `.envrc` file - `cp .envrc.sample .envrc` and executing `direnv allow`
  * Ensure postgres database server is started (e.g. `docker run -p 5432:5432 -d postgres:11.3`)
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`
  * Application should be up and running at `http://localhost:4000`

### Docker setup
  * From root application folder run `docker-compose up -d`
  * Log into database container and create database (if it doesn't exist)
    ```
    docker exec -it football-scores_db_1 bash -l
    psql -U postgres
    create database football_scores_dev;
    ```
  * Log into one of the application containers and run migrations
    ```
    docker exec -it football-scores_web_a_1 bash -l
    bin/football_scores migrate
    bin/football_scores seed
    ```
  * Application should be up and running at `http://localhost:4000`

## API Documentation
HTTP JSON API Documentation is available at `http://localhost:4000/swaggerui`
Protobuf documentation is available at `http://localhost:4000/protodoc`

To regenerate protobuf documentation (in case of changes in *.proto files):
1. Pull proto-doc-gen docker image: `docker pull pseudomuto/protoc-gen-doc`
2. From the application root directory run:
  ```
  docker run --rm \
    -v $(pwd)/priv/protodoc:/out \
    -v $(pwd)/lib/football_scores/proto:/protos \
    pseudomuto/protoc-gen-doc
  ```

## Testing
Setup application locally and execute `mix test` from the root directory
