
--Plays a song
function GROWLER.GROWLERRADIOPLAY()
  
  if (GROWLER.RADIOSTOPFLAG == false) then
    
    if (GROWLER.VERBOSE == true) then
      
      trigger.action.outText(string.format("GROWLER RADIO | Now Playing: \n\n%s \nTrack %d of %d \n\nTrack length: %d seconds",GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name,GROWLER.TRACKNUM, #GROWLER.SHUFFLETABLE, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].length), 10 , false)
    end
      
    env.info(string.format("GROWLER RADIO | Now Playing %s  |Track %d of %d | Track length: %d seconds",GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].name,GROWLER.TRACKNUM, #GROWLER.SHUFFLETABLE, GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM].length), 10 , false)

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
       
    local delayTime = timer.getTime() + 1

    --create scheduler
    timer.scheduleFunction(GROWLER.MESSAGE_STOP,delayTime)
    
  else  
    
    local delayTime = timer.getTime() + GROWLER.SHUFFLETABLE[GROWLER.TRACKNUM-1].length*1.05

    --create scheduler
    timer.scheduleFunction(GROWLER.MESSAGE_STOP, nil,delayTime)
    GROWLER.RADIOPLAYINGFLAG = false
    
  end
  
end

function GROWLER.GROWLERSKIP()
-- Skips the *NEXT* song on the playlist 

    if ( GROWLER.TRACKNUM < #GROWLER.SHUFFLETABLE ) and (GROWLER.RADIOPLAYINGFLAG == true) then 
      
      GROWLER.TRACKNUM = GROWLER.TRACKNUM +1
           
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