#!/bin/bash

project_name=$1
retain_jobs=$2
purge_batch_size=30

for project in $(curl -s -H "Content-Type:application/json" -H "X-RunDeck-Auth-Token:$API_TOKEN" http://$RUNDECK_HOST:4440/api/1/projects | xmlstarlet sel -t -v "//name/text()") ; do
 if [[ $project == $project_name ]]; then
   echo "Found $project_name" 
   echo "Finding all jobs..."
   for job_id in $(curl -G -s -H "Content-Type:application/json" -H "X-RunDeck-Auth-Token:$API_TOKEN" http://$RUNDECK_HOST:4440/api/1/jobs -d project=$project | xmlstarlet sel -t -v "//job/@id"); do
    echo "Processing job $job_id"
    while true ; do
     executions=$(curl -G -s -H "Content-Type:application/json" -H "X-RunDeck-Auth-Token:$API_TOKEN" http://$RUNDECK_HOST:4440/api/1/job/$job_id/executions -d max=$purge_batch_size -d offset=$retain_jobs | xmlstarlet sel -t -v //execution/@id | tr "\\n" "," | sed 's/,$//')
     if [[ $executions ]]; then
      curl -X POST -s -H "Content-Length:0" -H "X-RunDeck-Auth-Token:$API_TOKEN" http://$RUNDECK_HOST:4440/api/12/executions/delete?ids=$executions
      echo "Purged $purge_batch_size executions.."
     else
      break;
     fi
    done
   done
 fi
done
