FROM debian:latest

# https://discuss.elastic.co/t/installing-kibana-on-a-raspberry-pi-4-using-raspbian-buster/202612

ENV KIBANA_VERSION 7.6.1
ENV NODEJS_VERSION 10.19.0

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
#RUN bash install_nvm.sh
#RUN source ~/.bashrc
#RUN nvm install ${NODEJS_VERSION}
RUN node -v

# install kibana
RUN mkdir /usr/share/kibana
WORKDIR /usr/share/kibana
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-amd64.deb
RUN dpkg -i --force-all kibana-${KIBANA_VERSION}-amd64.deb
RUN echo 'elasticsearch.hosts: ["http://elasticsearch:9200"]' >> /etc/kibana/kibana.yml
RUN echo 'server.host: "0"' >> /etc/kibana/kibana.yml

CMD /root/.nvm/versions/node/v10.19.0/bin/node /usr/share/kibana/src/cli --allow-root
