#!/bin/bash

csv_file="$1"

awk -F ';' 'NR>1 {print $5}' "$csv_file" | uniq | while read ou; do
	samba-tool ou add OU="$ou,DC=au-team,DC=irpo";
done

while IFS=";" read -r firstName lastName role phone ou street zip city country password; do
	if [ "$firstName" == "First Name" ]; then
		continue
	fi

	username="${firstName,,}.${lastName,,}"

	samba-tool user add "$username" P@ssw0rd1 \
		--given-name="$firstName" \
		--surname="$lastName" \
		--telephone-number="$phone" \
		--job-title="$role" \
		--userou="OU=$ou"
	samba-tool user setexpiry "$username" --noexpiry
	samba-tool user enable "$username"
done < "$csv_file"
