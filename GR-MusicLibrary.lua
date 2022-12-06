--------------------------------------------------
-- Growler Radio Music Library
-- By isotaan
-- For use with Growler Radio, a DCS/SRS-based music player.
--------------------------------------------------


--Below is an example of what GR-MusicLibrary.lua should look like. You must edit this document in accordance with the readme.

GRLIB = {}
GRLIB.__index = GRLIB
GRLIB.root = "D:\\Music" --The root folder for your music files.

GR_Playlist_Vietnam = {}
GR_Playlist_Vietnam.intro = {path = "\\Vietnam\\intro_Vietnam.mp3",length = 10}
GR_Playlist_Vietnam.playlist = {
 [1] = {path = "\\Vietnam\\Song1.mp3",length = 69,name = "Fortunate Son" }, --The remainder of your file path, the length of the song (in seconds), and the name of the song.
 [2] = {path = "\\Vietnam\\Song2.mp3",length = 71,name = "Some Other Vietnam War Song"},
}
  
GR_Playlist_Classical = {}
GR_Playlist_Classical.intro = {path = "\\Classical\\intro_Classical.mp3",length = 10}
GR_Playlist_Classical.playlist = {
 [1] = {path = "\\Classical\\Song1.mp3",length = 100,name = "Classical Song #1" },
 [2] = {path = "\\Classical\\Song2.mp3",length = 102,name = "Classical Song #2"},
}  
  
   
env.info( "******** Growler Radio Music Library Loaded ********" )
