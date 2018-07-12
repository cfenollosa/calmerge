#!/usr/bin/env bash

# Config
allow_summary=1  # Set to 0 to blank all event names
in_files="file1.ics file2.ics"  # As many as you want (more than one) separated by spaces
out_file="out.ics"  # Output to a Dropbox folder to share it easily
calname="out"  # Name that will be displayed in the client. Leave blank to use first calendar's name

# Code starts here
rm -f "$out_file"

allowed="DTEND DTSTAMP SEQUENCE DTSTART CREATED LAST-MODIFIED RRULE RECURRENCE-ID EXDATE"  # Allowed fields for events
[[ $allow_summary -eq 1 ]] && allowed="$allowed SUMMARY"

in_event=0
first_cal=1  # Inherit calendar metadata from first only
for in_file in $in_files; do
    while read line; do
        [[ "$line" == BEGIN:VEVENT* ]] && in_event=1 && has_uid=0 && echo "$line" >> "$out_file" && continue
        [[ "$line" == END:VEVENT* ]] && in_event=0 echo "$line" >> "$out_file" && continue
        [[ "$line" == END:VCALENDAR* ]] && continue
        [[ "$calname" ]] && [[ "$line" == X-WR-CALNAME* ]] && echo "X-WR-CALNAME:$calname" >> $out_file && continue

        if [[ $in_event -eq 1 ]]; then
            for i in $allowed; do
                [[ "$line" == $i* ]] && echo "$line" >> "$out_file" && continue
            done
            # Use only event UID
            [[ "$line" == UID:* ]] && [[ $has_uid -eq 0 ]] && echo "$line" >> "$out_file" && has_uid=1 && continue
        elif [[ $first_cal -eq 1 ]]; then  # Only copy non-event data from first cal
            echo "$line" >> "$out_file" && continue
        fi
    done < $in_file
    first_cal=0
done

echo "END:VCALENDAR" >> $out_file
