-- /////////////////////////////////////////////////////////////////////////////
-- // Purpose:     Date class
-- // Author:      Hernan Cano [jhernancanom@gmail.com]
-- // Created:     2016-03-21
-- // Copyright:   (c) 2016 Hernan Cano
-- // License:     MIT/X11
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
---
--- >> Class constructor:
---
---   object Date:new ( string sDateCons ) 
---
---   Arguments:
---
---      sDateCons        This string is used as reference to create the object.
---
---
--- >> Class methods:
---
---      number    setDay()            Sets the day on this date
---      number    getDay()            Gets the day of this date
---      number    getMonth()          Gets the month of this date
---      number    getYear()           Gets the year of this date
---      number    getLastMonthDay()   Gets the last day of the month in this date
---      number    getFirstMonthDay()  Gets the first day of the month in this date
---      string    toString()          Convert Date to string
---

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

local Date = class 'Date'

local function ftzero (num)
   local sCode = "00" .. tonumber( num )
   sCode = sCode:sub(#sCode -1, #sCode )
   return sCode
end

function Date:Date( fields )
  fields = fields or DATE_TODAY
  
   if ( fields == DATE_TODAY ) then
      local t = os.date '*t'
      self.Year  = t.year
        self.Month = ftzero(t.month)
        self.Day   = ftzero(t.day  )
  end
  
  if type(fields) == 'table' then
    self.Year  = fields.Year
      self.Month = fields.Month
      self.Day   = fields.Day
   end

    if type(fields) == 'string' then
        local fields = fields:delim '-'
        self.Year  = fields[1]
        self.Month = fields[2]
        self.Day   = fields[3]
    end
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

function Date:setDay ( nDay )
   lide.core.base.isnumber(nDay)
   self.Day = nDay
   return self.Day == nDay
end

-- by default reutnrs a number

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
   --- Si la fecha es febrero y es año biciesto :)
   if ( self:getYear() % 4 == 0 ) and (self:getMonth() == 2) then
      return 29
   else
      return number_of_days[ months[self:getMonth()] ] 
   end
end

return Date

-- --birthday = Date { Year = '1996', Month = '02', Day = '29' }
-- today    = Date ( DATE_TODAY )


-- --print(  'birthday', birthday  )
-- print(  'today'   , today   )


