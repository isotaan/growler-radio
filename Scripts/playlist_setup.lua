
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