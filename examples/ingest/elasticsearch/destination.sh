#!/usr/bin/env bash

# Processes all the files from s3://utic-dev-tech-fixtures/small-pdf-set/,
# embeds the processed documents, and writes to results to a Pinecone index.

# Structured outputs are stored in s3-small-batch-output-to-pinecone/

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"/../../.. || exit 1


# As an example we're using the s3 source connector,
# however ingesting from any supported source connector is possible.
PYTHONPATH=. ./unstructured/ingest/main.py \
        s3 \
         --remote-url "<s3 URL to ingest from, ie: s3://utic-dev-tech-fixtures/small-pdf-set/" \
         --anonymous \
         --output-dir s3-small-batch-output-to-pinecone \
         --num-processes 2 \
         --verbose \
         --strategy fast \
         --chunk-elements \
         --chunk-multipage-sections \
         --embedding-api-key "<OpenAI API Key to embed ingested elements>" \
        pinecone \
        --api-key "<Pinecone API Key to write into a Pinecone index>" \
        --index-name "<Pinecone index name, ie: ingest-test>" \
        --environment "<Pinecone environment name, ie: gcp-starter>"
