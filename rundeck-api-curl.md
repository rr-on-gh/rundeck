

####List all projects
```curl -s -H "Content-Type:application/json" -H "X-RunDeck-Auth-Token:xxxxxxx" http://localhost:4440/api/1/projects | xmlstarlet sel -t -v "//name/text()" ```

####List all job ids
```curl -G -s -H "Content-Type:application/json" -H "X-RunDeck-Auth-Token:xxxxx" http://localhost:4440/api/1/jobs -d project=PROJNAME |  xmlstarlet sel -t -v "//job/@id"```

####List all job names
```curl -G -s -H "Content-Type:application/json" -H "X-RunDeck-Auth-Token:xxxxx" http://localhost:4440/api/1/jobs -d project=PROJNAME |  xmlstarlet sel -t -v "//job/name/text()"```


