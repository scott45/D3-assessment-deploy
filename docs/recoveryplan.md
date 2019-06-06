Recovery Plan

In case of an attack, follow the following steps to recover and handle the situation;

1. Check the monitoring tools. (logs, requests, events/alerts).
2. Obtain the IP which has done the request.
3. check ssh history / logs. Alternatively check the authorized sshkeys in the meta data. 
ssh username@ipaddress (ssh scott@104.154.204.229)
cd ./.ssh && ls
cat authorised_keys 

3b. ssh scott@104.154.204.229
    sudo su
    history | grep whoami
    history | grep "select"

4. If all is worse, turn off the servers.

5. Turn on the staging servers and rout all the traffic from production to the staging IP

