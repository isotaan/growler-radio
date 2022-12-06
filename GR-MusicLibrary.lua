--------------------------------------------------
-- Growler Radio Music Library
-- By isotaan
-- For use with Growler Radio, a DCS/SRS-based music player.
--------------------------------------------------

GRLIB = {}
GRLIB.__index = GRLIB
GRLIB.root = "D:\\Music"

GR_Playlist_Vietnam = {}
GR_Playlist_Vietnam.intro = {path = "\\Vietnam\\intro_Vietnam.mp3",length = 10}
GR_Playlist_Vietnam.playlist = {
 [1] = {path = "\\Vietnam\\Song1.mp3",length = 69,name = "Fortunate Son" },
 [2] = {path = "\\Vietnam\\Song2.mp3",length = 71,name = "Some Other Vietnam War Song"},
}
  
GR_Playlist_Classical = {}
GR_Playlist_Classical.intro = {path = "\\Classical\\intro_Classical.mp3",length = 10}
GR_Playlist_Classical.playlist = {
 [1] = {path = "\\Classical\\Song1.mp3",length = 100,name = "Classical Song #1" },
 [2] = {path = "\\Classical\\Song2.mp3",length = 102,name = "Classical Song #2"},
}  
  
   
env.info( "******** Growler Radio Music Library Loaded ********" )
