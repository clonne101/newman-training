#!/bin/bash

printf "Running newman tests for the Space X Api\n"

cat newman_ascii

printf "\n"

docker run -v $(pwd)/collection:/etc/newman \
--entrypoint /bin/sh postman/newman:alpine -c "\
npm i -g newman-reporter-csv newman-reporter-html newman-reporter-htmlextra --unsafe-perm; \
newman run /etc/newman/space_x.json --bail --insecure --ignore-redirects --verbose \
--reporters cli,json,csv,htmlextra --reporter-htmlextra-export /etc/newman/summaries/summary.html --reporter-json-export \
/etc/newman/summaries/summary.json --reporter-csv-export /etc/newman/summaries/summary.csv"

printf "\n"