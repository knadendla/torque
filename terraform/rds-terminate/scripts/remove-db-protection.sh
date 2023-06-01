#!/bin/bash -x

echo "Region is ${REGION} and DB ID is ${DBID}"

aws rds modify-db-instance --db-instance-identifier ${DBID} --no-deletion-protection --region ${REGION}

