# docker-kibana

Docker image of [Kibana](https://www.elastic.co/kibana/) working on ARM (especially on the Raspberry Pi).

# Image

- get from [Docker Hub](https://hub.docker.com/r/barasher/kibana-arm/tags) : `docker pull barasher/kibana-arm:7.10.0` (the tag corresponds to the Elasticsearch version)
- build from Dockerfile : `docker build -t barasher/kibana-arm:7.10.0 .`

# Run image

`docker run --rm -it -p 5601:5601 --name=kibana barasher/kibana-arm:7.10.0`

Kibana configuration folder is located in the folder `/etc/kibana`.

By default, Kibana is querying Elasticsearch on host `http://elasticsearch:9000` :
- it can be changed in the file `/etc/kibana/kibana.yaml`
- or you can link an elastisearch container with the kibana by adding `--link [ElasticsearchContainer]:elasticsearch` to the `docker run` command : `docker run --rm -it -p 5601:5601 --name=kibana --link myElasticContainer:elasticsearch barasher/kibana-arm:7.10.0`
