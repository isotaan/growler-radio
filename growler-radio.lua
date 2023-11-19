--------------------------------------------------
-- Growler Radio
-- By isotaan
-- Growler Radio Version: dev-2023-11-19T13:48:41Z
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

function GROWLER.RADIOINIT(args)
--Initializes the radio player.
--Args is a table of the playlist from a MusicLibrary
  
  -- Checks if sanitization has occured, proceeds with the initialization.
  if lfs and io  then

    --Checks if Growler Radio is currently playing
    if (GROWLER.RADIOPLAYINGFLAG == false) then
        
      --Checks if a playlist has been provided.
      if (args.playlist == nil) then
        env.info("GROWLER RADIO | No playlist has been specified. Please consult the Growler Radio documentation.")
      else
        if (GROWLER.ANNOUNCER == true and args.announcerlist == nil) then 
          GROWLER.ANNOUNCER = false
          env.info("GROWLER RADIO | Announcer has been set to true but no announcer list has been provided. Running standard playback without an announcer. Please review the Growler Radio documentation.")
        end
        
          
        GROWLER.MUSICLIST = args.playlist
        GROWLER.KILLSWITCH = false
        GROWLER.RADIOPLAYINGFLAG = true
        GROWLER.RADIOSTOPFLAG = false
        GROWLER.TRACKNUM = 1
        GROWLER.FIRSTPLAY = true

        --Checks if there is an announcer playlist defined. If so, adds the announcer sound table to the randomized song table.
        if ((GROWLER.ANNOUNCER == true) and (args.announcerlist ~= nil)) then
          
          env.info("GROWLER RADIO | Performing shuffle + announcer shuffle  ")
          local tbl1 = GROWLER.SHUFFLE(GROWLER.MUSICLIST.playlist)
          GROWLER.SHUFFLETABLE = GROWLER.INSERTANNOUNCER(tbl1, args.announcerlist)
          
        else
          
          env.info("GROWLER RADIO | Performing standard (no announcer) shuffle")            
          GROWLER.SHUFFLETABLE = GROWLER.SHUFFLE(GROWLER.MUSICLIST.playlist)
          
        end
        
        GROWLER.INTROMESSAGE()
        GROWLER.SCHEDULENEXT()

      end
    else
      trigger.action.outText("GROWLER RADIO | Growler Radio is already playing!" , 10 , false)
      env.info("GROWLER RADIO | Growler Radio is already playing!")
    end
  else
    env.info("GROWLER RADIO | DCS MissionScripting.lua has not been sanitized. Growler Radio is unable to play.")
  end
end

function GROWLER.GROWLERSTOP()
-- Stops playing after the current song

    GROWLER.RADIOSTOPFLAG = true
    
    GROWLER.GROWLERKILLAUDIO()
    
    trigger.action.outText("GROWLER RADIO | Growler Radio Has stopped", 10 , false)
    
    GROWLER.RADIOPLAYINGFLAG = false
    
    env.info("GROWLER RADIO | Growler Radio Has Stopped")
    
end

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

function GROWLER.INSERTANNOUNCER(songtbl, announcertbl)
  --Take the randomized song table and inserts announcer elements randomly as if they're songs. Stops when it runs out of entries in songtbl.
  local tbl2 =  GROWLER.SHUFFLE(announcertbl)
  local counter = 1

  songtbl[0] = tbl2[0]

  for key, value in pairs (tbl2) do  
    if (songtbl[counter] ~= nil) then
      table.insert(songtbl, counter, value)
    else 
      env.info(string.format("GROWLER RADIO | Playlist is too short to accomodate the announcer playlist/announcer frequency settings. Dropping number %d", key))
    end
    
    counter = counter + GROWLER.ANNOUNCERNUM + 1
    end

  return songtbl

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

