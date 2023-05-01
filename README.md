# CRANIndexer

This is an app that indexes R packages from [CRAN server](https://cran.r-project.org/src/contrib).

Some of the features include;

- an index page to display all the packages
- background cron job that builds packages

Coming soon;

- search packages by name

## Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby 3.1.2
- Rails 7.1
- Docker
- docker-compose

### 1. Check out the repository

```bash
git clone git@github.com:genzade/CRANIndexer.git
cd CRANIndexer
```

### 2. Build the app

```bash
docker-compose up --build --renew-anon-volumes
```

And now you can visit the site with the URL `http://localhost:3000`

### 3. Seed data

```bash
docker-compose exec -it -e RAILS_ENV=development app bin/rails db:seed
```

### 4. Run tests (specs)

```bash
docker-compose exec -it -e RAILS_ENV=test app bin/rspec
```
