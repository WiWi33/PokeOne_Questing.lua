-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Rainbow Badge'
local description = 'Beat Erika + Get Silph Scope for future quest'
local level = 36

local dialogs = {
	martElevatorFloor1 = Dialog:new({ 
		"the first floor"
	}),
	martElevatorFloor5 = Dialog:new({ 
		"the fifth floor"
	}),
	martElevatorFloor3 = Dialog:new({ 
		"the third floor"
	}),
	martElevatorFloor2 = Dialog:new({ 
		"the second floor"
	}),
	grandma = Dialog:new({ 
		"Please find my friend, Mr. Fuji!"
	}),
	policegirl = Dialog:new({ 
		"Tea!",
		"Okay. Get us some tea!"
	}),
}

local RainbowBadgeQuest = Quest:new()

function RainbowBadgeQuest:new()
	local o = Quest.new(RainbowBadgeQuest, name, description, level, dialogs)
	o.pokemonId = 1
	return o
end

function RainbowBadgeQuest:isDoable()
	if self:hasMap() and not hasItem("Poké Flute")  then
		return true
	end
	return false
end

function RainbowBadgeQuest:isDone()
	if (hasItem("Silph Scope") and getAreaName() == "Lavender Town" ) then
		return true
	else
		return false
	end
end

function RainbowBadgeQuest:CeladonCity()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
    if self:needPokecenter() or not game.isTeamFullyHealed()  then
		return moveToCell(165,82)
	elseif not hasItem("Coin Case") then 
		return moveToCell(167,97)
	elseif   not game.hasPokemonWithMove("Cut") then
		if self.pokemonId <= getTeamSize() then					
			useItemOnPokemon("HM01 - Cut", self.pokemonId)
			log("Pokemon: " .. self.pokemonId .. " Try Learning: HM01 - Cut")
			self.pokemonId = self.pokemonId + 1
		else
			fatal("No pokemon in this team can learn - Cut")
		end 
	elseif not self:isTrainingOver() and countBadges() < 4 then 
     return  moveToCell(190,89)
   elseif   not hasItem("Silph Scope") then
   return moveToCell(147,95)

	elseif countBadges() < 4 then
	    if not game.hasPokemonWithMove("Cut") then
		if self.pokemonId <= getTeamSize() then					
			useItemOnPokemon("HM01 - Cut", self.pokemonId)
			log("Pokemon: " .. self.pokemonId .. " Try Learning: HM01 - Cut")
			self.pokemonId = self.pokemonId + 1
		else
			fatal("No pokemon in this team can learn - Cut")
		end 
        else 
		return moveToCell(122,122)
		end 
	elseif  countBadges() == 4  and dialogs.grandma.state == false  then -- Buy Lemonade for Future Quest (Saffron Guard)
		return moveToCell(144,82)
	elseif  countBadges() == 4  and dialogs.grandma.state == false  then -- Buy Lemonade for Future Quest (Saffron Guard)
		return moveToCell(144,82)
	else
		return moveToCell(193,93)
	end
end 
end

function RainbowBadgeQuest:CeladonCondominiums()
 if not dialogs.grandma.state then  
	return talkToNpcOnCell(11,13)
 else 
	    return moveToCell(21,26)
 end 

end

function RainbowBadgeQuest:CeladonRestaurant()
 if not hasItem("Coin Case") then  
	return talkToNpcOnCell(161,38)
 else 
	    return moveToCell(166,43)
 end 

end

function RainbowBadgeQuest:CeladonGameCorner()
if game.inRectangle(118,64,137,79) then 
 if not hasItem("Silph Scope") then  
    if isNpcOnCell(133,67) then 
	talkToNpcOnCell(133,67)
	else
	return moveToCell(135,67)
	end 
 else 
	    return moveToCell(128,78)
 end 
 end 

end

