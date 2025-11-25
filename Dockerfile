FROM jupyter/pyspark-notebook

# Switch to root to install extra packages
USER root

# Optional: update base image packages (kept minimal here)
# RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Python deps for your project
RUN pip install --no-cache-dir \
    python-dotenv \
    requests \
    beautifulsoup4

# Azure ADLS / ABFS connector jars for Spark (versions compatible with Hadoop 3.x)
ENV SPARK_HOME=/usr/local/spark

RUN mkdir -p "$SPARK_HOME/jars" && \
    curl -L -o "$SPARK_HOME/jars/hadoop-azure-3.3.4.jar" \
      https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.3.4/hadoop-azure-3.3.4.jar && \
    curl -L -o "$SPARK_HOME/jars/azure-storage-8.6.6.jar" \
      https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/8.6.6/azure-storage-8.6.6.jar

# Back to jovyan user (default in jupyter images)
USER ${NB_UID}

# Workdir where your project will be mounted
WORKDIR /home/jovyan/work
