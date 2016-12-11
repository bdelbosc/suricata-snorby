# Easy installation of Suricata with a Snorby interface

## Goal

Easy to setup suricata with a snorby UI.
Suricata must be installed on the target host to be able to sniff the network.
The Snorby UI and its stacks are running in docker containers.

The Snorby stack is composed of 3 containers:
- a mysql database server
- banyard2 that is reading the suricata events and send it to mysql
- snorby a web interface displaying events from the mysql database

This installation is only for testing/learning purpose and should not be used in production.

## links

Products:

- [surricata](https://redmine.openinfosecfoundation.org/projects/suricata): Suricata is the OISF IDP engine, the open source Intrusion Detection and Prevention Engine.
- [snorby](https://github.com/Snorby/snorby/wiki): Ruby On Rails Application For Network Security Monitoring.
- [banyard2](https://github.com/firnsy/barnyard2/wiki): a dedicated spooler for Snort's unified2 binary output format. 
- [mysql](http://dev.mysql.com/): an SQL database.
- [docker](https://www.docker.com/): open platform to build and ship distributed application in containers.

Dockers images:

- https://hub.docker.com/r/toulet/docker-barnyard2/
- https://hub.docker.com/r/polinux/snorby/
- https://hub.docker.com/_/mysql/

Docker and Docker compose documentations:

- https://docs.docker.com/

## Install requirements

You need to install docker compose and suricata in the target host, follow the installation guides:

- [docker compose](https://docs.docker.com/compose/install/) >= 1.9.0 (support of version 2 format)
- [suricata](https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Suricata_Installation) >= 1.12

Tested successfuly on ubuntu 14.04 with the following version:

- docker-compose version 1.9.0
- Docker version 1.12.0


## Configuration

1. Create a data directory for the MySQL database
```
sudo mkdir /opt/ids-data
```

2. Configure suricata to produce some events, editing `/etc/suricata/suricata.yaml`
   
   - check that unified2 is enabled to produce readable data for banyard2
	 `unified2-alert/enabled: yes`
   - the capture is on the expected network interface for instance:
	 `af-packet/interface: wlan1` for the wifi network
   - check the `rule-files` list and add a `test.rules` file with content like:
	 `alert tcp any any -> any any ( msg: "TCP packet detected!"; sid: 1; rev: 8;)`

   You need to restart the service once the configuration is modified.

## Running

### Suricata

`sudo service suricata restart`

## Start Snorby stack

From this current directory (where there is a `docker-compose.yml` file), run:

`docker-compose up`

You should have access to snorby, using the default login/password: snorby@snorby.org / snorby

http://localhost:3000/


To stop use Ctrl-C or from another terminal:

`docker-compose stop`

## Misc docker commands

```
# View the containers states:
docker-compose ps

# Run a shell on a container:
docker exec -it mysql bash

# View output of a containre
docker logs snorby

# Reset a container
docker-compose rm mysql

```


