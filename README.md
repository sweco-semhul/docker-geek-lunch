# Nördlunch Docker

## Vad är Docker?
Docker är en open source-produkt med ett bolag med samma namn bakom. Docker är från början för Linux men har kommit till fler plattformar tex Mac och Windows.
[www.docker.com/products/docker](https://www.docker.com/products/docker)

![Alt text](virtual_vs_docker.png?raw=true "Virtual Machines vs Containers")

## image och container, två viktiga komponenter

### image

Recept för att skapa en container. Alltså vilka ingående komponenter som ska vara med i min server (Java 1.6.5, Apache 2.0 osv) det som tidigare gjordes förhand en gång och sedan glömdes bort. Vilket gjorde det jobbigt att göra om och att återanvända.

Färdiga images, image bibliotek: [hub.docker.com](https://hub.docker.com) ,,, (*går även att hämta från github eller egen hostad image library*)

### container

En container utgår alltid från en image och är det som körs

`docker run -i -t ubuntu /bin/bash`

*(Finns många run kommandon dessa betyder: -t = Allocate a pseudo-tty, -i = Keep STDIN open even if not attached. [Mer info finns här](https://docs.docker.com/engine/reference/run/))*

Köra en viss version:

`docker run -i -t ubuntu:12.04 /bin/bash`



## bygga egen image = Dockerfile

[Ett exempel är Postgis på Dockerhub](https://hub.docker.com/r/mdillon/postgis/~/dockerfile/)

Ett litet exempel:

```
FROM mdillon/postgis:9.4

ADD sql/*.sql /docker-entrypoint-initdb.d/
```

---

**Bygga** `docker build -t min-postgis-image:0.1 ./postgis_docker_exempel`

**Starta** `docker run -d -p 5432:5432 --name min-postgis-container -it min-postgis-image:0.1 postgres` *-d = detached*

---

**Hur mår containern?** 

`docker ps`

`docker logs min-postgis-container`

---

**Anslut till**

`docker exec -it min-postgis-container psql -Upostgres -c "select * from geodata;"`

**Stoppa**
`docker stop min-postgis-container`

## men om jag har flera containrar, hur göra då?

Jobbigt att hålla koll på ett `docker build` / `docker run` kommando. Ännu jobbigare om det är flera...

[**docker-compose**](https://docs.docker.com/compose/gettingstarted/#/step-3-define-services) räddar oss. (Finns med i kartongen i Docker for Mac och Docker for Windows)

docker-compose.yml exempel:

```
min-postgis:
  build: postgis_docker_exempel/.
  ports:
    - "5432:5432"

min-geoserver:
  image: winsent/geoserver
  links:
    - min-postgis
  ports:
    - "8080:8080"
```

`docker-compose up`

[http://localhost:8080/geoserver/web](http://localhost:8080/geoserver/web)


# Vad gör vi idag?

Varför göra det idag? Främst för att förenkla överlämnande och uppsättning av utvecklingsmiljöer.


##Exempel

[Arkitekternas referensdatabas](https://github.com/sweco/6604323000-referensdatabas/tree/feature/elasticsearch/containers)

[Naturvårdsverket stationsregister](https://github.com/sweco/6604349000-NV_Stationsregister/tree/develop/containers)

[Posten postnummer redigering, PCC4](https://github.com/sweco/6604639000-pcc4/tree/develop/database)

[Nackas externkarta](https://github.com/sweco/6602874000-externwebb_nacka/tree/master/containers)