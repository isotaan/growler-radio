# growler-radio
This is a DCS World music jukebox script that allows you to play .mp3 files over SRS using Ciribob's wonderful [SimpleRadioStandalone](https://github.com/ciribob/DCS-SimpleRadioStandalone) and [SimpleTextToSpeech](https://github.com/ciribob/DCS-SimpleTextToSpeech) framework.

The way that Growler Radio works is that you feed it a table of songs as a playlist. Inside of DCS, a scheduled task from Growler Radio will start playing random songs from your list out through SRS on a frequency of your choice.

#### Disclaimer: 
* Use at your own risk. 
* Growler Radio requires editing MissionScripting.lua, so malicious code may be run from your DCS. 
* This is to be used for non-profit entertainment purposes only. 
* This may eat up your internet bandwidth if you do not use it carefully. Playing hours of .mp3s via SRS endlessly 

# Setup Part 1 - DCS Server
1. Download [SimpleRadioStandalone](https://github.com/ciribob/DCS-SimpleRadioStandalone) and install it on your server. Do all of the necessary things to configure and run SRS Server on your DCS Server machine.
2. Find the installation directory of SRS. This should be something like "C:\Program Files\DCS-SimpleRadio-Standalone". You're actually looking for the *folder* of the program called "DCS-SR-ExternalAudio.exe". Write this down.
3. Modify MissionScripting.lua on your DCS Server main install directory to allow external program commands from DCS. This file can be found in "\DCS World OpenBeta Server\Scripts". Follow the steps in the file.
    * MissionScripting.lua will revert after every patch or repair. In order for Growler Radio to work after patches, you will have to edit it after every patch.

# Setup Part 2 - Edit GR-MusicLibrary.lua
1. Put all MP3 files into a common location on your server. You may put them all in one folder or in separate folders if you wish.
2. Gather the exact file path, length of the song, and the name of the song for **each song** and put them in the playlist.
3. Open GR-MusicLibrary and make the following changes:
    - Insert the root path of your songs' directory as the GRLIB.root variable. All folders must have two backslashes instead of one. For example, it should look something like: ```GRLIB.root = "D:\\Music"```
    - Create or rename a playlist object table. This is the list that Growler Radio will randomize and iterate through when playing.
      * I have provided an example file that has example playlist: ```musicPlaylistVietnam = {}``` 
    - Put the file path of your intro .mp3 and the .mp3's length (in seconds). At present, an intro .mp3 is **mandatory.**
      * ```musicPlaylistVietnam.intro = {path = "\\Vietnam\\intro.mp3",length = 10}```
    - For each song in the table, put the path, length of the song (in seconds), and the name of the file.
      * It should look something like: 
        ```
        [1] = {path = "\\Vietnam\\Song1.mp3",length = 69,name = "Song Artist - Nice" },
        [2] = {path = "\\Vietnam\\Song2.mp3",length = 71,name = "Song Artist - Not Nice"},
        ...
        ```
    * You can name the files whatever you want, just keep in mind that you *must* have valid files that STTS will recognize.
    * If you do not correctly input the length of the songs, you will either have songs play over each other, or you will have excessive dead air.
    * You are truncating the file paths to exclude the portion listed in the GRLIB.root path. If you have a file that has a path of D:\Music\Vietnam\Song1.mp3, you will put:
    ```
    GRLIB.root = "D:\\Music"
    ...
    [1] = {path = "\\Vietnam\\Song1.mp3",length = 69,name = "Song Artist - Nice" }
    ```  
4. Ensure that you have all components of your modified GR-MusicLibrary.lua!

Below is a complete GR-MusicLibrary.lua file that has an intro and two songs:

```
GRLIB = {}
GRLIB.__index = GRLIB
GRLIB.root = "D:\\Music"

musicPlaylistVietnam = {}
  musicPlaylistVietnam.intro = {path = "\\Vietnam\\intro.mp3",length = 10}
  musicPlaylistVietnam.playlist = {
    [1] = {path = "\\Vietnam\\Song1.mp3",length = 69,name = "Song Artist - Nice" },
    [2] = {path = "\\Vietnam\\Song2.mp3",length = 71,name = "Song Artist - Not Nice"},
  }
```

# Setup Part 3 - Edit GrowlerRadio.lua (optional)
This section is optional as Growler Radio has been preconfigured. However, you may want to make changes to suit the exact needs of your mission.

## Frequencies & Modulation
Due to how STTS works, there are separate frequencies and modulation attributes that allow you to broadcast on multiple frequencies simultaneously. These are setup in Growler Radio as two separate string variables:

```
GROWLER.FREQ = "232,110,42.75"
GROWLER.MODULATION = "AM,AM,FM"
```

The above example will play songs simultaneously on 232.00 AM, 110.00 AM, and 42.75 FM.
## Volume

STTS uses a string that goes between 0.1 and 1.0 that determines the volume where 1.0 = 100% and 0.1 = 10%. Currently, it is not possible to play songs at different volumes in the same playlist.

```
GROWLER.VOLUME = "0.4"
```
I highly suggest you keep this at 0.4 as some songs with a strong bass beat will sound awful on some headphones.

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
  
  GROWLER.RADIOINIT(**yourplaylisthere**)
 
 For example, the actual code I use is:
 
 ```GROWLER.RADIOINIT(musicPlaylistVietnam)  ```

As I have previously setup musicPlaylistVietnam.intro and musicPlaylistVietnam.playlist in my GR-MusicLibrary.lua, Growler Radio will know where to find the intro file and all songs in the playlist.

## Growler Radio Commands

###  GROWLER.RADIOINIT(playlist)

This command will initialize and play Growler Radio. Currently, Growler Radio only allows one instance to run at a time. You must present a valid playlist in the correct format as described in Part 2 of the above instructions.

### GROWLER.GROWLERSTOP()

This command will stop the **next** song from playing. It will not stop the current song.

### GROWLER.GROWLERSKIP()

This command will skip the **next** queued song and go to the next song. It will not stop the current song. Currently only useful if you have ```GROWLER.VERBOSE = true```

# Frequently Asked Questions

## Isn't this a lot of work to setup? Why isn't this more user-friendly?

My code is spaghetti. Until I get things cleaned up, it's going to require a lot of manual effort to setup GR-MusicLibrary.lua. Fortunately, you only need to set it up once.


## I'm getting an error on my server from DCS-ExternalAudio.exe when I try to play a song.

This might be because you didn't configure STTS.DIRECTORY, GRLIB.root, or your individual file paths correctly. You can test this yourself by playing a single song via command prompt:

```
start "" /d "D:\DCS-SimpleRadio-Standalone" /b /min "DCS-SR-ExternalAudio.exe" -i "D:\Music\Vietnam\Song1.mp3" -f 232 -m AM -c 2 -p 5002 -n "Growler Radio" -v 1.0 -h
```
Edit the above paths for SRS and your music file (only single back slashes here!) and if it works, you should hear your example song on 232.00 MHz AM at full volume. If it works on the command prompt but not in Growler Radio, then you need to recheck your paths in your GR-MusicLibrary.lua or STTS.Directory

## I've done everthing right yet DCS-ExternalAudio occasionally crashes when playing songs that have worked before.

DCS-ExternalAudio occasionally crashes, and I do not know why it does this. CiriBob is an amazing developer, so only reach out to him for issues if- and only if!- you have completely eliminated Growler Radio as a source of your problems. I've found that the vast majority of the time when I'm having problems, it's because I missed something in GR-MusicLibrary.lua.



## Does this play songs for all sides, or can I pick whether to play this for just Red or Blue?

Currently, Growler Radio will play songs for all players.



## I've noticed that there will be gaps in songs or dead air even if I got the exact length of my songs.

This is because DCS-ExternalAudio takes some time to buffer songs. I do not control this but I have attempted to account for it in my code by adding some buffer time.



## Why can't I stop/skip a song playing instantly?

This is because once Growler Radio sends a song to DCS-External Audio, it's really out of my control. I'm sure there's some way to stop DCS-ExternalAudio via code coming from DCS, but my previous attempts at pkill have failed. Until I find a solution, the best I can do is have Growler Radio stop any additional songs from playing.



### Does this work with my favorite 8-hour song loop?

The longest song I have tried was Free Bird, which is 10 minutes, 7 seconds long. I have no idea whether DCS-ExternalAudio will work with songs of a longer length. I do not know whether your server's RAM will set on fire and explode if you try your favorite 10-hour chill song. If that happens, I am not responsible for you feeding DCS-ExternalAudio songs of excessive length- please do not try.


## Why is this code so unwieldy and so poorly put together?

Because I am bad at everything. This is my first major lua project **and** my first major github project. I'm certain smarter people than myself will find better solutions to this.



## Wouldn't it be better if...?

I welcome any and all suggestions. I'm hoping to move Growler Radio out of DCS entirely once I've taught myself Python, but that is a long term project of mine.



## Did you make DCS-ExternalAudio?

DCS-ExternalAudio was made by Ciribob and I do not support it. 

## Is it possible to play this on just an OpenBeta Client and not a dedicated server?

It is possible to use Growler Radio on a client, provided that MissionScripting.lua has been edited, and that SRS Server is running and the appropriate ports are configured properly. I did a lot of testing on my local client
