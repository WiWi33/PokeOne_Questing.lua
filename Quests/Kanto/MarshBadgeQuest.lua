-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Marsh Badge'
local description = 'Get Badge + Dojo Pokemon'
local level = 45

local dialogs = {
  dojoSaffronDone = Dialog:new({
    "If you put water in a cup, it becomes the cup. Be water, my friend, be water!"
  }),
  dojoState = Dialog:new({
    "tomodachi"
  }),
}

local MarshBadgeQuest = Quest:new()

function MarshBadgeQuest:new()
  local o = Quest.new(MarshBadgeQuest, name, description, level, dialogs)
  o.dojoState = false
  o.status = false
  return o
end

function MarshBadgeQuest:isDoable()
  if self:hasMap() then
    return true
  end
  return false
end

function MarshBadgeQuest:isDone()
  if (self.status == true and getAreaName() == "Route 8") or getAreaName() == "Silph Co 1F" or getAreaName() == "Route 5" then
    return true
  else
    return false
  end
end


function MarshBadgeQuest:Route8()
  if not isPokemonUsable(1) then 
    return moveToCell(11,123)
   elseif not self:needPokecenter() and (  not self:isTrainingOver() or  getPokemonLevel(1) < level  ) then
    return moveToGrass()
  else
    return moveToCell(11,123)
  end
end


function MarshBadgeQuest:SaffronCityGate()
 
 if game.inRectangle(78,58,94,69) then 
  if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
  else
     if  ( hasItem("Marsh Badge") or not self:isTrainingOver()  or getPokemonLevel(1) < level ) and countBadges() != 5 and isPokemonUsable(1) then
       return moveToCell(92,63)
	  elseif countBadges() == 5 then 
	    self.status = true
	    return moveToCell(92,63)
     else
        return moveToCell(79,63)
      end
  end
  else 
  --  if hasItem("Tea") then 
    return moveToCell(16,26)
 end 

end 



function MarshBadgeQuest:SaffronCity()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
  if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Saffron Pokémon Center" then
    return moveToCell(45,73)
   elseif self:needPokemart() then
		return moveToCell(68,42) -- pokemar
  elseif not self:isTrainingOver() or getPokemonLevel(1) < level then
    return moveToCell(95,64)
  elseif not hasItem("Master Ball") and isNpcOnCell(60,57) then --Rocket on SaffronGym Entrance
    pushDialogAnswer(2)
    return moveToCell(58,56)
  elseif not dialogs.dojoSaffronDone.state and not self.dojoState and  countBadges() < 5 then --Need Check dojo
    return moveToCell(69,23) -- Fixed no LINK name
  elseif countBadges() < 5 then -- Need beat Gym
    return moveToCell(83,24)
  elseif countBadges() == 5 then
  self.status = true
   return moveToCell(95,64)
  else
    return moveToCell(95,64)
  end
end
end 

function MarshBadgeQuest:SaffronPokémonCenter()
  return self:pokecentercell(15,135)
end


function MarshBadgeQuest:SaffronPokémonMart()
	self:pokemart(57,44)--//60,54)
end

function MarshBadgeQuest:SilphCo()
  if not hasItem("Master Ball") then
     if game.inRectangle(13,2,47,25) then
	    moveToCell(44,4)
	 end 
	
  else
    if game.inRectangle(13,2,47,25) then
     return moveToCell(23,24)
	end 
    
  end
end

function MarshBadgeQuest:SilphCo2F()
  if not hasItem("Master Ball") then
    
   
	    moveToCell(48,51)
  else
     return moveToCell(41,51)
    
  end
end

function MarshBadgeQuest:SilphCo3F()
  if not hasItem("Master Ball") then
    
     if not hasItem("Card Key III") then
	    moveToCell(45,99)
	 elseif isNpcOnCell(35,115) then 
	    talkToNpcOnCell(35,115)
	 else 
	    moveToCell(27,117)
	 end 
  else
     return moveToCell(40,100)
    
  end
end


function MarshBadgeQuest:SilphCo4F()
  if not hasItem("Master Ball") then
     if not hasItem("Card Key III") then
	    moveToCell(45,153)
	else 
	 return moveToCell(41,153)
	 end 
  else
     return moveToCell(41,153)
  end
end

function MarshBadgeQuest:SilphCo5F()
  if not hasItem("Master Ball") then
     if not hasItem("Card Key III") then
	    talkToNpcOnCell(15,217)
	 else 
	    moveToCell(41,204)
	 end 
  else
     return moveToCell(41,124)
  end
end

function MarshBadgeQuest:SilphCo7F()
  if not hasItem("Master Ball") then
     if not hasItem("Card Key III") then
	   moveToCell(18,306)
	 elseif isNpcOnCell(15,308) then
	 talkToNpcOnCell(15,308)
	 else 
	    moveToCell(18,311)
	 end 
  else
     return moveToCell(18,306)
  end
end

function MarshBadgeQuest:SilphCo11F()
  if not hasItem("Master Ball") then
     if not hasItem("Card Key III") then
	   moveToCell(15,494)
	 elseif isNpcOnCell(20,502) then
	 talkToNpcOnCell(20,502)
	 else
	 talkToNpcOnCell(23,499)
	 end 
  else
     return moveToCell(15,494)
  end
end

function MarshBadgeQuest:SaffronFightingDojo()
  if isNpcOnCell(103, 5) and isNpcOnCell(105,5) then
    if dialogs.dojoSaffronDone.state then
        if DOJO_POKEMON_ID == 1 then -- Hitmonchan
          return talkToNpcOnCell(103, 5)
        else -- Hitmonlee
          return talkToNpcOnCell(105,5)
        end
    else
      return talkToNpcOnCell(104,7)
    end
  else
    self.dojoState = true
    return moveToNearestLink()
  end
end


function MarshBadgeQuest:SaffronGym()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
  if countBadges() < 5 then
    if game.inRectangle(145,16,154,24) then
      return moveToCell(152,18)
    elseif game.inRectangle(154,16,163,24) then
      return moveToCell(156,21)
    elseif game.inRectangle(136,16,145,24) then
      return moveToCell(138,18)
    elseif game.inRectangle(154,2,163,9) then
      return moveToCell(156,4)
    elseif game.inRectangle(154,9,163,16) then
      return moveToCell(156,14)
	elseif game.inRectangle(145,2,154,9) then
      return moveToCell(152,4)
	elseif game.inRectangle(136,2,145,9) then
      return moveToCell(138,7)
    elseif game.inRectangle(145,9,154,16) then
      return moveToCell(147,13)
	elseif game.inRectangle(149,50,157,58) then
        return talkToNpcOnCell(153,51)
    else
      error("MarshBadgeQuest:SaffronGym(): [" .. getPlayerX() .. "," .. getPlayerY() .. "] is not a known position")
    end
  else
    if game.inRectangle(149,50,157,58) then
        return moveToCell(155,56)
    elseif game.inRectangle(145,16,154,24) then
      return moveToCell(149,24)
    else
      error("MarshBadgeQuest:SaffronGym(): [" .. getPlayerX() .. "," .. getPlayerY() .. "] is not a known position")
    end
  end
end 
end

return MarshBadgeQuest
