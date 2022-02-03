#!/bin/bash
set -e

echo "$WEB_HOST"

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
  import os
  import requests
  host = os.environ.get('WEB_HOST', 'http://pgpy-web:5000')
  r = requests.get(host, params={'q': x})
  # or r = requests.post(host, data={'q': x})
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
