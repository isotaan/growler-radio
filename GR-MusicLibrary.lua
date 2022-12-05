--------------------------------------------------
-- Growler Radio Music Library
-- By isotaan
-- For use with Growler Radio, a DCS/SRS-based music player.
--------------------------------------------------

GRLIB = {}
GRLIB.__index = GRLIB
GRLIB.root = "D:\\Music" -- Put your root directory here

musicPlaylistVietnam = {}
  musicPlaylistVietnam.intro = {path = "\\Folder\\intro.mp3",length = 10} --Intro for your playlist
  musicPlaylistVietnam.playlist = {
    [1] = {path = "\\Folder\\Song1.mp3",length = 69,name = "Song 1" }, -- Put the rest of your song paths here
    [2] = {path = "\\Folder\\Song2.mp3",length = 70,name = "Song 2" },
    [3] = {path = "\\Folder\\Song3.mp3",length = 71,name = "Song 3" },
  }
   
env.info( "******** Growler Radio Music Library Loaded ********" )
