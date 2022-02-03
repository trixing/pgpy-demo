#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "template1" <<-EOSQL
    CREATE EXTENSION plpython3u;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE pgtest;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "pgtest" <<-EOSQL

CREATE OR REPLACE FUNCTION pyreq(x text)
  RETURNS text
AS \$\$
  import requests
  # or r = requests.post('http://pgpy-web', data={'q': x})
  r = requests.get('http://pgpy-web:5000', params={'q': x})
  j = r.json()
  return j['r']
\$\$ LANGUAGE plpython3u;


CREATE OR REPLACE FUNCTION pysub(x text)
  RETURNS text
AS \$\$
  import subprocess
  return subprocess.Popen(['echo', x], stdout=subprocess.PIPE).communicate()[0]
\$\$ LANGUAGE plpython3u;

EOSQL
