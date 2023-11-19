
function GROWLER.MESSAGE_STOP()
    trigger.action.outText("Growler Radio has stopped.",10, false)
  

end  

function GROWLER.INTROMESSAGE()

  --Edit this for your particular message.
  trigger.action.outText(string.format("Growler Radio has started playing \n\nFrequency \n232.00 AM\n137.00 AM\n41.00 FM", #GROWLER.SHUFFLETABLE), 10 , false)
  env.info(string.format("GROWLER RADIO | Growler Radio has started playing | Frequency | 232.00 AM, 137.00 AM, 41.00 FM"), 10 , false)
end
