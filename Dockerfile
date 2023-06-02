FROM apache/airflow:2.6.1
# Add apt package for python packages the required extra c++ libs, ...
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         vim openjdk-11-jre-headless \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
  
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Install custom python libs
USER airflow
COPY requirements.txt /
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" -r /requirements.txt

# Embed DAGs code into docker
COPY --chown=airflow:root dags/* /opt/airflow/dags