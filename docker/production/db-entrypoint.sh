#!/bin/bash
# Demo: garante que o banco tenha o schema/dados do dump.
# O entrypoint do Postgres só carrega /docker-entrypoint-initdb.d com o volume vazio; se um volume já
# foi inicializado sem o dump (deploy anterior quebrado), este loop carrega o dump quando faltar o schema.
(
    # TCP em 127.0.0.1 só responde no servidor definitivo (o temporário do initdb escuta apenas no socket)
    until pg_isready -q -h 127.0.0.1 -U "$POSTGRES_USER"; do sleep 2; done
    export PGPASSWORD="$POSTGRES_PASSWORD"
    if [ "$(psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAc "select to_regclass('public.db_update') is null")" = "t" ]; then
        echo "[db-entrypoint] schema ausente, carregando /dump.sql"
        psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /dump.sql > /var/log/dump-load.log 2>&1
        echo "[db-entrypoint] dump carregado"
    fi
) &

exec docker-entrypoint.sh "$@"
