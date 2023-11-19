--------------------------------------------------
-- Growler Radio
-- By isotaan
-- Growler Radio Version: {VERSION}
--------------------------------------------------

GROWLER = {}
GROWLER.__index = GROWLER

GROWLER.FREQ = "232,137,41" -- A string that is the frequency (or frequencies) to be played at. Example: "232" or "232,30"
GROWLER.MODULATION = "AM,AM,FM" -- A string that provides the radio modulation(s). Can be used for multiple frequencies: Example: "AM" or "AM, FM"
GROWLER.VOLUME = "1.0" -- A string between 0.1 and 1 that determines the volume of the sound through SRS. Can be overridden by individual songs in your music playlist.
GROWLER.TRACKNUM = nil
GROWLER.MUSICLIST = nil
GROWLER.SHUFFLETABLE = nil --Shuffled table of songs
GROWLER.INTRO = nil
GROWLER.RADIOPLAYINGFLAG = false -- Checks if the radio is already playing
GROWLER.RADIOSTOPFLAG = false -- Determines whether the radio has been stopped
GROWLER.VERBOSE = false -- If on, will play track info
GROWLER.KILLSWITCH = false
GROWLER.ANNOUNCER = true -- If on, will run through the playlist.announcer track list
GROWLER.ANNOUNCERNUM = 2 -- Determines the number of songs between each announcer message.
GROWLER.FIRSTPLAY = false -- Determines if Growler Radio has played it first song yet. Used for queuing the first song.
GROWLER.MUSICROOT = "D:\\STE_Files\\Music" --Root of your music files.
