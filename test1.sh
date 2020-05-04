#!/usr/bin/bash
endpoint=$ENDPOINT
username=$CONTROLM_CREDS_USR
password=$CONTROLM_CREDS_PSW

echo "{\"username\":\"$username\",\"password\":\"$password\"}"   >> log.txt

# Login
echo "Logging in" >> log.txt
login=$(curl -k -s -H "Content-Type: application/json" -X POST -d "{\"username\":\"$username\",\"password\":\"$password\"}" "$endpoint/session/login" )  >> log.txt
if [[ $login == *error* ]]; then
    echo 'Login failed!'
    exit 1
fi
token=$(echo ${login##*token\" : \"} | cut -d '"' -f 1)  >> log.txt

# Test - run the jobs
echo "Running test jobs"
curl -k -s -H "Authorization: Bearer $token" -X POST -F "jobDefinitionsFile=@testjobs1.json" "$endpoint/deploy"  >> log.txt
submit=$(curl -k -s -H "Authorization: Bearer $token" -X POST -F "jobDefinitionsFile=@testjobs1.json" "$endpoint/run")  >> log.txt
runid=$(echo ${submit##*runId\" : \"} | cut -d '"' -f 1)  >> log.txt

# Check job status
jobstatus=$(curl -k -s -H "Authorization: Bearer $token" "$endpoint/run/status/$runid")  >> log.txt
status=$(echo ${jobstatus##*status\" : \"} | cut -d '"' -f 1)  >> log.txt

echo "Waiting for jobs to end"
# Wait until jobs have finished running
until [[ $status == Ended* ]]; do
    sleep 10
    tmp=$(curl -k -s -H "Authorization: Bearer $token" "$endpoint/run/status/$runid")   >> log.txt
    echo $tmp | grep 'Not OK' >/dev/null && exit 2   >> log.txt
    tmp2=$(echo ${tmp##*$'\"type\" : \"Folder\",\\n'})   >> log.txt
    status=$(echo ${tmp2##*\"status\" : \"} | cut -d '"' -f 1)   >> log.txt
done

# Logout
curl -k -s -H "Authorization: Bearer $token" -X POST "$endpoint/session/logout"   >> log.txt

# Exit
if [[ $status == *Not* ]]; then
    echo 'Job failed!'
    exit 1
else
    echo 'Success'
    exit 0
fi
