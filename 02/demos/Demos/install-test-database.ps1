# Get the latest PostgreSQL image from Docker Hub and do a test startup and shutdown

#docker pull postgres
podman pull docker.io/library/postgres
#docker run --name postgres_test -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
podman run --name postgres_test -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
#docker container rm --force postgres_test
podman container rm --force postgres_test

# Create a Docker volume for persistent storage and rebuild the container
#docker volume create pgdata
podman volume create pgdata
#docker run --name postgres_test -v pgdata:/var/lib/postgresql/data -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
podman run --name postgres_test -v pgdata:/var/lib/postgresql/data -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres

# Open a shell prompt inside the container
#docker exec -it postgres_test bash
podman exec -it postgres_test bash

######################################################################################
# Note: The following section contains Linux shell commands, not PowerShell commands #
######################################################################################

# Update the package store and install the wget utility
apt-get update
apt-get install wget

# Pull the dell test e-commerce database files
cd /tmp
wget http://linux.dell.com/dvdstore/ds21.tar.gz
wget http://linux.dell.com/dvdstore/ds21_postgresql.tar.gz

# Decompress both files
tar -xvzf ds21.tar.gz
tar -xvzf ds21_postgresql.tar.gz

# Customize the build script with the username and password we are using
cd /tmp/ds2/pgsqlds2
sed -e 's/SYSDBA=ds2/SYSDBA=postgres/' -e 's/PGPASSWORD="ds2"/PGPASSWORD="mysecretpassword"/'   pgsqlds2_create_all.sh > pgsqlds2_create_all_custom.sh

# Run the build script for the e-commerce databaSe
bash pgsqlds2_create_all_custom.sh
