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
	if self:hasMap() and not hasItem("Soul Badge") and not isNpcOnCell(48,34) then
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
	--if not enableTrainerBattles()  then 
   --          enableTrainerBattles()
	--else
	if isNpcOnCell(21,51) and getPlayerX() == 21 and getPlayerY() == 50 and hasItem("Rainbow Badge") then --NPC: Trainer OP
		return talkToNpcOnCell(21,51)
	elseif self:needPokecenter() or not game.isTeamFullyHealed()  then
		return moveToCell(165,82)
	elseif isNpcOnCell(54,14) then --Item: Great Ball
		return talkToNpcOnCell(54,14)
	elseif isNpcOnCell(46,49) and not isNpcOnCell(48,34)  then --NPC: Rocket Guy
		return talkToNpcOnCell(46,49)
	elseif   not game.hasPokemonWithMove("Cut") then
		if self.pokemonId <= getTeamSize() then					
			useItemOnPokemon("HM01 - Cut", self.pokemonId)
			log("Pokemon: " .. self.pokemonId .. " Try Learning: HM01 - Cut")
			self.pokemonId = self.pokemonId + 1
		else
			fatal("No pokemon in this team can learn - Cut")
		end 
	elseif not hasItem("Rainbow Badge") then
	    if not game.hasPokemonWithMove("Cut") then
		if self.pokemonId <= getTeamSize() then					
			useItemOnPokemon("HM01 - Cut", self.pokemonId)
			log("Pokemon: " .. self.pokemonId .. " Try Learning: HM01 - Cut")
			self.pokemonId = self.pokemonId + 1
		else
			fatal("No pokemon in this team can learn - Cut")
		end 
		elseif isNpcOnCell(21,51) then 
		 return   talkToNpcOnCell(21,51)
		else
		return moveToMap("CeladonGym")
		end 
	elseif isNpcOnCell(14,42) and  not isNpcOnCell(48,34) and hasItem("Rainbow Badge") then --NPC: Remove the Guards
		return talkToNpcOnCell(14,42)
	elseif not hasItem("Lemonade") or (not hasItem("TM28") and getMoney() > 3500 )   then -- Buy Lemonade for Future Quest (Saffron Guard)
		return moveToMap("Celadon Mart 1")
	
	else
		return moveToMap("Route 7")
	end
end

function RainbowBadgeQuest:PokecenterCeladon()
 if not game.isTeamFullyHealed() then  
	self:pokecenter("Celadon City")
 else 
   -- if  getTeamSize() >= 4 then  
	 --  if isPCOpen() then
       --  depositPokemonToPC(4)
      -- else 
	    return moveToCell()
     --  end
	-- else
	 --  moveToMap("Celadon City")
	--end 
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
	if not game.hasPokemonWithMove("Cut") then
		if self.pokemonId <= getTeamSize() then					
			useItemOnPokemon("HM01 - Cut", self.pokemonId)
			log("Pokemon: " .. self.pokemonId .. " Try Learning: HM01 - Cut")
			self.pokemonId = self.pokemonId + 1
		else
			fatal("No pokemon in this team can learn - Cut")
		end
	elseif hasItem("TM28") and not hasMove(1,"Dig") and getPokemonName(1) == "Mankey" then
		  useItemOnPokemon("TM28",1)
	elseif self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Celadon" or not self:isTrainingOver() then
		return moveToMap("Celadon City")
	elseif not hasItem("Rainbow Badge") then
		talkToNpcOnCell(8,4) -- Erika
	else
	    if not game.hasPokemonWithMove("Cut") then
		    if self.pokemonId <= getTeamSize() then					
			useItemOnPokemon("HM01 - Cut", self.pokemonId)
			log("Pokemon: " .. self.pokemonId .. " Try Learning: HM01 - Cut")
			self.pokemonId = self.pokemonId + 1
		    else
			fatal("No pokemon in this team can learn - Cut")
		    end
		else
		return moveToMap("Celadon City")
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
function RainbowBadgeQuest:CeladonMart2()
    n = getMoney() / 600
    if getMoney() > 600 and hasItem("TM28") and hasItem("Lemonade") then  
	    if not isShopOpen() then
		     return talkToNpcOnCell(4,10)
		 else
		  	     return buyItem("Great Ball", n)
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

function RainbowBadgeQuest:Underground1()
	return moveToMap("Underground House 4")
end

function RainbowBadgeQuest:UndergroundHouse4()
	return moveToMap("Route 8")
end

function RainbowBadgeQuest:Route8()
	return moveToMap("Lavender Town")
end

return RainbowBadgeQuest