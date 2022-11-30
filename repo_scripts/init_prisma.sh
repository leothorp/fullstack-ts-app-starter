#!/usr/bin/env bash
set -e

# This script generates a Prisma schema file/migrations from an existing db (leaving its data intact).


cd services/server

pnpm run prisma-cli init
pnpm run prisma-cli db pull


# generate initial migration file, mark it as applied
CURR_TIMESTAMP=$(date -u "+%Y%m%d%H%M%S")
mkdir -p ./prisma/migrations/${CURR_TIMESTAMP}_init
pnpm run prisma-cli migrate diff --from-empty --to-schema-datamodel prisma/schema.prisma --script > ./prisma/migrations/${CURR_TIMESTAMP}_init/migration.sql
pnpm run prisma-cli migrate resolve --applied ${CURR_TIMESTAMP}_init





# ***** 
# incorrect instructions below from Prisma docs at https://www.prisma.io/docs/getting-started/setup-prisma/add-to-existing-project/relational-databases/introspection-typescript-postgres
# these result in a non-timestamped "init" migration that gets skipped on subsequent re-runs from a reset db.
# *****
mkdir -p ./prisma/migrations/init
# pnpx -- prisma migrate diff --from-empty --to-schema-datamodel prisma/schema.prisma

# mark init migration as applied:
# ../../node_modules/.bin/dotenv -e ../../.env.server.local pnpx -- prisma migrate resolve --applied init

# more-correct, but less-automatable ones (which still result in wiping the db): https://www.prisma.io/docs/guides/database/developing-with-prisma-migrate/add-prisma-migrate-to-a-project)
