# Easy installation of Suricata with a Snorby interface

## Goal

Setup easily the Suricata IDS with a Snorby user interface.
Suricata must be installed on the target host to be able to sniff the network.
The Snorby UI and its stack are running in docker containers.

The Snorby stack is composed of 3 containers:
- snorby a web interface displaying events from the database.
- barnyard2 that parse suricata events and send them into the database.
- mysql the database server.

This installation is only for testing/learning purpose and should not be used in production.

## Links

Products:

- [surricata](https://redmine.openinfosecfoundation.org/projects/suricata): Suricata is the OISF IDP engine, the open source Intrusion Detection and Prevention Engine.
- [snorby](https://github.com/Snorby/snorby/wiki): Ruby On Rails Application For Network Security Monitoring.
- [barnyard2](https://github.com/firnsy/barnyard2/wiki): a dedicated spooler for Snort's unified2 binary output format. 
- [mysql](http://dev.mysql.com/): a SQL database.
- [docker](https://www.docker.com/): open platform to build and ship distributed application in containers.

Dockers images used:

- https://hub.docker.com/r/toulet/docker-barnyard2/
- https://hub.docker.com/r/polinux/snorby/
- https://hub.docker.com/_/mysql/

Docker documentation:

- https://docs.docker.com/

## Installation requirements

You need to install Docker-compose and Suricata in the target host, follow the installation guides:

- [docker compose](https://docs.docker.com/compose/install/) >= 1.9.0 (support of version 2 format)
- [suricata](https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Suricata_Installation) >= 1.12

Tested successfuly on ubuntu 14.04 with the following version:

- docker-compose version 1.9.0
- Docker version 1.12.0


## Configuration

1. Clone or download a ZIP of the source https://github.com/bdelbosc/suricata-snorby
2. Create a data directory for the MySQL database
   ```
   sudo mkdir /opt/ids-data
   ```
3. Configure suricata to produce some events, editing `/etc/suricata/suricata.yaml`
   - check that `unified2` is enabled to produce readable data for `barnyard2`
	 ```
	 unified2-alert
	   enabled: yes
	   ...
     ```
   - the capture is on the expected network interface for instance:
	 ```
	 af-packet
	   interface: wlan1
	   ...
     ```
   - check the `rule-files` list, you can add a new `test.rules` file with content like:
     ```
	 alert tcp any any -> any any ( msg: "TCP packet detected!"; sid: 1; rev: 8;)
	 ```
4. Restart suricata, see below.

## Running

### Suricata

```
sudo service suricata restart
```

## Snorby stack

From this current directory (where there is a `docker-compose.yml` file), run:

```
docker-compose up
```

You should have access to snorby, using the default login/password: `snorby@snorby.org` / `snorby`

[http://localhost:3000/](http://localhost:3000/)


To stop use `Ctrl-C` or from another terminal:

```
docker-compose stop
```

## Miscellaneous docker commands

```
# View the containers states:
docker-compose ps

# Run a shell on a container:
docker exec -it mysql bash

# View output of a container:
docker logs snorby

# Reset a container:
docker-compose rm mysql

```

