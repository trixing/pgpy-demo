# Postgres PL/Python and Flask Example

A quick example of how to use plpython in Postgres
to do a remote procedure call to a python interpreter running
the flash application server.

Requires a working Docker installation.


## Build Docker Images

```
docker build -t trixing/pgpy/db db/
docker build -t trixing/pgpy/web web/
```

## Run Docker Images

```
docker network create pgpy-net
docker run --name pgpy-db --network pgpy-net \
       -e POSTGRES_PASSWORD=pg1234 -p 5432:5432 -d trixing/pgpy/db
docker run --name pgpy-web -p 5000:5000 --network pgpy-net -d trixing/pgpy/web
```

## Test

Connect to postgres, using the password above
```
docker run --rm --network pgpy-net -it postgres psql -h pgpy-db -U postgres pgtest
```

```
SELECT pyreq('foo');
SELECT pysub('foo');
```

## Hints

Optionally add `-v $PWD/db/data:/var/lib/postgresql/data` to the Postgres
run line to persist the data.

Develop the Python app locally:
```
docker run --rm -it -v $PWD/web:/usr/src/app -p 5000:5000 trixing/pgpy/app
```

Test the web server
```
curl "http://127.0.0.1:5000/?q=foo"

curl -d q=bla "http://127.0.0.1:5000"
```
