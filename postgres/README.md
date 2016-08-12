# bigvikinggames/postgres

PostgreSQL 9.5 with CSTORE 1.4 Foreign Data Wrapper

More documentation coming soon...

## Master/Slave Replication

This image now supports master/slave replication and the docker-compose.yml can be used for testing though there are still some manual steps involved.

The steps are essentially the same as those described in the [PostgreSQL Wiki for Binary Replication](https://wiki.postgresql.org/wiki/Binary_Replication_Tutorial) but slightly different since we're using local containers.

### 1. Bring the master online.

This will start a postgresql server and create/mount the data files under `mounts/master`.

`docker-compose up master`

### 2. Start a backup.

Tell the master we're going to take a backup and to create xlog archives.

`docker exec -it -u postgres postgres_master_1 psql -c "pg_start_backup('backup', true);"`

### 3. Rsync master database.

Now we copy the postgres data from the master, with the exclusion of a few files and directories.

`sudo rsync -av --exclude pg_xlog --exclude postgresql.conf --exclude postgresql.pid mounts/master/ mounts/slave`

### 4. Stop the backup.

Tell the master we've completed our backup.

`docker exec -it -u postgres postgres_master_1 psql -c "pg_stop_backup();"`

### 5. Quickly copy WAL files to slave.

Quickly is of less relevance here since its not an active server, but if it was we need to make sure its not too far out of sync by the time we start the slave. You may need to look into modifying `wal_keep_segments` on your master if it's very busy.

`sudo rsync -av mounts/master/pg_xlog mounts/slave/`

### 6. Start the slave server.

`docker-compose up slave`

### 7. Test your slave.

You should now be able to send writes to the master server and see them replicated to the slave.

`docker exec -it -u postgres postgres_master_1 psql "create database testing_replication;"`
`docker exec -it -u postgres postgres_slave_1 psql -c "SELECT datname FROM pg_database;"`
