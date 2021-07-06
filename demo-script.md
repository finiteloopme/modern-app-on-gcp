# https://www.bigbinary.com/blog/configure-postgresql-to-allow-remote-connection
# Service restart
```
sudo service postgresql@11-main start
```
# Allow remote connection
```
sudo vim ./etc/postgresql/11/main/pg_hba.conf
```
# Bind PostgreSQL to 0.0.0.0
```
sudo vim ./etc/postgresql/11/main/postgresql.conf
```