# Compulsory Assignment 1 review guide

**Group member:** Munazzah Khurshid
**Submitted commit:** 

## Where to find the work

### Lecture 1 – Design and queries

* Workload map and relational model: https://github.com/Munazzahk/mobilityticketing-lecture-1-starter/blob/main/docs/notes.md
* Schema and seed data: https://github.com/Munazzahk/mobilityticketing-lecture-1-starter/blob/main/database/postgres/001_relational_baseline.sql 
* Required timetable queries: https://github.com/Munazzahk/mobilityticketing-lecture-1-starter/blob/main/database/postgres/003_queries.sql 

Covers route/timetable access patterns, the relational model, schema design, seed data, upcoming trips, ordered route stops, and routes including those with zero scheduled trips.

### Lecture 2 – Integrity and constraints

* Integrity map: https://github.com/Munazzahk/mobilityticketing-lecture-2-starter/blob/main/docs/integrity-map.md 
* Constraint migration: https://github.com/Munazzahk/mobilityticketing-lecture-2-starter/blob/main/database/postgres/migrations/011_ticketing_integrity.sql 
* Successful and rejected write tests: https://github.com/Munazzahk/mobilityticketing-lecture-2-starter/blob/main/database/postgres/experiments/constraints_should_fail.sql 

Covers important domain invariants, database constraints, foreign keys, valid writes, rejected writes, and known limitations of database constraints.

### Lecture 3 – Reporting

* Reporting experiment and evidence: https://github.com/Munazzahk/mobilityticketing-lecture-3-starter/blob/main/docs/report.md
* Reporting function, trigger and materialized view: https://github.com/Munazzahk/mobilityticketing-lecture-3-starter/blob/main/docs/report.md

Covers the reporting query/function, trigger-based summary, materialized view, stale reporting results, corrections, and comparison with the base-table query.

### Lecture 4 – Schema migration

* Migration stages and product identity: https://github.com/Munazzahk/mobilityticketing-lecture-4-starter/blob/main/database/postgres/migrations/030_expand_product_identity.sql
* Old, new and final readers/writers: https://github.com/Munazzahk/mobilityticketing-lecture-4-starter/blob/main/database/postgres/experiments/lecture04
* Migration experiments: https://github.com/Munazzahk/mobilityticketing-lecture-4-starter/blob/main/database/postgres/experiments/lecture04/remove_legacy.sql
* Verification scripts: https://github.com/Munazzahk/mobilityticketing-lecture-4-starter/blob/main/database/postgres/experiments/lecture04/verify.sql

Covers the transition from `product_code` to `product_id`, backfill and verification, old/new/final readers and writers, mismatch testing, legacy-column removal rehearsal, and requiring `product_id`.


## Two decisions worth discussing

### 1. Use (route_id, stop_sequence) as the primary key

I chose (route_id, stop_sequence) as the primary key for route_stops.

The reason is that the sequence identifies the position of a stop in a route. This also allows the same stop to appear more than once on a route.

An alternative would be to use (route_id, stop_id) as the primary key, but that would prevent the same stop from appearing more than once on a route.

**Evidence:** Lecture 1 lecture 1 notes.md and 001_relational_baseline.sql.
https://github.com/Munazzahk/mobilityticketing-lecture-1-starter/blob/main/database/postgres/001_relational_baseline.sql
https://github.com/Munazzahk/mobilityticketing-lecture-1-starter/blob/main/docs/notes.md

### 2. Use base tables as the reporting authority

For daily captured revenue, the payments table is treated as the source of truth. The SQL function reads the current base tables directly.

The alternatives explored were a materialized view and a trigger-maintained summary table. The experiments showed that the materialized view can become stale until refreshed, while the trigger summary can miss existing data and later corrections such as updates or deletes.

**Evidence:** Lecture 3 reporting experiment and comparison.
https://github.com/Munazzahk/mobilityticketing-lecture-3-starter/blob/main/docs/report.md

## One limitation or open question

The database constraints do not guarantee every business rule by themselves. In particular, the reserved_seats <= capacity check is a row-level constraint and does not by itself prevent concurrent transactions from overselling the same trip.

The Lecture 2 issue register identifies concurrent purchases as an open issue. A next step would be to test concurrent transactions and decide whether the purchase operation needs explicit transaction-level locking or another concurrency-control mechanism.

**Evidence:** Lecture 2 integrity map and issue register.
https://github.com/Munazzahk/mobilityticketing-lecture-2-starter/blob/main/docs/integrity-map.md 














# MobilityTicketing: Lecture 4 starter

Give products stable IDs without breaking existing tickets or the application code that still uses product codes.

You need Docker Desktop with Compose. Start the database from this directory:

```bash
docker compose up -d
docker compose ps
```

Connect at `localhost:5432` with database, user and password `mobility`. Stop other lecture containers first if they use the same port.

Read [the lab](docs/lab.md) for the tasks and commands. You will find:

- the starting schema and data in `database/postgres/init/`;
- migration examples to complete in `database/postgres/migrations/`;
- queries, inserts and experiments in `database/postgres/experiments/lecture04/`.

The database contains three tickets covering two products. One DAY ticket was bought for 65 DKK; the catalogue now lists 80 DKK. Your migration must keep the price paid.

Leave the initialization files unchanged and put your changes in migrations. If you use your own repository, keep your earlier constraints and check for reporting views or functions that depend on the columns you change.

To stop the database:

```bash
docker compose down
```

To discard your lab data and load the starting data again:

```bash
docker compose down -v
docker compose up -d
```
