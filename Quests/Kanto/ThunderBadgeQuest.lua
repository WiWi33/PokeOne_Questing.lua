-- Copyright © 2016 Rympex <Rympex@noemail>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Thunder Badge Quest'
local description = 'From Route 5 to Route 6'
local level       = 10



local dialogs = {
	Isa = Dialog:new({
		"I should be more careful...",
	}),
	fishingbook = Dialog:new({
		"The fishing was good, it was the catching that was bad."
	});
	fishingbook2 = Dialog:new({
		"Good things come to those who bait."
	});
	fishingbook3 = Dialog:new({
		"A bad day of fishing is better than a good day of work."
	});
	switchWrong = Dialog:new({
		"wrong switch",
		"have been reset"
	}),
	switchTrigger = Dialog:new({
		"have triggered the first switch"
	})
}

local ThunderBadgeQuest = Quest:new()

function ThunderBadgeQuest:new()
    zoneExp = math.random(1,3)
	o = Quest.new(	ThunderBadgeQuest, name, description, level, dialogs)
	o.puzzle = {}
	o.pokemonId = 1
	o.firstSwitchFound     = false
	o.firstSwitchActivated = false
	o.firstSwitchX = 0
	o.firstSwitchY = 0
	o.currentSwitchX = SWITCHES_START_X
	o.currentSwitchY = SWITCHES_START_Y
	return o
end

function ThunderBadgeQuest:isDoable()
	if   self:hasMap()     then
		return true
	end
	return false
end

function ThunderBadgeQuest:isDone()
	if ( getMapName() == "Route 11"   or getMapName() == "Route 5" )   then
		return true
	else
		return false
	end
end


function ThunderBadgeQuest:SSAnne()
if game.inRectangle(86, 369,133, 390) then
    if self:needPokecenter() or not game.isTeamFullyHealed()  then
	     return moveToCell(110,370)
    elseif not hasItem("HM01")   then
           
           	return moveToCell(88,384)
	else
		return moveToCell(110,370)
	end
elseif game.inRectangle(12, 332,48, 349) then
    if self:needPokecenter() or not game.isTeamFullyHealed()  then
	     return moveToCell(15,336)
    elseif not hasItem("HM01")   then
           
           	return moveToCell(47,335)
	else
		 return moveToCell(15,336)
	end	
else
    if not hasItem("HM01")   then
           if isNpcOnCell(21,384) then
           	return talkToNpcOnCell(21,384)
			else 
			  	return talkToNpcOnCell(17,380)
			end
	else
		 return moveToCell(13,386)
	end
end 
end
function ThunderBadgeQuest:Route5()
    if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
	elseif countBadges() == 3 and hasItem("HM05 - Flash") then 
		return moveToCell(157,138)
	else
		return moveToCell(157,189)
	end
end





	
function ThunderBadgeQuest:UndergroundPath()
 if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
 else 
	 if game.inRectangle(4, 2,14, 10) then
		if countBadges() == 3 and hasItem("HM05 - Flash") then 
		return moveToCell(8,9)
		else
		return moveToCell(11,5)
		end
	 elseif game.inRectangle(1, 26,14, 70) then
	    if isNpcOnCell(12,63) then 
		  return talkToNpcOnCell(12,63) -- Full Restore
		elseif countBadges() == 3 and hasItem("HM05 - Flash") then
		  return moveToCell(7,28)
		else
		  return moveToCell(7,67)
		end
     else
         	 if countBadges() == 3 and hasItem("HM05 - Flash") then
		  return moveToCell(11,83)
		else
		  return moveToCell(8,87)
		 end 
	 end 
 end 
end

function ThunderBadgeQuest:Route6()


	if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
    elseif  countBadges() == 3 and hasItem("HM05 - Flash") then
	     return  moveToCell(127,27)
	elseif not dialogs.Isa.state then
		return talkToNpcOnCell(124, 48) -- picnicker isa
	elseif self:needPokecenter()  or not game.isTeamFullyHealed() then
		return moveToCell(120,85)
	else
 		return moveToCell(120,85)
 	end
	
end



