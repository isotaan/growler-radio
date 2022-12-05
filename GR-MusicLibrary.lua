--------------------------------------------------
-- Growler Radio Music Library
-- By isotaan
-- For use with Growler Radio, a DCS/SRS-based music player.
--------------------------------------------------

GRLIB = {}
GRLIB.__index = GRLIB
GRLIB.root = "D:\\STE_Files\\Music"

musicPlaylistVietnam = {}
  musicPlaylistVietnam.intro = {path = "\\Vietnam\\999_AFVN_01.mp3",length = 13}
  musicPlaylistVietnam.playlist = {
    [1] = {path = "\\Vietnam\\001_FWIW.mp3",length = 157,name = "Buffalo Springfield - For What It's Worth" },
    [2] = {path = "\\Vietnam\\002_FS.mp3",length = 142,name = "Creedence Clearwater Revival - Fortune Son"},
    [3] = {path = "\\Vietnam\\003_HYESTR.mp3",length = 161,name = "Creedence Clearwater Revival - Have You Ever Seen The Rain?" },
    [4] = {path = "\\Vietnam\\004_RTTJ.mp3",length = 186,name = "Creedence Clearwater Revival - Run Through The Jungle" },
    [5] = {path = "\\Vietnam\\005_SOAP.mp3",length = 146,name = "Dusty Springfield - Son Of A Preacher Man" },
    [6] = {path = "\\Vietnam\\006_ROTV.mp3",length = 344,name = "Richard Wagner - Ride of the Valkyries" },
    [7] = {path = "\\Vietnam\\007_HOIC.mp3",length = 153,name = "Sam & Dave - Hold On I'm Coming" },
    [8] = {path = "\\Vietnam\\008_MR.mp3",length = 243,name = "Simon & Garfunkle - Mrs. Robinson" },
    [9] = {path = "\\Vietnam\\009_MCR.mp3",length = 260,name = "Steppenwolf - Magic Carpet Ride" },
    [10] = {path = "\\Vietnam\\010_TOS.mp3",length = 147,name = "The Doors - Break On Through (To The Other Side)" },
    [11] = {path = "\\Vietnam\\011_GS.mp3",length = 270,name = "The Rolling Stones - Gimme Shelter"},
    [12] = {path = "\\Vietnam\\012_SFTD.mp3",length = 382,name = "The Rolling Stones - Sympathy For The Devil" },
    [13] = {path = "\\Vietnam\\013_HOTRS.mp3",length = 319,name = "Bob Dylan - House Of The Rising Sun" },
    [14] = {path = "\\Vietnam\\014_SHA.mp3",length = 285,name = "Lynard Skynard - Sweet Home Alabama" },
    [15] = {path = "\\Vietnam\\015_FB.mp3",length = 607,name = "Lynard Skynard - Free Bird" },
    [16] = {path = "\\Vietnam\\016_STTH.mp3",length = 483,name = "Led Zeppelin - Stairway To Heaven" },
    [17] = {path = "\\Vietnam\\017_AATW.mp3",length = 241,name = "Jimi Hendrix - All Along The Watchtower" },
    [18] = {path = "\\Vietnam\\018_BIGLY.mp3",length = 402,name = "Led Zeppelin - Babe I'm Gonna Leave You" },
    [19] = {path = "\\Vietnam\\019_SC.mp3",length = 203,name = "Neil Diamond - Sweet Caroline" },
    [20] = {path = "\\Vietnam\\020_LG.mp3",length = 228,name = "ZZ Top - La Grange" },
    [21] = {path = "\\Vietnam\\021_JBG.mp3",length = 162,name = "Chuck Berry - Johnny B Goode" },
    [22] = {path = "\\Vietnam\\022_WR.mp3",length = 296,name = "Cream - White Room" },
    [23] = {path = "\\Vietnam\\023_WR.mp3",length = 153,name = "Jefferson Airline - White Rabbit" },
    [24] = {path = "\\Vietnam\\024_J.mp3",length = 200,name = "Bob Marley - Jammin" },
    [25] = {path = "\\Vietnam\\025_A.mp3",length = 290,name = "Toto - Africa" },
  }
  
