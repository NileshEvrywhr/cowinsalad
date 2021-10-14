#!/usr/bin/bash

# run every minute
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"

cd ~/hacks/cowinsalad
# curl -s "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=650&date=13-10-2021" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Origin: https://www.cowin.gov.in' -H 'Connection: keep-alive' -H 'Referer: https://www.cowin.gov.in/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: cross-site' -H 'If-None-Match: W/"c814-j9lr8tf0dp82O8Oy0UxJz4n3gEs"' -H 'TE: trailers' | jq . > "out/$(TZ="Asia/Kolkata" date '+%d%m%Y-%T')".json

SLOTS=$(curl -s "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=650&date='"$(TZ="Asia/Kolkata" date '+%d-%m-%Y')"'" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Origin: https://www.cowin.gov.in' -H 'Connection: keep-alive' -H 'Referer: https://www.cowin.gov.in/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: cross-site' -H 'If-None-Match: W/"c814-j9lr8tf0dp82O8Oy0UxJz4n3gEs"' -H 'TE: trailers' | jq -r '.centers[] | select(.fee_type == "Free") | select(.sessions[].min_age_limit == 18) | select(.sessions[].vaccine == "COVISHIELD") | select(.name == "GBN DISTRICT COMBINED HOSPITAL" or .name == "GBN ESIC MODEL HOSPITAL" or .name == "GBN GIP MALL COVISHIELD" or .name == "GBN PHC BAROLA" or .name == "GBN PHC MAMURA" or .name == "GBN SSPHPGTI NOIDA" or .name == "MAHILA SPECIAL GBN 01 (18-44)" or .name == "GBN UPHC RAIPUR" or .name == "GBN SPECTRUM METRO MALL") | select(.sessions[].available_capacity_dose2 > 0) | [(.sessions[].available_capacity_dose2|tostring), .name] | join(" ")' | sort -u)

curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$SLOTS"'"}' $SLACK_WEBHOOK_URL
