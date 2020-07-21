# takes in a list of mac addresses and fixes it to standard formatting XX:XX:XX:XX:XX:XX
for i in $(cat macs.txt); do echo "$i" | fold -w2 | tr '[:upper:]' '[:lower:]' | paste -sd':' -; done
