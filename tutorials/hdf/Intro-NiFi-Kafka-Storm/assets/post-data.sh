#!/bin/sh

json="{\"name\": \"$1\", \"age\": $2}"
curl -i -XPOST -H "Content-type: application/json" -d "${json}" localhost:9095
echo