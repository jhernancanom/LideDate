-- ///////////////////////////////////////////////////////////////////
-- // Name:      C:\lide_h\shell\libraries\lide\classes\date.lua
-- ///////////////////////////////////////////////////////////////////
-- // Name:      lide/classes/date.lua
-- // Purpose:   Date class
-- // Created:   2017-05-01
-- //            2018-07-17 added getweekDay by Hernan Cano [jhernancanom [at] gmail.com]
-- // Copyright: (c) 2017-2018 Hernan Dario Cano [dcanohdev [at] gmail.com]
-- // License:   GNU GENERAL PUBLIC LICENSE
-- ///////////////////////////////////////////////////////////////////

local DATE_TODAY     = 0
local DATE_YESTERDAY = 1

local number_of_days = { 
    jan = 31, feb = 28, mar = 31, apr = 30,
    may = 31, jun = 30, jul = 31, aug = 31,
    sep = 30, oct = 31, nov = 30, dec = 31,
}

local months = {
    'jan', 'feb', 'mar', 'apr', 
    'may', 'jun', 'jul', 'aug',
    'sep', 'oct', 'nov', 'dec',
}

lide = require 'lide.core.init'

local isNumber = lide.core.base.isnumber

local Date = class 'Date'

local function ftzero (num)
   local sCode = "00" .. tonumber( num )
   sCode = sCode:sub(#sCode -1, #sCode )
   return sCode
end

function Substr(pCad,p1,p2)
   return string.sub (pCad, p1, p1+p2)
end

function Left(pCad,pNum)
   return string.sub (pCad, 1, pNum)
end

function Right(pCad,pNum)
   return string.sub (pCad, -pNum)
end

function Date:Date( ... )

   if type(...) == 'number' and not ( ... == DATE_TODAY ) then
      -- 
      local t = os.date '*t'
      t.year, t.month, t.day  = ...	  
	  if tonumber(t.year)<1970 then
	     error ( "\n\n-- fecha inválida -- "..tostring(t.year).."-"..tostring(t.month).."-"..tostring(t.day).."\n" )
 	  end
      -- 
         -- 
	     t = os.date("*t", os.time(t))  -- Nomalization -- PiL4 - Chapter 12. Date and Time (pag 95)
         -- 
         self.Year  =        t.year
         self.Month = ftzero(t.month)
         self.Day   = ftzero(t.day  )
         self.wDay  =       (t.wday ) -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
         -- 
   else

      fields = ... or DATE_TODAY
      
      if ( fields == DATE_TODAY ) then
         local t = os.date '*t'
         self.Year  =        t.year
         self.Month = ftzero(t.month)
         self.Day   = ftzero(t.day  )
         self.wDay  =       (t.wday ) -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
      end
   end
  
   if type(fields) == 'table' then
      -- 
	  if tonumber(fields.Year)<1970 then
	     error ( '\n\n-- fecha inválida -- '..tostring(fields.Year)..'-'..tostring(fields.Month)..'-'..tostring(fields.Day)..'\n' )
      else
	     -- 
         local t = os.date '*t'
         t.year  = fields.Year
         t.month = fields.Month
         t.day   = fields.Day  
         -- 
	     t = os.date("*t", os.time(t))  -- Nomalization -- PiL4 - Chapter 12. Date and Time (pag 95)
         -- 
         self.Year  =        t.year
         self.Month = ftzero(t.month)
         self.Day   = ftzero(t.day  )
         self.wDay  =       (t.wday ) -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
         -- 
	  end
      -- 
   end

   if type(fields) == 'string' then
      local fchar

          if fields:find '/' then 
         fchar = '/'

      elseif fields:find '-' then
         fchar = '-'
		 
      elseif fields:find '.' then  -- added HCano
         fchar = '.'
      end

      if fchar then
	  
	     -- -- before
         -- local fields = fields:delim (fchar)
         -- self.Year  = fields[1]  -- yyyy/mm/dd
         -- self.Month = fields[2]
         -- self.Day   = fields[3]
	     -- -- 
	  
         -- 
         -- now...
         -- 
         local fields = fields:delim (fchar)
         local t = os.date '*t'
         t.year  = fields[1]  -- yyyy/mm/dd
         t.month = fields[2]
         t.day   = fields[3]
         -- 
	     t = os.date("*t", os.time(t))  -- Nomalization -- PiL4 - Chapter 12. Date and Time (pag 95)
         -- 
         self.Year  =        t.year
         self.Month = ftzero(t.month)
         self.Day   = ftzero(t.day  )
         self.wDay  =       (t.wday ) -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
         -- 
	  
      end
   end

   -- another constructor
   -- function Date:Date( ... )
   --if type(fields) == 'number' then -- cannot use ... outside a vararg
    --  self.Year, self.Month, self.Day  = ...
 --  end
       
end 

function Date:__tostring( ... )
   return ('%s-%s-%s'):format(self.Year, self:getMonth 'string', self:getDay 'string')
end

function Date:toString ( ... )  
   return self.__tostring( ... ) 
end

function Date:getYear ( ... )
   return tonumber(self.Year)
end

function Date:getDay ( what )
    if what == 'string' then
        if tonumber(self.Day) < 10 then
           return tostring ('0' .. tonumber(self.Day) )
        else
           return tostring (self.Day)
        end
    end
    return tonumber(self.Day)
end

-- 2018-07-15 HCano added getweekDay -- tried !!!
function Date:getweekDay ( ... )
    if self.wDay then
      return tonumber(self.wDay)
    end
    if self.wday then
      return tonumber(self.wday)
    end
    return 0
end

-- 2018-07-15 HCano added setweekDay -- without proof yet...
function Date:setweekDay ( nDay )
   isNumber(nDay)
   self.wDay = nDay
   return self.wDay == nDay
end

function Date:setDay ( nDay )
   isNumber(nDay)
   self.Day = nDay
   return self.Day == nDay
end

function Date:setMonth ( nMonth )
   self.Month = isNumber(nMonth)
   return self.Month == nMonth
end

function Date:setYear ( nYear )
   self.Year = isNumber(nYear)
   return self.Year == nYear
end

-- by default returns a number

function Date:getMonth ( ... )
    local fields  = (...) or 'number'
    
    -- fields debe ser un string...    
    if (fields == '%s') or (fields:lower() == 'name') then
        return months[tonumber(self.Month)]
    elseif (fields == '%d') or (fields:lower() == 'number') then
        return tonumber(self.Month)
    elseif fields == 'string' then
        if tonumber(self.Month) < 10 then
            return tostring('0' .. tonumber(self.Month))
        else
            return tostring(self.Month)
        end
    end
end

function Date:getFirstMonthDay()
   return 1
end

function Date:getLastMonthDay()
   --- Si la fecha es febrero y es año bisiesto :)
   if ( self:getYear() % 4 == 0 ) and (self:getMonth() == 2) then
      return 29
   else
      return number_of_days[ months[self:getMonth()] ] 
   end
end

return Date

-- usage: 
--
-- birthday = Date { Year = '1996', Month = '02', Day = '29' }
