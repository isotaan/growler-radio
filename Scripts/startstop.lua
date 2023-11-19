
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