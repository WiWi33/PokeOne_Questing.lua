-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"
local name		  = 'Earth Badge'
local description = ' Beat Giovanni'
local level = 48
local dialogs = {
	Lance = Dialog:new({ 
		"There is always someone better than you!",
	}),
	Gary = Dialog:new({ 
		"Ok ok, you are the champ, I'm the loser...",
	}),
}
local EarthBadgeQuest = Quest:new()

function EarthBadgeQuest:new()
	local o = Quest.new(EarthBadgeQuest, name, description, level,dialogs)
	o.statusrepel = false
	return o
end

function EarthBadgeQuest:isDoable()
	if self:hasMap() then --Fixed DC on gym after win
		return true
	end
	return false
end

function EarthBadgeQuest:isDone()
	if  getMapName() == "Pallet House" then --Fixed DC on gym after win, and Blackout
		return true
	end
	return false	
end

function EarthBadgeQuest:Route21()
 if getPlayerY() < 70  then
	 moveToCell(84,27)
  else 
   moveToCell(150,203)
 end 

end

function EarthBadgeQuest:Route22()

moveToCell(39,89)
end

function EarthBadgeQuest:PokémonLeagueReception()

moveToCell(25,11)
end

function EarthBadgeQuest:Route23()
if getPlayerX() <= 52 and getPlayerY() > 92 then
moveToCell(32,94)
else 
 if not self:isTrainingOver() then 
 moveToCell(53,94)
 else
moveToCell(41,50)
end 

end
end 

function EarthBadgeQuest:IndigoPlateau()
 if not self:isTrainingOver() then 
 moveToCell(41,53)
 else
moveToCell(42,24)
end 
end 
function EarthBadgeQuest:VictoryRoad()
   if not self:isTrainingOver() then 
   moveToRectangle(23,235,25,236)
 else
   moveToCell(23,240)
    end 
end
function EarthBadgeQuest:PokémonLeague()
   if not self:isTrainingOver() then 
   moveToCell(40,55)
 else
 if isNpcOnCell(52,35)  then 
 talkToNpcOnCell(52,35)
 else 
   moveToCell(51,31)
    end 
	end 
end

function EarthBadgeQuest:KantoLeague()
  if game.inRectangle(15,5,35,30) then 
     moveToCell(25,7)
	 elseif game.inRectangle(15,58,35,84) then 
     moveToCell(25,60) 
	  elseif game.inRectangle(67,5,87,32) then 
     moveToCell(77,7) 
	   elseif game.inRectangle(66,60,100,97) then 
	   if not dialogs.Lance.state then 
	   
	   talkToNpcOnCell(76,72)
	   else 
     moveToCell(77,62) 
	 end 
 end 
  
end

function EarthBadgeQuest:KantoHallofFame()
 if not dialogs.Gray.state then 
   talkToNpcOnCell(134,105)
   end 
  
end


function EarthBadgeQuest:VictoryRoad1F()
if self.statusrepel == false and hasItem("Max Repel") then
self.statusrepel = true 
return useItem("Max Repel")
else
	return  moveToCell(9,9)
end 
-- end 
end
function EarthBadgeQuest:VictoryRoad2F()
 --if getPlayerY() > 24 then
	 moveToCell(11,96)
-- end 
end

function EarthBadgeQuest:VictoryRoad3F()
 --if getPlayerY() > 24 then
 
	 moveToCell(41,159)
	
-- end 
end
function EarthBadgeQuest:Route21Gate()
 --if getPlayerY() > 24 then
	 moveToCell(11,10)
-- end 
end

function EarthBadgeQuest:PlayerBedroomPallet()
	return moveToArea("Player House Pallet")
end

function EarthBadgeQuest:PlayerHousePallet()
 if getPlayerY() > 24 then
	return moveToCell(4,10)
 end 
end

function EarthBadgeQuest:PalletTown()
moveToCell(150,168)
end

function EarthBadgeQuest:Route1()
 moveToArea("Viridian City")
end


function EarthBadgeQuest:ViridianPokémonCenter()
   self.statusrepel = false
	self:pokecenter("Viridian City")
end

function EarthBadgeQuest:ViridianPokémonMart()
	self:pokemartrepel(10,68)
end

function EarthBadgeQuest:ViridianCity()
self.statusrepel = false
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
	if self:needPokecenter() or not game.isTeamFullyHealed() or  self.registeredPokecenter ~= "Viridian Pokémon Center"  then
		moveToCell(146, 91)
	elseif self:needPokemart() then
		return moveToArea("Viridian Pokemart")
	elseif countBadges() < 8 then
		return moveToCell(159,68)
--	elseif not self:isTrainingOver() then
	--	return fatal("Error This team can't beat Giovanni")
	
	else
		return moveToArea("Route 22")--Cell(98,103) --Viridian Gym 2
	end
end
end 


function EarthBadgeQuest:ViridianGym()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
	if countBadges() < 8 and getPlayerY() >= 60 then
		return requestPathForQuestId(getMainQuestId())
	elseif countBadges() < 8  then
	   return 	talkToNpcOnCell(171,58)
	else
		return requestPathForQuestId(getMainQuestId())
	end
end 
end

return EarthBadgeQuest