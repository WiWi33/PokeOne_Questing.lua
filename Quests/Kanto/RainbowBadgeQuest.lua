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
local description = 'Beat Erika + Get Lemonade for future quest'
local level = 3

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
	})
}

local RainbowBadgeQuest = Quest:new()

function RainbowBadgeQuest:new()
	local o = Quest.new(RainbowBadgeQuest, name, description, level, dialogs)
	o.pokemonId = 1
	return o
end

function RainbowBadgeQuest:isDoable()
	if self:hasMap() and not hasItem("Soul Badge")  then
		return true
	end
	return false
end

function RainbowBadgeQuest:isDone()
	if (hasItem("Rainbow Badge") and getAreaName() == "Lavender Town" )or  isNpcOnCell(48,34) then
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
   elseif   not hasItem("Silph Cope") then
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
	elseif isNpcOnCell(14,42) and  not isNpcOnCell(48,34) and hasItem("Rainbow Badge") then --NPC: Remove the Guards
		return talkToNpcOnCell(14,42)
	elseif not hasItem("Lemonade") or (not hasItem("TM28") and getMoney() > 3500 )   then -- Buy Lemonade for Future Quest (Saffron Guard)
		return moveToMap("Celadon Mart 1")
	else
		return moveToCell(193,93)
	end
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
 if not hasItem("Silph Cope") then  
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
 if not hasItem("Silph Cope") then  
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
 pushDialogAnswer("B4F")
    talkToNpcOnCell(61,5)
 end 

end
function RainbowBadgeQuest:RocketHideoutB2F()
--if game.inRectangle(3,5,31,40) then 
 if not hasItem("Lift Key") then  
    if getPlayerX() >= 31 and getPlayerY() <= 73 then 
	   moveToCell(28,74)
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
   if hasItem("Silph Cope") then
    pushDialogAnswer("B4F")
    talkToNpcOnCell(61,5)
	else 
	return moveToCell(62,179)
	end 
else 
   if isNpcOnCell(28,190) then 
   talkToNpcOnCell(28,190)
   elseif hasItem("Silph Cope") then
     return moveToCell(27,196)
	else 
	return moveToCell(24,184)
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
	if self:needPokecenter() or not game.isTeamFullyHealed()  then
		return moveToMap("Celadon City")
	elseif hasItem("Rainbow Badge") and hasItem("Lemonade") then
		return moveToMap("Underground House 3")
	elseif ( not self:isTrainingOver() and not hasItem("Rainbow Badge") )or (hasPokemonInTeam("Squirtle") and getPokemonLevel(1) < 60) then 
		if not game.inRectangle(12,8,21,21) then
			return moveToCell(17,17)
		else
			return moveToGrass()
		end
	else
		return moveToMap("Celadon City")
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

function RainbowBadgeQuest:CeladonMart1()
	if not hasItem("Lemonade") or not hasItem("TM28") then
		return moveToMap("Celadon Mart Elevator")
	else
		return moveToMap("Celadon City")
	end
end

function RainbowBadgeQuest:CeladonMartElevator()
	if not hasItem("Lemonade") then
		if not dialogs.martElevatorFloor5.state then
			pushDialogAnswer(5)
			return talkToNpcOnCell(1,1)
		else
			dialogs.martElevatorFloor5.state = false
			return moveToCell(2,5)
		end
	elseif not hasItem("TM28") then 
	     if not dialogs.martElevatorFloor3.state then
		pushDialogAnswer(3)
		return talkToNpcOnCell(1,1)
		else
			dialogs.martElevatorFloor3.state = false
			return moveToCell(2,5)
		end
	elseif hasItem("Lemonade") and hasItem("TM28") and getMoney() > 600000 then 
	      if not dialogs.martElevatorFloor2.state then
		pushDialogAnswer(2)
		return talkToNpcOnCell(1,1)
		else
			dialogs.martElevatorFloor2.state = false
			return moveToCell(2,5)
		end
	else
		if not dialogs.martElevatorFloor1.state then
			pushDialogAnswer(1)
			return talkToNpcOnCell(1,1)
		else
			dialogs.martElevatorFloor1.state = false
			return moveToCell(2,5)
		end
	end
end

function RainbowBadgeQuest:CeladonMart5()
	if not hasItem("Lemonade") then
		return moveToMap("Celadon Mart 6")
	elseif not hasItem("TM28") then
	   return moveToMap("Celadon Mart Elevator")
	else
		return moveToMap("Celadon Mart Elevator")
	end
end
function RainbowBadgeQuest:CeladonMart3()
    if not hasItem("TM28") and   getMoney() > 3500 then  
	    if not isShopOpen() then
		     return talkToNpcOnCell(10,10)
		 else
		  	     return buyItem("TM28", 1)
		  end
	else  
       return moveToMap("Celadon Mart Elevator")
 end
end
function RainbowBadgeQuest:CeladonMart6()
	if not hasItem("Lemonade") then
		if not isShopOpen() then
			return talkToNpcOnCell(15, 7)
		else
			if getMoney() > 1000 then
				return buyItem("Lemonade", 5)
			else
				return buyItem("Lemonade",(getMoney()/200))
			end
		end
	else
		return moveToMap("Celadon Mart 5")
	end
end

function RainbowBadgeQuest:UndergroundHouse3()
	return moveToMap("Underground1")
end

function RainbowBadgeQuest:Route8()
	return moveToMap("Lavender Town")
end

return RainbowBadgeQuest