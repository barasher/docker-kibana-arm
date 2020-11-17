FROM debian:latest

# https://discuss.elastic.co/t/installing-kibana-on-a-raspberry-pi-4-using-raspbian-buster/202612

ENV KIBANA_VERSION 7.10.0
ENV NODEJS_VERSION 10.22.1

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update
RUN apt-get install -yq wget nodejs

# install nodejs
RUN wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh -O install_nvm.sh \
	&& bash install_nvm.sh \
	&& source /root/.nvm/nvm.sh \
	&& nvm install ${NODEJS_VERSION} \
	&& nvm alias default ${NODEJS_VERSION} \
	&& nvm use default
RUN node -v

# install kibana
RUN mkdir /usr/share/kibana
WORKDIR /usr/share/kibana
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-amd64.deb
RUN dpkg -i --force-all kibana-${KIBANA_VERSION}-amd64.deb

# post-install
RUN cat /usr/share/kibana/bin/kibana | sed 's/^NODE=.*/NODE=\"\/root\/.nvm\/versions\/node\/v10.22.1\/bin\/node\"/' > /tmp/kibana2
RUN cat /tmp/kibana2 > /usr/share/kibana/bin/kibana
RUN mkdir -p /usr/share/kibana/config/
RUN ln -s /etc/kibana/kibana.yml /usr/share/kibana/config/kibana.yml
 
# configure
RUN echo 'elasticsearch.hosts: ["http://elasticsearch:9200"]' >> /etc/kibana/kibana.yml
RUN echo 'server.host: "0"' >> /etc/kibana/kibana.yml

CMD /usr/share/kibana/bin/kibana --allow-root
