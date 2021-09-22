#!/bin/bash

curl -X GET -H "Authorization: Bearer ${BEARER_TOKEN}"  "https://api.twitter.com/2/tweets/$1?expansions=attachments.media_keys&tweet.fields=created_at,author_id,lang,source,public_metrics,context_annotations,entities,conversation_id"
