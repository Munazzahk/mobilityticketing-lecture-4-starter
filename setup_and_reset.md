# Setup and Reset Instructions

## Requirements

* Docker Desktop with Docker Compose

## Start the database

Run the following commands from the repository root:

```bash
docker compose up -d
docker compose ps
```

The PostgreSQL database is available on:

```text
localhost:5432
```

Database name:

```text
mobility
```

User:

```text
mobility
```

Password:

```text
mobility
```

Stop other containers first if they use the same port.

## Connect to the database

A PostgreSQL client does not need to be installed locally. The `psql` client can be run inside the PostgreSQL container:

```bash
docker compose exec postgres psql -U mobility -d mobility
```

## Run the lecture work

The initialization files in `database/postgres/init/` should remain unchanged.

Run the migration files in their intended order before running the related experiments.

From PowerShell, SQL files can be executed directly from the repository. For example:

```powershell
Get-Content .\database\postgres\migrations\030_expand_product_identity.sql | docker compose exec -T postgres psql -U mobility -d mobility
```

The same approach can be used for the other migration and experiment files by changing the file path.

## Stop the database

```bash
docker compose down
```

## Reset the database

To remove the current lab data and restore the original starting state:

```bash
docker compose down -v
docker compose up -d
```

The `-v` option removes the database volume, so the initialization scripts are run again from a clean database.
