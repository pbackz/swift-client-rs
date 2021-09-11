# Rust openstack swift client to download cloud archive object

## Environnements variables setup 

Ensure you have set the following variables:
```bash
OS_TENANT_NAME=<OS_TENANT_NAME>
OS_TENANT_ID=<OS_OS_TENANT_ID>
OS_REGION_NAME=<OS_REGION_NAME>
OS_USERNAME=<OS_USERNAME>
OS_PASSWORD<OS_PASSWORD> # not used when OS_AUTH_TYPE=v3token but mandatory to concatenate the connection string used by sshpass
OS_TOKEN=<OS_TOKEN>
OS_AUTH_URL=https://auth.cloud.ovh.net/v3/
OS_URL=https://storage.${OS_REGION_NAME}.cloud.ovh.net/v1/AUTH_${OS_TENANT_ID}
OS_AUTH_TYPE=v3token # use password if OS_TOKEN is not set
OS_IDENTITY_API_VERSION=3
OS_USER_DOMAIN_NAME=${OS_USER_DOMAIN_NAME:-"Default"}
OS_PROJECT_DOMAIN_NAME=${OS_PROJECT_DOMAIN_NAME:-"Default"}
OS_PROJECT_ID=${OS_TENANT_ID}
OS_PROJECT_NAME=${OS_TENANT_NAME}
```

## Option 1: Build project with rust toolchain
```bash
cargo build --release --example list-containers
mv ./target/release/examples/list-containers bin/
```

## Option 2: Use existing project binary for x86-64 
```bash
file bin/list-containers.x86-64
> bin/list-containers.x86-64: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=df227237a0829e251c79399f9d90774238763f98, for GNU/Linux 3.2.0, with debug_info, not stripped
```

## Download a cloud archive object
```bash
./dl_object.sh example-archive-cloud-container-1 toto .
> found toto-my-example-dataset.csv
> Downloading resource ...
```

**N.B. if the cloud archive is in cold state, the first request to target scelled object send a request of unscell for this object.**

## dl_object.sh CLI usage
```bash
./dl_object.sh --help
Script for downloading cloud archive object with OpenStack Swift API

USAGE: ./dl_object.sh <CONTAINER_NAME> <ITEM_LOOKING_FOR> <LOCATION>
                      [-h|--help]
  Where:
    CONTAINER_NAME    The name of cloud archive container. Must be 1st arg
    ITEM_LOOKING_FOR  The item object string pattern who you are looking for in container. Must be 2nd arg
    LOCATION          The destination of data retrieved. Must be 3rd arg
    -h or --help      show help
```

## bin/list-containers CLI usage
```bash
bin/list-containers.x86-64 example-archive-cloud-container-1
Found container with Name = example-archive-cloud-container-1, Number of object = 1
first 10 objects
Name = toto-my-example-dataset.csv, Bytes = 48371
```