--[[ Comento lo siguiente porque aun no esta implementado, al parecer necesita un modulo que no está presente para funcionar
     No obstante es interesante que podamos poner estas funciones mas adelante


-- Returns the year, month, and day values from a dateObject.
function Date:getDate()
   local  y, m, d = self.getdate()
   return y, m, d
end
-- Returns a string 1979-12-02 from a dateObject (ISO 8601, international)
function Date:getDateYMD() -- string
   return self.fmt('%Y-%m-%d')
end

-- Returns the hours, minutes, seconds and ticks values from a dateObject.
function Date:getTime()
   local  h, m, s, t = self.gettime()
   return h, m, s, t
end

-- Returns a string 11:59:59 AM (or PM) from a dateObject.
function Date:getTimeAMPM() -- string
   return self.fmt('%I:%M:%S %p')
end

-- Returns the year, month, day, hours, minutes, seconds and ticks values from a dateObject.
function Date:getDateTime()
   local  y, M, d    = self.getdate()
   local  h, m, s, t = self.gettime()
   return y, M, d, h, m, s, t
end
-- Returns a string 1979-12-02 from a dateObject (ISO 8601, international)
function Date:getDateYMD() -- string
   return self.fmt('%Y-%m-%dT%H:%M:%\f')
end

-- Returns the year value from a dateObject.
function Date:getYear()
   return self.getyear()
end

-- Returns the month (01..12) value from a dateObject.
function Date:getMonth()
   return self.getmonth()
end

-- Returns the day value (01..31) from a dateObject.
function Date:getDay()
   return self.getday()
end

-- Returns the hours value (00..23) from a dateObject.
function Date:getHours()
   return self.gethours()
end

-- Returns the minutes value (00..59) from a dateObject.
function Date:getMinutes()
   return self.getminutes()
end

-- Returns the seconds value (00..59) from a dateObject.
function Date:getSeconds()
   return self.getseconds()
end

-- Returns the ticks value from a dateObject.
function Date:getTicks()
   return self.getticks()
end

-- Returns the name of the month from a dateObject; string.
function Date:getcMonth()  -- string (c is character)
   return self.fmt('%B') -- '%b'
end

-- Changes the year value in dateObject to the value tNum
function Date::setYear(tNum)
   return self.:setyear(tNum)
end

-- Changes the month value (01..12) in dateObject to the value tNum
function Date::setMonth(tNum)
   return self.:setmonth(tNum)
end

-- Changes the day value (01..31) in dateObject to the value tNum
function Date::setDay(tNum)
   return self.:setday(tNum)
end


-- Changes the hour value (00..23) in dateObject to the value tNum
function Date::setHour(tNum)
   return self.:sethour(tNum)
end

-- Changes the minute value (00..59) in dateObject to the value tNum
function Date::setMinute(tNum)
   return self.:setminute(tNum)
end

-- Changes the seconds value (00..59) in dateObject to the value tNum
function Date::setSeconds(tNum)
   return self.:setseconds(tNum)
end

-- Changes the ticks value in dateObject to the value tNum
function Date::setTicks(tNum)
   return self.:setticks(tNum)
end


-- Returns the number day of the week from a dateObject (sunday=1, monday=2, ...saturday=7)
function Date:getDayOfWeek()  -- number
   return self.getweekday()
end
function Date:getDOW()  -- number
   return self.getweekday()
end
-- Returns the string full weekday name from a dateObject (sunday, monday, ...saturday)
function Date:getcDOW()  -- string (c is character)
   return self.fmt('%A') -- '%a'
end
function Date:getDayOfWeekString()  -- string
   return self.fmt('%A') -- '%a'
end

-- Returns the week (of the year) number value (01..53) in a dateObject.
function Date:getWeekOfYear()
   return self.getweeknumber()
end

-- Returns the day of year (1-366) in a dateObject.
function Date:getDayOfYear()
   return self.getyearday()  -- number 1..366
   -- return self.fmt('%j')  -- string 001..366
end

-- Add years in dateObject (If the value tNum is negative, the returned dateObject will be earlier)
function Date:addYears(tNum)
   return self.addyears(tNum)
end

-- Add months in dateObject (If the value tNum is negative, the returned dateObject will be earlier)
function Date:addMonths(tNum)
   return self.addmonths(tNum)
end
function Date:goMonth(tNum)
   return self.addmonths(tNum)
end

-- Add days in dateObject (If the value tNum is negative, the returned dateObject will be earlier)
function Date:addDays(tNum)
   return self.adddays(tNum)
end

-- Add hours in dateObject (If the value tNum is negative, the returned dateObject will be earlier)
function Date:addHours(tNum)
   return self.addhours(tNum)
end

-- Add minutes in dateObject (If the value tNum is negative, the returned dateObject will be earlier)
function Date:addMinutes(tNum)
   return self.addminutes(tNum)
end

-- Add seconds in dateObject (If the value tNum is negative, the returned dateObject will be earlier)
function Date:addSeconds(tNum)
   return self.addseconds(tNum)
end

-- Add ticks in dateObject (If the value tNum is negative, the returned dateObject will be earlier)
function Date:addTicks(tNum)
   return self.addticks(tNum)
end

-- Check if the year of dateObject is a leapyear.
-- Returns true if the year of dateObject is a leapyear; false otherwise.
function Date:isLeapYear() -------------------- función de DATE y metamétodo
   return date.isleapyear(self)
end


-- Returns how many days the dateObject has.
function Date:spanDays()
   return self.spandays()
end

-- Returns how many hours the dateObject has.
function Date:spanHours()
   return self.spanhours()
end

-- Returns how many minutes the dateObject has.
function Date:spanMinutes()
   return self.spanminutes()
end

-- Returns how many seconds the dateObject has.
function Date:spanSeconds()
   return self.spanseconds()
end


-- Returns a formatted version of dateObject (see full help of date.lua.chm)
function Date:format(tFmt)  -- string
   return self.fmt(tFmt)
end

function Date:fmt(tFmt)  -- string
   return self.fmt(tFmt)
end


-- Subtract the date and time value of two dateObject and returns the resulting dateObject
-- function Date:diff -------------------- función de DATE ???????????
-- a = date(2181, "aPr", 4, 6, 30, 30, 15000)
-- b = date(a):adddays(2)
-- c = b - a
-- assert(c:spandays() == (2))

-- get the days between two dates
-- d = date.diff("Jan 7 1563", date(1563, 1, 2))
-- assert(d:spandays()==5)

]]

