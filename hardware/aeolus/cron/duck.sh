#!/bin/sh

echo url="https://www.duckdns.org/update?domains=prof-lander&token=1f1f6551-d9b8-46e1-8ec2-3e2ffa2600b6&ip=" | curl -k -o /home/lander/duckdns/duck.log -K -
