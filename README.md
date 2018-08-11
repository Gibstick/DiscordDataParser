
![demo](/examples/messages.png)
![demo](/examples/sessions.png)
![demo](/examples/words_by_usage.png)

# Usage
```
ruby app.rb --data-path=[PATH_TO_BACK_UP]
```

An executable version can also be found [here](https://github.com/Brainicism/DiscordDataParser/raw/master/bin/app.exe). Simply execute it in the backup folder.

The following .csv files are generated with the processed data:
- Messages by day
- Messages by day of week
- Messages by time of day
- Messages by thread
- Most frequently used phrases
- Game play count
- Reactions by use
- Time spent per device
- Time spent per location
- Time spent per OS

The following information is shown:
- Total number of messages sent
- Average message length
- Average messages per day
- Total number of sessions
- Total times app opened
- Average length per session
- Total number of reactions added/removed
- Total number of voice channel joins

Human readable versions of each message thread are also generated.

# Requesting your data
You can retrieve your past Discord messages by following the instructions in the article below.
https://support.discordapp.com/hc/en-us/articles/360004027692


# Event Types
Given that there is no documented list of possible `event_types`s, the repo contains a `event_list.txt` file that contains every `event_type` seen so far. Running the app with the `--verify-events` flag will check the data backup against `event_list.txt` and display any events missing. If there events are of interest, we should parse them, and re-run the app with `--update-events` to add the new events to `event_list.txt`.
