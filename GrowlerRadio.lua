--------------------------------------------------
-- Growler Radio
-- By isotaan
-- A music player for DCS World to be used via SRS
--------------------------------------------------

GROWLER = {}
GROWLER.__index = GROWLER

GROWLER.FREQ = "232,110,42.75" -- A string that is the frequency (or frequencies) to be played at. Example: "232" or "232,30"
GROWLER.MODULATION = "AM,AM,FM" -- A string that provides the radio modulation(s). Can be used for multiple frequencies: Example: "AM" or "AM, FM"
GROWLER.VOLUME = "0.4" -- A string between 0.1 and 1 that determines the volume of the sound through SRS
GROWLER.TRACKNUM = nil
GROWLER.MUSICLIST = nil
GROWLER.SHUFFLETABLE = nil
GROWLER.INTRO = nil
GROWLER.RADIOPLAYINGFLAG = false -- Checks if the radio is already playing
GROWLER.RADIOSTOPFLAG = false -- Determines whether the radio has been stopped
GROWLER.VERBOSE = false -- If on, will play track info
GROWLER.KILLSWITCH = false



function GROWLER.SHUFFLE(tbl)
-- Basic shuffle function that was unabashedly stolen from the internet. I did not make this, but it works.  
  local randPick1 = math.random(10000)
  local randPick2 = math.random(10000)
  local randPick3 = math.random(10000)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl  
end

