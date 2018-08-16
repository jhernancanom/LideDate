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

-- import required libraries:
if not lide then require 'lide.core.init'; end

local isNumber = lide.core.base.isnumber

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

local weekdays = { 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat' }

local function date_normalize ( self )
   local tParm = self
   
   local t = { year=0, month=0, day=0, wday=0 } --os.date '*t'
   
   t.year  = self:getYear    'number'
   t.month = self:getMonth   'number'
   t.day   = self:getDay     'number'
   t.wday  = self:getweekDay 'number'  
     
   t = ( os.date("*t", os.time(t)) ) -- Normalization -- PiL4 - Chapter 12. Date and Time (pag 95)
   
   tParm.Year  = t.year  
   tParm.Month = t.month 
   tParm.Day   = t.day   
   tParm.wDay  = t.wday

   return ( tParm );
end

local function ftzero (num)
   local sCode = "00" .. tonumber( num )
   sCode = sCode:sub(#sCode -1, #sCode )
   return sCode
end

local function Substr(pCad,p1,p2)
   return string.sub (pCad, p1, p1+p2)
end

local function Left(pCad,pNum)
   return string.sub (pCad, 1, pNum)
end

local function Right(pCad,pNum)
   return string.sub (pCad, -pNum)
end

local Date = class 'Date'

function Date:Date( ... )

   local fields;

   if ( ... == DATE_TODAY ) then
      local t = os.date '*t'

      self.Year  =        t.year
      self.Month = ftzero(t.month)
      self.Day   = ftzero(t.day  )
      self.wDay  =       (t.wday ) -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
   end

   --- Numeric constructor:
   ---
   if type(...) == 'number' then
      -- 
      local t = os.date '*t'
      t.year, t.month, t.day  = ...	  
      
      isNumber(t.year); isNumber(t.month); isNumber(t.day);
      
      t = os.date("*t", os.time(t))  -- Normalization -- PiL4 - Chapter 12. Date and Time (pag 95)

      self.Year  =       (t.year )
      self.Month = ftzero(t.month)
      self.Day   = ftzero(t.day  )
      self.wDay  =       (t.wday )   -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
   end

   --- Table/Fields constructor:
   --- 
   if type(...) == 'table' then
	   fields = ... ;

      local t = os.date '*t'
      t.year, t.month, t.day = fields.Year, fields.Month, fields.Day  

	   t = os.date("*t", os.time(t))  -- Normalization -- PiL4 - Chapter 12. Date and Time (pag 95)
         -- 
      self.Year  =        t.year
      self.Month = ftzero(t.month)
      self.Day   = ftzero(t.day  )
      self.wDay  =       (t.wday ) -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
   end

   if type(...) == 'string' then   
      -- find separator:
      local fchar
      if fields:find '/' then     fchar = '/';
      elseif fields:find '-' then fchar = '-';
		elseif fields:find '.' then fchar = '.'; -- added HCano
      end

      if fchar then
         local fields = fields:delim (fchar)

         local t = os.date '*t'
         
         t.year, t.month, t.day = fields[1], fields[2], fields[3]  -- yyyy/mm/dd
         ---
	      t = os.date("*t", os.time(t))  -- Normalization -- PiL4 - Chapter 12. Date and Time (pag 95)
         -- 
         self.Year  =        t.year
         self.Month = ftzero(t.month)
         self.Day   = ftzero(t.day  )
         self.wDay  =       (t.wday ) -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
      end
	  
      -- 
      -- ------------- pendiente de probar
      -- 
	   -- what if not separator???  20180722  YYYMMDD
      -- 
      --[[ 
	   if tonumber(Substr(fields,1,4))<1970 then
	      error ( '\n\n-- fecha inválida -- '..tostring(fields.Year)..'-'..tostring(fields.Month)..'-'..tostring(fields.Day)..'\n' )
      else
         local t = os.date '*t'
         t.year  = Substr(fields,1,4)  -- YYYYMMDD (without separator)
         t.month = Substr(fields,5,2)  -- 12345678
         t.day   = Substr(fields,7,2)
         -- 
	     t = os.date("*t", os.time(t))  -- Nomalization -- PiL4 - Chapter 12. Date and Time (pag 95)
         -- 
         self.Year  =        t.year
         self.Month = ftzero(t.month)
         self.Day   = ftzero(t.day  )
         self.wDay  =       (t.wday ) -- in os.date the field wday exists....[1..7] according to PiL4 - Date and Time.
         -- 
      end]]
   end
   
   if tonumber(self.Year) < 1970 then
      error ( ("Invalid date '%s-%s-%s'"):format(self.Year, self.Month, self.Day) );
   end
end 

function Date:__tostring( ... )
    return ('%s-%s-%s'):format(self.Year, self:getMonth 'string', self:getDay 'string') 
end

function Date:toString ( ... )  
   return self.__tostring( ... ) 
end

function Date:getYear ( what )
    local what  = (what) or 'number'
    if what == 'string' then
       return tostring (self.Year)
    end
    return tonumber(self.Year)
end

-- by default returns a number
function Date:getMonth ( ... )
    	
    local fields  = (...) or 'number'
    
    -- fields debe ser un string...    
    if (fields == '%s') or (fields:lower() == 'name') then  --OK!!!
        return months[tonumber(self.Month)]  --OK!!!
    elseif (fields == '%d') or (fields:lower() == 'number') then
        return tonumber(self.Month)
    elseif fields == 'string' then  --OK!!!
        if tonumber(self.Month) < 10 then
            return tostring('0' .. tonumber(self.Month))
        else
            return tostring(self.Month)
        end
    end
	
end

function Date:getDay ( what )
    local what  = (what) or 'number'
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
function Date:getweekDay ( what )
    	
    local fields  = (what) or 'number'

    if (fields == '%s') or (fields:lower() == 'name') then  --OK!!!
        return weekdays[tonumber(self.wDay)]  --OK!!!
    elseif (fields == '%d') or (fields:lower() == 'number') then
        return tonumber(self.wDay)
    elseif fields == 'string' then  --OK!!!
        return tostring(self.wDay)
    end
end


function Date:setYear ( nYear )
   isNumber(nYear)
   if nYear<1970 then
      error ( '\n\n-- año inválido -- '..tostring(nYear)..'\n' )
   end
   self.Year = nYear
   self = date_normalize(self);
   return self.Year == nYear
end

function Date:setMonth ( nMonth )
   isNumber(nMonth);
   
   if tonumber(self.Year)<1970 then
      error ( '\n\n-- año inválido -- '..tostring(self.Year)..'\n' )
   end

   self.Month = nMonth
   self = date_normalize(self);
   
   return ( self.Month == nMonth )
end

function Date:setDay ( nDay )
   isNumber(nDay);

   if tonumber(self.Year)<1970 then
      error ( '\n\n-- año inválido -- '..tostring(self.Year)..'\n' )
   end

   self.Day = nDay
   self = date_normalize(self);

   return ( self.Day == nDay )
end

--- !DEPRECATED by jhernancanom: e2c695c
---
-- impractical (( more practical is SetDayOfYear))
-- -- 2018-07-15 HCano added setweekDay -- without proof yet... need normalize????
-- function Date:setweekDay ( nDay )
--    isNumber(nDay)
--    self.wDay = nDay
--    return self.wDay == nDay
-- end

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

-- Usage: 
--
-- birthday = Date { Year = '1996', Month = '02', Day = '29' }
-- birthday = Date { Year = 1996, Month = 02, Day = 29 }
-- birthday = Date (1996, 02, 29);