function ThunderBadgeQuest:VermilionPokémonCenter()
if self:needPokecenter() or not game.isTeamFullyHealed()  then
	return self:pokecenter("Vermilion City")
else
  return  moveToCell(140,98)
end
end

function ThunderBadgeQuest:VermilionCity()

if game.inRectangle(5, 38,17, 46) then
    if not dialogs.fishingbook.state  then 
	 return talkToNpcOnCell(13,38)
	elseif not dialogs.fishingbook2.state then 
	 return talkToNpcOnCell(12,38)
	elseif not dialogs.fishingbook3.state then 
	return talkToNpcOnCell(14,38)
	else 
	   return moveToCell(9,45)
    end 
else
    if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
	elseif self:needPokecenter() or not game.isTeamFullyHealed()  then
		return moveToCell(107,105)
    elseif  countBadges() == 3 and hasItem("HM05 - Flash") then 
		return moveToCell(120,84)
	elseif not dialogs.fishingbook3.state and not hasItem("Old Rod") then 
		return moveToCell(99,103)
    elseif dialogs.fishingbook3.state and not hasItem("Old Rod") then 
		 pushDialogAnswer(3)
	    return talkToNpcOnCell(82,138)
	elseif not self:isTrainingOver() then
		return moveToArea("Route 6")
	elseif not hasItem("HM01") then -- Need do SSanne Quest
		return talkToNpcOnCell(112,199) -- Enter on SSAnne
	elseif not hasItem("Old Rod") then
		return moveToArea("Fisherman House - Vermilion")
	elseif  countBadges() ~= 3 and hasItem("HM01")  then
		if not game.hasPokemonWithMove("Cut") then
		 --   for i=1,getTeamSize() do  				
				useItemOnMove("HM01","Smokescreen",1)
				--log("Pokemon: " .. i .. " Try Learning: HM01")
		--	end 
		else
			return moveToCel(107,142)
		end
	elseif countBadges() == 3 then
		return moveToArea("Route 11")
	end
end
end 

function ThunderBadgeQuest:VermilionPokemart()
end





function ThunderBadgeQuest:puzzleBinPosition(binId)
	local xCount = 5
	local yCount = 3
	local xPosition = 2
	local yPosition = 17
	local spaceBetweenBins = 2
	
	local line   = math.floor(binId / xCount + 1)
	local column = math.floor((binId - 1) % xCount + 1)
	
	local x = xPosition + (column - 1) * spaceBetweenBins
	local y = yPosition - (line   - 1) * spaceBetweenBins
	
	return x, y
end

function ThunderBadgeQuest:solvePuzzle()
	if not self.puzzle.bin then
		self.puzzle.bin = 1
	end
	if self.dialogs.switchWrong.state then
		self.dialogs.switchWrong.state = false
		self.dialogs.switchTrigger.state = false
		self.puzzle.bin = self.puzzle.bin + 1
	elseif self.dialogs.switchTrigger.state and not self.puzzle.firstBin then
		self.puzzle.firstBin = self.puzzle.bin
		self.puzzle.bin = 1 -- we know the first bin, let start again
	end
	
	if not self.dialogs.switchTrigger.state and self.puzzle.firstBin then
		local x, y = self:puzzleBinPosition(self.puzzle.firstBin)
		return talkToNpcOnCell(x, y)
	else
		local x, y = self:puzzleBinPosition(self.puzzle.bin)
		return talkToNpcOnCell(x, y)
	end
end

function ThunderBadgeQuest:VermilionGym()
	if not game.isTeamFullyHealed() and countBadges() == 3 then
 		return moveToArea("Vermilion City")
	elseif hasItem("TM28") and not hasMove(1,"Dig") and getPokemonName(1) == "Mankey" then
		  useItemOnPokemon("TM28",1)
	else
		if hasItem("Thunder Badge") then
			if not hasItem("TM24")  or getItemQuantity("TM24") < 2 then
				return talkToNpcOnCell(10,20)
			else
				return moveToArea("Vermilion City")
			end
		else
			if not isNpcOnCell(6, 10) then
				return talkToNpcOnCell(6,4)
			else
				return self:solvePuzzle()
			end
		end
	end
end

return ThunderBadgeQuest