function GROWLER.INTROMESSAGE()

  trigger.action.outText(string.format("Growler Radio has started playing \n\nFrequency \n232.00 AM\n110.00 AM\n42.75 FM\n\nNumber of tracks: %d", #GROWLER.SHUFFLETABLE), 10 , false)

end

function GROWLER.SPLIT(inputString)
    parsed = {}
    result = ""
    for match in (s..","):gmatch("(.-)"..",") do
        table.insert(parsed, match)
    end
    
    result = nil
    
    
    return result
end





-- Function that Starts Growler Radio
-- Arguments:
-- musicArray - 2D Table with at least two elements, the first is the file path of the mp3 or ogg file to be played. The second element is the length (in seconds) of that file.
-- intro - 1D table with the file path and length of the intended intro

function GROWLER.RADIOINIT(args)
--Initializes the radio player.
--Args is a table of the playlist from a MusicLibrary
  if (GROWLER.RADIOPLAYINGFLAG == false) then
        
    if (args == nil) then
        GROWLER.MUSICLIST = musicPlaylistVietnam
      else
        GROWLER.MUSICLIST = args
      end
      
    
    GROWLER.KILLSWITCH = false
    GROWLER.RADIOPLAYINGFLAG = true
    GROWLER.RADIOSTOPFLAG = false
    GROWLER.TRACKNUM = 1
      
    GROWLER.SHUFFLETABLE = GROWLER.SHUFFLE(GROWLER.MUSICLIST.playlist)
    
    --Feel free to customize this with whatever you want when the radio starts.
 
    local filePath = GRLIB.root .. GROWLER.MUSICLIST.intro.path
 
    STTS.PlayMP3(filePath,GROWLER.FREQ,GROWLER.MODULATION,GROWLER.VOLUME,"Growler Radio",2)
    
    local playScheduler = SCHEDULER:New( nil, 
      function()
        GROWLER.GROWLERRADIOPLAY()
      end, {}, musicPlaylistVietnam.intro.length
    )
        
  else
    trigger.action.outText("Growler Radio is already playing!" , 10 , false)
  end

end

-- Schedules the next song for playing.
function GROWLER.SCHEDULENEXT()
  
   
  if ( GROWLER.TRACKNUM <= #GROWLER.SHUFFLETABLE ) and (GROWLER.RADIOSTOPFLAG == false) then
    
    if (GROWLER.VERBOSE == true) then
      trigger.action.outText(string.format("Queueing Track %d \n%s",GROWLER.TRACKNUM, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name), 10 , false)
    end
    
    local playScheduler = SCHEDULER:New( nil, 
      function()
        GROWLER.GROWLERRADIOPLAY()
      end, {}, (GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM-1].length*1.05)
    )
    
    collectgarbage()
    
  elseif (GROWLER.RADIOSTOPFLAG == true) then
    
    local playScheduler = SCHEDULER:New( nil, 
      function()
        trigger.action.outText("Growler Radio Has Stopped" , 10 , false)
        GROWLER.RADIOPLAYINGFLAG = false
        GROWLER.RADIOSTOPFLAG = false
      end, {}, (GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM-1].length*1.1)
    )
    
    collectgarbage()
    
  else  
    
    trigger.action.outText("Growler Radio Has Stopped", 10 , false)
    GROWLER.RADIOPLAYINGFLAG = false
    
  end
  
end


--Plays a song
function GROWLER.GROWLERRADIOPLAY()
  
  if (GROWLER.RADIOSTOPFLAG == false) then
    
    if (GROWLER.VERBOSE == true) then
      
      trigger.action.outText(string.format("Now Playing: \n\n%s \nTrack %d of %d \n\nTrack length: %d seconds",GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name,GROWLER.TRACKNUM, #GROWLER.SHUFFLETABLE, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].length), 10 , false)
      
    end
    
    local filePath = GRLIB.root .. GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].path
    
    STTS.PlayMP3(filePath,GROWLER.FREQ,GROWLER.MODULATION,GROWLER.VOLUME,"Growler Radio",2)
    
    GROWLER.TRACKNUM = GROWLER.TRACKNUM +1
    
    GROWLER.SCHEDULENEXT()
    
  else
    
    trigger.action.outText("Growler Radio Has Stopped", 10 , false)
    
    env.info("***GrowlerAudio*** Growler Radio Has Stopped")
    
    GROWLER.RADIOPLAYINGFLAG = false
  end

end


function GROWLER.GROWLERSTOP()
-- Stops playing after the current song

    GROWLER.RADIOSTOPFLAG = true
    
    GROWLER.GROWLERKILLAUDIO()
    
    trigger.action.outText("Growler Radio Has Stopped", 10 , false)
    
    GROWLER.RADIOPLAYINGFLAG = false
    
    env.info("***GrowlerAudio*** Growler Radio Has Stopped")
    
end


function GROWLER.GROWLERSKIP()
-- Skips the *NEXT* song on the playlist 

    if ( GROWLER.TRACKNUM < #GROWLER.SHUFFLETABLE ) and (GROWLER.RADIOPLAYINGFLAG == true) then 
      
      GROWLER.TRACKNUM = GROWLER.TRACKNUM +1
      
      GROWLER.GROWLERKILLAUDIO()
      
      GROWLER.CLEARRADIOSCHEDULES()
      
      GROWLER.GROWLERRADIOPLAY()
      
      
      trigger.action.outText(string.format("Skipping to the next song\n\nNew next song: \n%s \n\nTrack %d of %d",GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name,GROWLER.TRACKNUM, #GROWLER.SHUFFLETABLE), 10 , false)
    elseif (GROWLER.RADIOPLAYINGFLAG == true) then
      trigger.action.outText("Growler Radio Is Not Currently Playing", 10 , false)
    else
      trigger.action.outText("The next track is the last track. Use the STOP command instead.", 10 , false)
    end
end


function GROWLER.GROWLERKILLAUDIO()
  
  
    GROWLER.CLEARRADIOSCHEDULES()
    local cmd = "Taskkill /IM DCS-SR-ExternalAudio.exe /F"    
    
    env.info("***GrowlerAudio*** Task Sent To OS:\n" .. cmd.."\n")
    os.execute(cmd)
    
    GROWLER.KILLSWITCH = true
    
end

function GROWLER.CLEARRADIOSCHEDULES()
  
    SCHEDULER:Clear()   
    
    env.info("***GrowlerAudio*** All Schedules Cleared")        
end

env.info( "***GrowlerAudio*** Growler Radio Script File Loaded Successfully" )


if (Debug == true) then
  trigger.action.outText("********  Growler Radio Script File Loaded ********" , 10 , false)
end