function RainbowBadgeQuest:RocketHideoutB1F()
if game.inRectangle(3,5,31,40) then 
 if not hasItem("Silph Scope") then  
    if isNpcOnCell(16,24) then 
	talkToNpcOnCell(16,24)
	elseif isNpcOnCell(8,23) then
	return talkToNpcOnCell(8,23)
	else
	   if not hasItem("Lift Key") then 
	   return moveToCell(20,7)
	   else 
	   return moveToCell(27,30)
	   end 
	end 
 else 
	    return moveToCell(12,7)
 end 
 elseif game.inRectangle(60,4,65,11) then 
	if not hasItem("Silph Scope") then
 		pushDialogAnswer("B4F")
		return talkToNpcOnCell(61,5)
	else
		return moveToCell(63, 10)
	end
 end 

end
function RainbowBadgeQuest:RocketHideoutB2F()
--if game.inRectangle(3,5,31,40) then 
 if not hasItem("Lift Key") then  
    if getPlayerX() > 31 and getPlayerY() <= 73 then 
	   moveToCell(31,74)
	elseif getPlayerX() >= 31 and getPlayerY() > 73 then 
	moveToCell(26,74)
    else 
	   moveToCell(27,67)
	   end 
 else 
	    return moveToCell(38,67)
 end 
-- end 

end
function RainbowBadgeQuest:RocketHideoutB3F()
--if game.inRectangle(3,5,31,40) then 
 if not hasItem("Lift Key") then  
    if isNpcOnCell(16,123)  then 
	   talkToNpcOnCell(16,123)
	   elseif isNpcOnCell(26,130)  then 
	   talkToNpcOnCell(26,130)
    else 
	   moveToCell(20,135)
	   end 
 else 
	    return moveToCell(21,113)
 end 
-- end 

end

function RainbowBadgeQuest:RocketHideoutB4F()
if game.inRectangle(3,172,18,191) then 
 if not hasItem("Lift Key") then  
      if isNpcOnCell(10,184)  then 
	   return talkToNpcOnCell(10,184)
	   elseif isNpcOnCell(8,175)  then 
	   return talkToNpcOnCell(8,175)
	   end 
 else 
	    return moveToCell(18,187)
 end 
 elseif game.inRectangle(60,173,65,180) then 
   if hasItem("Silph Scope") then
    pushDialogAnswer("B1F")
    talkToNpcOnCell(61,174)
	else 
	return moveToCell(62,179)
	end 
else 
   if isNpcOnCell(25,170) then 
     return talkToNpcOnCell(25,170)
   elseif hasItem("Silph Scope") then
     return moveToCell(27,196)
	else 
	 return talkToNpcOnCell(24,178)
	end 
 end 


end

function RainbowBadgeQuest:CeladonPokémonCenter()
 if not game.isTeamFullyHealed() then  
	self:pokecenter("Celadon City")
 else 

	    return moveToCell(12,84)
 end 
end

function RainbowBadgeQuest:Route7()
 if  not self:isTrainingOver() then 

			return moveToGrass()
else
 if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
 else 
  if countBadges() == 4  then 
     if  not  dialogs.policegirl.state then 
	 return moveToCell(225,90)
	 else 
     return moveToCell(191,106)
	 end 
  else 
		return moveToCell(170,87)
	
  end 
end 
end 
end

function RainbowBadgeQuest:SaffronCityGate()
  if  not  dialogs.policegirl.state then 
	 return talkToNpcOnCell(10,23)
	 else 
     return moveToCell(3,26)
	 
 end 

end

function RainbowBadgeQuest:CeladonGym()
	if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
    else 
	   if countBadges() < 4 then
	     if isNpcOnCell(45,46) then 
		 return talkToNpcOnCell(45,46)
		 
		 else 
	      return talkToNpcOnCell(45,11) --moveToCell(45,14)
		  
		  end 
	    else
		 return moveToCell(44,53)
	   end 
	end 
end


function RainbowBadgeQuest:UndergroundPath()
if game.inRectangle(105, 6,115, 14) then
	return moveToCell(111,13)
elseif game.inRectangle(32, 4,88, 14) then
  return moveToCell(87,9)
else
  return moveToCell(11,7)
end 
end

function RainbowBadgeQuest:Route8()
	return moveToCell(105,123)
end

return RainbowBadgeQuest