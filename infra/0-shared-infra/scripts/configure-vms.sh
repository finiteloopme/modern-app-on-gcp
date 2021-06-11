#!/bin/bash
TAG_TO_FILTER_ON="modern-gcp-app"
# VM_AND_ZONE_LIST=`gcloud compute instances list --filter="(tags.items=${TAG_TO_FILTER_ON})" --format="table[no-heading](name, zone)"`
# echo ${VM_AND_ZONE_LIST}
# set -- ${VM_AND_ZONE_LIST}
# index=1
# for index in $(seq 1 $#)
# do
#   echo "Arg #${index}"
#   let "index+=1"
#   echo "Arg #${index}"
# done             # $@ sees arguments as separate words. 

for line in `gcloud compute instances list --filter="(tags.items=${TAG_TO_FILTER_ON})" --format="table[no-heading](name)"`
do
    echo $line
done
