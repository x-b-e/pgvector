# syntax=docker/dockerfile:1

ARG PG_MAJOR="13"
ARG PG_TAG="13-13.3"

FROM postgis/postgis:13-3.3
# FROM postgis/postgis:${PG_TAG}

LABEL org.opencontainers.image.source "https://github.com/x-b-e/pgvector"
LABEL org.opencontainers.image.description "XBE server postgres with postgis, pgvector"
LABEL org.opencontainers.image.licenses "PostgreSQL License"

# ARG PG_MAJOR
# ENV PG_MAJOR=${PG_MAJOR}
ENV PG_MAJOR=13

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    postgresql-server-dev-all

# Set the pgvector version
ARG PGVECTOR_VERSION=0.4.1
ARG PGVECTOR_BUILD_DIR="pgvector"

COPY scripts/install_pgvector /tmp/install_pgvector

# Download and extract the pgvector release, build the extension, and install it
RUN /tmp/install_pgvector install "${PGVECTOR_VERSION}" "${PGVECTOR_BUILD_DIR}" && \
    rm -rf /tmp/*

# Clean up build dependencies and temporary files
RUN apt-get remove -y \
    build-essential \
    curl \
    postgresql-server-dev-all && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf "$PGVECTOR_BUILD_DIR"