musicPlaylistFighter = {}
  musicPlaylistFighter.intro = {path = "\\Fighter\\999_RP.mp3",length = 12}
  musicPlaylistFighter.playlist = {
    [1] = {path = "\\Fighter\\001_DZ2.mp3",length = 212,name = "Kenny Loggins - Danger Zone" },
    [2] = {path = "\\Fighter\\002_DZ.mp3",length = 223,name = "Cherlene - Danger Zone (ft Kenny Loggins)"},
    [3] = {path = "\\Fighter\\003_W.mp3",length = 170,name = "Imagine Dragon - Warriors" },
    [4] = {path = "\\Fighter\\004_S.mp3",length = 274,name = "Disturbed - Stupify" },
    [5] = {path = "\\Fighter\\005_DWTS.mp3",length = 278,name = "Disturbed - Down With The Sickness" },
    [6] = {path = "\\Fighter\\006_AATW.mp3",length = 240,name = "Bear McCreary - All Along The Watchtower (Broadcast Version)" },
    [7] = {path = "\\Fighter\\007_S2.mp3",length = 120,name = "Blur - Song 2" },
    [8] = {path = "\\Fighter\\008_MW.mp3",length = 231,name = "Cheap Trick - Mighty Wings" },
    [9] = {path = "\\Fighter\\009_BPDG.mp3",length = 165,name = "Cherlene - Baby Please Don't Go" },
    [10] = {path = "\\Fighter\\010_A.mp3",length = 234,name = "Leo Moracchiola - Africa" },
    [11] = {path = "\\Fighter\\011_E.mp3",length = 270,name = "Imagine Dragons - Enemy"},
    [12] = {path = "\\Fighter\\012_P.mp3",length = 185,name = "Linkin Park - Papercut" },
    [13] = {path = "\\Fighter\\013_PWTB.mp3",length = 239,name = "Kenny Loggins - Playing With The Boys" },
    [14] = {path = "\\Fighter\\014_TTF.mp3",length = 225,name = "Larry Greene - Through The Fire" },
    [15] = {path = "\\Fighter\\015_NE.mp3",length = 203,name = "Linkin Park & JayZ - Numb (Encore)" },
    [16] = {path = "\\Fighter\\016_HSN.mp3",length = 219,name = "Miami Sound Machine - Hot Summer Nights" },
    [17] = {path = "\\Fighter\\017_POTU.mp3",length = 217,name = "Queen - Princes of the Universe" },
    [18] = {path = "\\Fighter\\018_WATC.mp3",length = 302,name = "Queen - We Will Rock You / We Are The Champions" },
    [19] = {path = "\\Fighter\\019_MIBD.mp3",length = 214,name = "Skillrex & Damian Marley - Make It Bun Dem" },
    [20] = {path = "\\Fighter\\020_LMO.mp3",length = 228,name = "Teena Marie - Lead Me On" },
    [21] = {path = "\\Fighter\\021_W.mp3",length = 175,name = "Wolfmother - Woman" },
    [22] = {path = "\\Fighter\\022_GJWHF.mp3",length = 234,name = "Cyndi Lauper - Girls Just Wanna Fun \n(Easy threatened me if I didn't add this song! - iso)" },
    [23] = {path = "\\Fighter\\023_I.mp3",length = 277,name = "Disturbed - Indestructable" },
    [24] = {path = "\\Fighter\\024_TN.mp3",length = 285,name = "Disturbed - The Night" },
    [25] = {path = "\\Fighter\\025_HD.mp3",length = 245,name = "Killswitch Engaged - Holy Diver" },
    [26] = {path = "\\Fighter\\026_ALPOH.mp3",length = 480,name = "Avenged Sevenfold - A Little Piece Of Heaven" },
  }
  
  
env.info( "******** Growler Radio Music Library Loaded ********" )