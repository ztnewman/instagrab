#!/bin/bash

username="$1"
max_id=0

profile=$(wget --quiet -O - "https://www.instagram.com/${username}/" | grep -oP 'ProfilePage.*}')
profile_pic=$(echo $profile | grep -oP 'profile_pic_url_hd": .*?,'  | sed -e 's/[\,,"]//g'| awk '{ print $2 }')
name=$(echo $profile | grep -oP 'full_name": .*?,'  | sed -e 's/[\,,"]//g'| cut -d':' -f2)
bio=$(echo $profile | grep -oP 'biography": .*?,'  | grep -v null | sed -e 's/,//g'| cut -d':' -f2)
posts=$(echo $profile | grep -oP 'media": {"count": \d+'  | sed -e 's/}//g'| cut -d':' -f3)
following=$(echo $profile | grep -oP 'follows": {"count": \d+}'  | sed -e 's/}//g'| cut -d':' -f3)
followed_by=$(echo $profile | grep -oP 'followed_by": {"count": \d+}'  | sed -e 's/}//g'| cut -d':' -f3)

echo "<div class='profile_pic'>
                <img src='${profile_pic}'/>
        </div>
        <div class='profile'>
                <div class='username'>${username}</p></div>
                <div class='name'><p><span class='strong'>${name}</span></p></div>
                <div class='bio'><p>${bio}</p></div>
                <div class='stats'><p><span class='strong'>${posts}</span> posts  <span class='strong'>${followed_by}</span> followers  <span class='strong'>${following}</span> following<p></div>
        </div>" > profile.html

until [[ "$max_id" == "" ]]
do
        # echo "Max ID: $max_id"
        urls=$(wget --quiet -O - "https://www.instagram.com/${username}/media/?max_id=${max_id}" | grep -oP 'standard_resolution": {"url": .*?,' | sed -e 's/[",\,]//g' | awk '{print $3}' | cut -d'?' -f1)

        # echo "Downloading $urls"
        if [[ -n "$urls" ]]; then
                wget  --quiet -nc $urls
        fi

        max_id=$(wget --quiet -O - "https://www.instagram.com/${username}/media/?max_id=${max_id}" | grep -oP 'image", "id": .*?,' | sed -e 's/[",\,]//g' | tail -n 1 | awk '{print $3}')
done
