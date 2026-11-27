#!/bin/bash
# Carrega o dump de demonstração. Executado pelo entrypoint do Postgres apenas quando o volume de dados está vazio.
# Não usa ON_ERROR_STOP: o dump tenta criar objetos que a imagem do PostGIS já cria (ex.: schema tiger).
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /dump.sql
