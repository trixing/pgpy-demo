# Postgres PL/Python and Flask Example

A quick example of how to use plpython in Postgres
to do a remote procedure call to a python interpreter running
the flash application server. 

An alternate method is provided using the Python subprocess
module to call a local program, which can for example be used
to run in an Anaconda or Virtualenv environment.

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


## References

* https://stackoverflow.com/questions/36275308/how-do-you-activate-an-anaconda-environment-within-a-python-script
* https://stackoverflow.com/questions/5921664/how-to-change-python-version-used-by-plpython-on-mac-osx
* https://hub.docker.com/_/postgres
* https://docs.python-requests.org/en/latest/user/quickstart/

