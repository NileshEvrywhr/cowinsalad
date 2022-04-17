#!/usr/bin/bash

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"

cd ~/hacks/cowinsalad

# filter API responses for nearby slots 
# SLOTS=$(curl -s "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=650&date='"$(TZ="Asia/Kolkata" date '+%d-%m-%Y')"'" \
#     -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0' \
#     -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Origin: https://www.cowin.gov.in' \
#     -H 'Connection: keep-alive' -H 'Referer: https://www.cowin.gov.in/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: cross-site' \
#     -H 'If-None-Match: W/"c814-j9lr8tf0dp82O8Oy0UxJz4n3gEs"' -H 'TE: trailers' | 
#     jq -r '.centers[] | select(.fee_type == "Free") | select(.sessions[].min_age_limit == 18) | select(.sessions[].vaccine == "COVISHIELD") 
#     | select(.name == "GBN SSPHPGTI NOIDA" 
#     or .name == "GBN ESIC MODEL HOSPITAL" 
#     or .name == "GBN GIP MALL COVISHIELD" 
#     or .name == "GBN PHC BAROLA" 
#     or .name == "GBN PHC MAMURA" 
#     or .name == "GBN DISTRICT COMBINED HOSPITAL" 
#     or .name == "GBN UPHC RAIPUR" 
#     or .name == "GBN SPECTRUM METRO MALL") 
#     | select(.sessions[].available_capacity_dose2 > 0) 
#     | [(.sessions[].available_capacity_dose2|tostring), .name] | join(" ")' | sort -ur)

# filter API responses for precaution doses
SLOTS=$(curl -s "https://cdn-api.co-vin.in/api/v4/appointment/sessions/public/calendarByDistrict?district_id=650&date='"$(TZ="Asia/Kolkata" date '+%d-%m-%Y')"'" | 
    jq -r '.centers[] | select(.fee_type == "Free") | select(.sessions[].precaution_dose == 1) | select(.sessions[].min_age_limit == 18)
    | [(.sessions[].precaution_online_dose_one_available|tostring), .name] | join(" ")' | sort -ur)

# send messages on SLACK
curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$SLOTS"'"}' $SLACK_WEBHOOK_URL

# unit test is posting to slack works
# curl -X POST -H 'Content-type: application/json' --data '{"text":"lorem ipsum dolor"}' $SLACK_WEBHOOK_URL

# save to file
# echo $SLOTS > hereonly.json