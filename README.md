# growler-radio
This is a lightweight DCS World music jukebox script that allows you to play .mp3 files to players on multiplayer servers using SRS using Ciribob's wonderful [SimpleRadioStandalone](https://github.com/ciribob/DCS-SimpleRadioStandalone) and [SimpleTextToSpeech](https://github.com/ciribob/DCS-SimpleTextToSpeech) framework.

The way that Growler Radio works is that you feed it a table of songs as a playlist. Inside of DCS, a scheduled task from Growler Radio will start playing random songs from your list out through SRS on a frequency of your choice.

This jukebox script is lightweight because all you need in the .miz file are two .lua scipts. All .mp3 files will have to be present on the server.

#### Disclaimer: 
* Use at your own risk. 
* Growler Radio requires editing MissionScripting.lua which protects you from malicious code from being run from DCS.
* This is to be used for non-profit entertainment purposes only. 
* This may eat up your internet bandwidth if you do not use it carefully. Playing hours of .mp3s via SRS endlessly may burn through your bandwidth cap.

# Setup Part 1 - DCS Server
1. Download [SimpleRadioStandalone](https://github.com/ciribob/DCS-SimpleRadioStandalone) and install it on your server. Do all of the necessary things to configure and run SRS Server on your DCS Server machine.
2. Find the installation directory of SRS. This should be something like "C:\Program Files\DCS-SimpleRadio-Standalone". You're actually looking for the *folder* of the program called "DCS-SR-ExternalAudio.exe". Write this down.
3. Modify MissionScripting.lua on your DCS Server main install directory to allow external program commands from DCS. This file can be found in "\DCS World OpenBeta Server\Scripts". Follow the steps in the file.
    * MissionScripting.lua will revert after every patch or repair. In order for Growler Radio to work after patches, you will have to edit it after every patch.

# Setup Part 2 - Edit GR-MusicLibrary.lua
1. Put all MP3 files into a common location on your server. You may put them all in one folder or in separate folders if you wish.
2. Gather the exact file path, length of the song, and the name of the song for **each song** and put them in the playlist.
3. Open GR-MusicLibrary and make the following changes:
    - Create or rename a playlist object table. This is the list that Growler Radio will randomize and iterate through when playing.
      * I have provided an example file that a playlist: ```GR_Playlist_Vietnam``` 
    - For each song in the table, put the path, length of the song (in seconds), and the name of the file. It should look something like: 
       ``` 
       [1] = {path = "\\Vietnam\\Song1.mp3",length = 69,name = "Fortunate Son" },
       [2] = {path = "\\Vietnam\\Song2.mp3",length = 71,name = "Some Other Vietnam War Song"},
       ```

        
    * You can name the files whatever you want, just keep in mind that you *must* have valid files that STTS will recognize.
    * If you do not correctly input the length of the songs, you will either have songs play over each other, or you will have excessive dead air.
    * You are truncating the file paths to exclude the portion listed in the GROWLER.MUSICROOT path. If you have a file that has a path of D:\Music\Vietnam\Song1.mp3, you will put:
    ```
    GROWLER.MUSICROOT = "D:\\Music"
    ...
    [1] = {path = "\\Vietnam\\Song1.mp3",length = 69,name = "Song Artist - Nice", vol = "0.4" }
    
    - vol is an optional string. It is the volume of the played song between 0.1 and 1.0.
    
    - You can setup an optional announcer playlist that is interwoven in your song playlist. Set this up just like any other playlist.
    
    
    ```  
4. Ensure that you have all components of your modified GR-MusicLibrary.lua!

Below is a complete GR-MusicLibrary.lua file that has four songs in two playlists:

```
GR_Playlist_Vietnam = {}
GR_Playlist_Vietnam.intro = {path = "\\Vietnam\\intro_Vietnam.mp3",length = 10}
GR_Playlist_Vietnam.playlist = {
 [1] = {path = "\\Vietnam\\Song1.mp3",length = 69,name = "Fortunate Son", vol = "0.8" },
 [2] = {path = "\\Vietnam\\Song2.mp3",length = 71,name = "Some Other Vietnam War Song"},
}
  
GR_Playlist_Classical = {}
GR_Playlist_Classical.intro = {path = "\\Classical\\intro_Classical.mp3",length = 10}
GR_Playlist_Classical.playlist = {
 [1] = {path = "\\Classical\\Song1.mp3",length = 100,name = "Classical Song #1" },
 [2] = {path = "\\Classical\\Song2.mp3",length = 102,name = "Classical Song #2"},
}   
```

# Setup Part 3 - Edit growler-radio.lua
This section is optional as Growler Radio has been preconfigured. However, you may want to make changes to suit the exact needs of your mission.

## Setup GROWLER.MUSICROOT (Mandatory!)
Set GROWLER.MUSICROOT

## Frequencies & Modulation
Due to how STTS works, there are separate frequencies and modulation attributes that allow you to broadcast on multiple frequencies simultaneously. These are setup in Growler Radio as two separate string variables:

```
GROWLER.FREQ = "232,137,42.75"
GROWLER.MODULATION = "AM,AM,FM"
```

The above example will play songs simultaneously on 232.00 AM, 110.00 AM, and 42.75 FM.
## Volume

STTS uses a string that goes between 0.1 and 1.0 that determines the volume where 1.0 = 100% and 0.1 = 10%. Each entry in your music library library can have an individual song volume. GROWLER.VOLUME is a default value for when a song does not have a specific volume.

```
GROWLER.VOLUME = "0.4"
```
You will likely want to tweak your volumes both as a default and for individual songs. SRS has made some changes that alters how some songs play so they can get washed out at higher volumes.

## Debug / Verbose Messaging

```
GROWLER.VERBOSE = false
```

When true, this will send a message to all players informing them of the currently playing track, the length of the track, and the track queued up next. The default setting is false (off).


# Setup Part 4 - Setup your mission in the DCS Mission Editor
1. Load [CiriBob's SimpleTextToSpeech](https://github.com/ciribob/DCS-SimpleTextToSpeech). You will want to configure STTS.DIRECTORY per CiriBob's instructions. You should have already written down the necessary file path when you were following Part 1, Step 2 all of the way at the top of this screen.
2. Load your edited GR-MusicLibrary.lua
3. Load GrowlerRadio.lua
4. You can start the radio via the mission editor trigger DO SCRIPT that runs after the previous 3 steps are completed.
  
  GROWLER.RADIOINIT( {playlist = yourplaylist, announcerlist = yourannouncerlist})
 
 For example, the actual code I use is:
 
 ```GROWLER.RADIOINIT({playlist = musicPlaylistVietnam, announcerlist = announcerList})  ```

As I have previously defined musicPlaylistVietnam and announcerList in my GR-MusicLibrary.lua, Growler Radio will know where to find the music files and all of the announcer files.

## Growler Radio Commands

###  GROWLER.RADIOINIT({playlist = playlistName, announcerlist = announcerListName})

This command will initialize and play Growler Radio. Currently, Growler Radio only allows one instance to run at a time. You must present a valid playlist in the correct format as described in Part 2 of the above instructions.

This command only needs to be run once. Growler Radio will randomize your playlist and start going through all of the songs. Once at the end of the songs, Growler Radio will automatically stop and send a message to all players. You can add in radio announcer files through the optional announcerlist argument.

At this point, you can restart Growler Radio either with the same playlist or with another playlist.

### GROWLER.GROWLERSTOP()

This command will stop the **next** song from playing. It will not stop the current song.

### GROWLER.GROWLERSKIP()

This command will skip the **next** queued song and go to the next song. It will not stop the current song. Currently only useful if you have ```GROWLER.VERBOSE = true```.

# Frequently Asked Questions

## Why do this? Why all of the work when DCS has triggers to play sounds?
DCS mission files are archives that contain every trigger, script, and song. The full .miz file must be downloaded by every player when they load into your mission. For single-player this isn't a big deal, but for multiplayer it can cause excessively long load times and crashes. Having the songs in the .miz file means that players' .trk files will become *enormous*, especially if they keep leaving and rejoining the server.

My implementation of a jukebox has all .mp3 files sit on the server instead of being handed off to clients. Players on a multiplayer server only need SRS to be able to listen to the songs. Since all files sit on the server, you can put as many songs as you want, provided that each song has an entry in GR-MusicLibrary.lua.

## Isn't this a lot of work to setup? Why isn't this more user-friendly?

My code is spaghetti. Until I get things cleaned up, it's going to require a lot of manual effort to setup GR-MusicLibrary.lua..


## What is error "System.IO.DirectoryNotFoundException" for DCS-SR-ExternalAudio.exe?

This might be because you didn't configure STTS.DIRECTORY, GROWLER.MUSICROOT, or your individual file paths correctly. You can test this yourself by playing a single song via command prompt:

```
start "" /d "D:\DCS-SimpleRadio-Standalone" /b /min "DCS-SR-ExternalAudio.exe" -i "D:\Music\Vietnam\Song1.mp3" -f 232 -m AM -c 2 -p 5002 -n "Growler Radio" -v 1.0 -h
```
Edit the above paths for SRS and your music file (only single back slashes here!). If the command works, you should see activity in your command prompt on your server while music plays at 232.00 MHz AM at full volume.

If it works when testing the song via command prompt but gives an error popup, then check your GR-MusicLibrary.lua, growler-radio.lua or what you have defined in STTS.DIRECTORY.

## What is error "NAudio.MmException" for DCS-SR-ExternalAudio.exe?

This is likely because you don't have codecs installed on your server.

## Songs don't play but I don't get any error on my server. What gives?

You might have forgotten to edit MissionScripting.lua in Part 1. If that script is not edited prior to DCS Server starting, then DCS will be unable to communicate with DCS-SR-ExternalAudio.exe.


## I've done everthing right yet DCS-SR-ExternalAudio.exe occasionally crashes when playing songs that have worked before.

DCS-SR-ExternalAudio.exe occasionally crashes, and I do not know why it does this. CiriBob is an amazing developer, so PLEASE only reach out to him for issues if- and only if!- you have completely eliminated Growler Radio as a source of your problems. I've found that the vast majority of the time when I'm having problems, it's because I missed something in GR-MusicLibrary.lua.

He's better at this than I am, so it's quite possible that something broke in my script or your music library than anything he does.

## Does this play songs for all sides, or can I pick whether to play this for just Red or Blue?

Currently, Growler Radio is setup to play songs for all players.


## Why do I hear dead air at the end of some songs or small overlaps with the next song?

This is because DCS-SR-ExternalAudio.exe takes some time to buffer your .mp3 before playing. I do not control how fast DCS-SR-ExternalAudio.exe performs but I have attempted to account for it in such a way as to accommodate your average song length.

You will notice this more on songs of excessive length.

## Why can't I stop/skip a song playing instantly?

This is because once Growler Radio sends a song to DCS-External Audio, it's really out of my control. You may notice that when STTS sends a command to DCS-External Audio, a command prompt shows up, starts encoding, and then transmits the sounds. It's probably not a good idea to send pkill commands from DCS. If someone else knows of a way to do this safely, I'm all ears.

Until I find a solution, the best I can do is have Growler Radio stop any additional songs from playing.


## Does this work with my favorite 8-hour song loop?

The longest song I have tried was Free Bird, which is 10 minutes, 7 seconds long. I have no idea whether DCS-SR-ExternalAudio.exe will work with songs of a longer length, but I imagine that it'll take DCS-SR-ExternalAudio.exe ages to process.

Only try this at your own risk. I am not responsible for you feeding DCS-SR-ExternalAudio.exe songs of excessive length and your RAM catching on fire.

I have noticed that longer songs tend to take a longer time to buffer


## Why is this code so unwieldy and so poorly put together?

Because I am bad at everything. This is my first major lua project **and** my first major github project. I'm certain smarter people than myself will find better solutions to this.



## Wouldn't it be better if...?

I welcome any and all suggestions. I'm hoping to move Growler Radio out of DCS entirely once I've taught myself Python, but that is a long term project of mine.


## Did you make DCS-SR-ExternalAudio.exe?

DCS-SR-ExternalAudio.exe was made by Ciribob and I do not support it.

## Is it possible to play this on just an OpenBeta Client and not a dedicated server?

It is possible to use Growler Radio on a client, provided that MissionScripting.lua has been edited, and that SRS Server is running and the appropriate ports are configured properly. I did a lot of testing on my local client
