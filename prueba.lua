-- ///////////////////////////////////////////////////////////////////
-- // Name:      \lidesdk\shell\sample_lidedate.lua
-- // Purpose:   test for Date class in Lide
-- // Created:   2018-07-17 adjusted by Hernan Cano [jhernancanom [at] gmail.com] from a Tieske idea
-- // Copyright: (c) 2017-2018 Hernan Dario Cano [dcanohdev [at] gmail.com]
-- // License:   GNU GENERAL PUBLIC LICENSE
-- ///////////////////////////////////////////////////////////////////

-- 
-- Scenario
-- 
-- C:\lidesdk\shell\lide.bat
-- C:\lidesdk\shell\sample_lidedate.lua
-- C:\lidesdk\shell\libraries\lide\classes\date.lua

-- 
-- sintaxis
-- 
-- lide sample_lidedate.lua
-- 


local lide = require "lide.widgets.init"  -- base   -- lidedate
local date = lide.classes.date


-- -- constructor numerico

t = date ( 1996, 2, 29 )
print ( 'numerico   ', t.Year, t.Month, t.Day, t.wDay )


-- -- constructor tabla con elementos numericos

t = date { Year = 1996, Month = 2, Day = 29 }
print ( 'original   ', t.Year, t.Month, t.Day, t.wDay )

-- -- constructor tabla con elementos string

t = date { Year = "1996", Month = "2", Day = "29" }
print ( 'original-str', t.Year, t.Month, t.Day, t.wDay )


-- -- funciones set..()

t:setDay  ( t.Day-1 )
print ( 'less 1 day ', t.Year, t.Month, t.Day, t.wDay )

t:setYear ( 1997 )
print ( 'year 1997  ', t.Year, t.Month, t.Day, t.wDay )

t:setMonth( t.Month+1 )
-- t:setDay  ( t.Day+1 )
print ( 'more 1 month', t.Year, t.Month, t.Day, t.wDay )



-- prints all FRIDAY the 13th dates between year 2000 and 2010

for i = 2000, 2010 do
   
   -- year jan 1
   -- x = date(i, 1, 1)
   x = date{Year=i, Month=1, Day=1}
   
   -- from january to december
   for j = 1, 12 do
   
      -- set date to 13, check if friday
      -- x = date{Year=i, Month=j, Day=13}
	  
	  x:setMonth(j)
	  x:setDay(13)
      if x:getweekDay() == 6 then
         -- if x:getweekDay() == 6 then
         -- print(x:fmt("%A, %B %d %Y"))
         print(x,x:getweekDay("name"))
      end
  end
end

--
 
--- OUTPUT ---
--> Friday, October 13 2000
--> Friday, April 13 2001
--> Friday, July 13 2001
--> Friday, September 13 2002
--> Friday, December 13 2002
--> Friday, June 13 2003
--> Friday, February 13 2004
--> Friday, August 13 2004
--> Friday, May 13 2005
--> Friday, January 13 2006
--> Friday, October 13 2006
--> Friday, April 13 2007
--> Friday, July 13 2007
--> Friday, June 13 2008
--> Friday, February 13 2009
--> Friday, March 13 2009
--> Friday, November 13 2009
--> Friday, August 13 2010

--