--Plays a song
function GROWLER.GROWLERRADIOPLAY()
  
  if (GROWLER.RADIOSTOPFLAG == false) then
    
    if (GROWLER.VERBOSE == true) then
      
      trigger.action.outText(string.format("GROWLER RADIO | Now Playing: \n\n%s \nTrack %d of %d \n\nTrack length: %d seconds",GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name,GROWLER.TRACKNUM, #GROWLER.SHUFFLETABLE, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].length), 10 , false)
    end
      
    env.info(string.format("GROWLER RADIO | Now Playing %s  |Track %d of %d | Track length: %d seconds",GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name,GROWLER.TRACKNUM, #GROWLER.SHUFFLETABLE, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].length), 10 , false)
    --env.info(string.format("Volume: %s", GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].vol))
    local filePath = GROWLER.MUSICROOT .. GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].path
    local vol = GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].vol
    
    if (vol == nil) then  
    
      --If no custom volume for a song is specified, uses the default GROWLER.VOLUME value.
      STTS.PlayMP3(filePath,GROWLER.FREQ,GROWLER.MODULATION,GROWLER.VOLUME,"Growler Radio",2)
    
    else
      
      --If a custom volume for a particular song is specified, uses that.
      STTS.PlayMP3(filePath,GROWLER.FREQ,GROWLER.MODULATION,vol,"Growler Radio",2)
    
    end
    
    GROWLER.TRACKNUM = GROWLER.TRACKNUM +1
    
    GROWLER.SCHEDULENEXT()
    
  else
    
    trigger.action.outText("GROWLER RADIO | Growler Radio Has Stopped", 10 , false)
    
    env.info("GROWLER RADIO | Growler Radio Has Stopped")
    
    GROWLER.RADIOPLAYINGFLAG = false
  end

end

-- Schedules the next song for playing.
function GROWLER.SCHEDULENEXT()
  
   
  if ( GROWLER.TRACKNUM <= #GROWLER.SHUFFLETABLE ) and (GROWLER.RADIOSTOPFLAG == false) then
    
    if (GROWLER.VERBOSE == true) then
      trigger.action.outText(string.format("GROWLER RADIO | Queueing Track %d | %s",GROWLER.TRACKNUM, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name), 10 , false)
    end
      env.info(string.format("GROWLER RADIO | Queueing Track %d | %s",GROWLER.TRACKNUM, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name), 10 , false)
    
    
    local delayTime = nil
    
    if (GROWLER.FIRSTPLAY == false) then
      delayTime = (timer.getTime() + GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM-1].length*1.05)
    else
      delayTime = timer.getTime() + 3
      GROWLER.FIRSTPLAY = false
    end    
    --createScheduler()
    timer.scheduleFunction(GROWLER.GROWLERRADIOPLAY, {}, delayTime)
  
  elseif (GROWLER.RADIOSTOPFLAG == true) then
   
    --local delayTime = timer.getTime() + GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM-1].length*1.05

    --create scheduler
    --timer.scheduleFunction(trigger.action.outText, {"Growler Radio has stopped."},delayTime)
    
    local delayTime = timer.getTime() + 1

    --create scheduler
    timer.scheduleFunction(GROWLER.MESSAGE_STOP(),delayTime)
    
  else  
    
    local delayTime = timer.getTime() + GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM-1].length*1.05

    --create scheduler
    timer.scheduleFunction(GROWLER.MESSAGE_STOP(), nil,delayTime)
    GROWLER.RADIOPLAYINGFLAG = false
    
  end
  
end

function GROWLER.GROWLERSKIP()
-- Skips the *NEXT* song on the playlist 

    if ( GROWLER.TRACKNUM < #GROWLER.SHUFFLETABLE ) and (GROWLER.RADIOPLAYINGFLAG == true) then 
      
      GROWLER.TRACKNUM = GROWLER.TRACKNUM +1
      
      --GROWLER.GROWLERKILLAUDIO()
      
      --GROWLER.CLEARRADIOSCHEDULES()
      
      --GROWLER.GROWLERRADIOPLAY()
      
      
      if (GROWLER.VERBOSE == true) then
        trigger.action.outText(string.format("GROWLER RADIO : Queueing Track %d | %s",GROWLER.TRACKNUM, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name), 10 , false)
      end
      
      env.info(string.format("GROWLER RADIO | Queueing Track %d | %s",GROWLER.TRACKNUM, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name), 10 , false)
    
    elseif (GROWLER.RADIOPLAYINGFLAG == true) then
      trigger.action.outText("GROWLER RADIO | Growler Radio is not currently playing", 10 , false)
    else
      trigger.action.outText("GROWLER RADIO | The next track is the last track. Use the STOP command instead.", 10 , false)
    end
end

function GROWLER.MESSAGE_STOP()
    trigger.action.outText("Growler Radio has stopped.",10, false)
  

end  

function GROWLER.INTROMESSAGE()

  --Edit this for your particular message.
  trigger.action.outText(string.format("Growler Radio has started playing \n\nFrequency \n232.00 AM\n137.00 AM\n41.00 FM", #GROWLER.SHUFFLETABLE), 10 , false)
  env.info(string.format("GROWLER RADIO | Growler Radio has started playing | Frequency | 232.00 AM, 137.00 AM, 41.00 FM"), 10 , false)
end

env.info( "GROWLER RADIO | Growler Radio dev-2023-11-19T13:48:41Z loaded" )


if (Debug == true) then
  trigger.action.outText("GROWLER RADIO | Growler Radio loaded" , 10 , false)
end
