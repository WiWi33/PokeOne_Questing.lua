-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Poké Flute'
local description = 'Lavender Town (get pokeflute ) and come saffron or fuchsia'
local level = 32

local dialogs = {
	grandma = Dialog:new({ 
		"Meowth even brings money home!"
	}),
	checkFujiNote = Dialog:new({
		"go into that tower to check",
		"already read this note"
	})
}

local PokeFluteQuest = Quest:new()

function PokeFluteQuest:new()
	return Quest.new(PokeFluteQuest, name, description, level, dialogs)
end

function PokeFluteQuest:isDoable()
	if self:hasMap() and not hasItem("HM03") then
		return true
	end
	return false
end

function PokeFluteQuest:isDone()
	if (hasItem("Poké Flute") and (getAreaName() == "Fuchsia City" 
	or getAreaName() == "Saffron City Gate" or getAreaName() == "Saffron Pokémon Center" ))  then --FIX Blackout 
		return true
	else
		return false
	end
end

function PokeFluteQuest:LavenderPokémonCenter()

	self:pokecentercell(53,25)

end 
function PokeFluteQuest:LavenderTown()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else
	if self:needPokecenter() or not game.isTeamFullyHealed() or  self.registeredPokecenter ~= "Lavender Pokémon Center" 
	 then
		return moveToCell(115,116)
	elseif not hasItem("Poké Flute") then
		return moveToCell(126,117)
	elseif countBadges() == 4 then 
		return moveToCell(90,122)
	elseif countBadges() == 5 then 
		return moveToCell(119,160)
	end
end 
end

function PokeFluteQuest:LavenderTownVolunteerHouse()
	if not dialogs.checkFujiNote.state then
		return talkToNpcOnCell(10,10)
	else
		return moveToArea("Lavender Town")
	end
end

function PokeFluteQuest:PokémonTower()
	if hasItem("Poké Flute") then
		return moveToCell(14,25)
	else
		return moveToCell(23,16)
	end
end

function PokeFluteQuest:PokémonTower2F()
	if hasItem("Poké Flute") then
		return moveToCell(58,17)
	
	else
		return moveToCell(74,17)
	end
end

function PokeFluteQuest:PokémonTower3F()
	if hasItem("Poké Flute") then
		return moveToCell(119,17)
	else
		return moveToCell(135,17)
	end
end

function PokeFluteQuest:PokémonTower4F()
	if hasItem("Poké Flute") then
		return moveToCell(175,18)
	else
		return moveToCell(191,18)
	end
end

function PokeFluteQuest:PokémonTower5F()
	if hasItem("Poké Flute") then
		return moveToCell(9,69)
	else
		return moveToCell(25,70)
	end
end

function PokeFluteQuest:PokémonTower6F()
	if hasItem("Poké Flute") then
		return moveToCell(60,69)
	else
	  if isNpcOnCell(72,67) then 
	    talkToNpcOnCell(72,67)
	  else
		return moveToCell(75,70)
		end 
	end
end

function PokeFluteQuest:PokémonTower7F()
	if hasItem("Poké Flute") then
		return moveToCell(120,70)
	else
	   if isNpcOnCell(127,65) then 
	   return talkToNpcOnCell(127,65)
	   
	   else 
		return talkToNpcOnCell(128,65) -- Fuji NPC - Give PokeFlute
	end
	end 
end


function PokeFluteQuest:Route8()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
if countBadges() == 5 then 
   return moveToCell(105,123)
elseif not hasItem("Tea") and countBadges() != 5 then 
   return moveToCell(26,119)

else
	return moveToCell(105,123)--return moveToCell(11,123)
end
end 
end 
function PokeFluteQuest:UndergroundPath()
if not hasItem("Tea") then 
if game.inRectangle(105, 6,115, 14) then
	return moveToCell(108,10)
elseif game.inRectangle(32, 4,88, 14) then
 return moveToCell(33,9)
else
  return moveToCell(8,11)
end 
else 
  if game.inRectangle(105, 6,115, 14) then
	return moveToCell(111,113)
elseif game.inRectangle(32, 4,88, 14) then
 return moveToCell(87,9)
else
  return moveToCell(11,7)
end 
end 
end
function PokeFluteQuest:Route7()
if not hasItem("Tea")  and not dialogs.grandma.state then
	if isNpcOnCell(198,104) then 
		return talkToNpcOnCell(198,104)
		elseif isNpcOnCell(204,94) then 
		return talkToNpcOnCell(204,94)
	else
		return moveToCell(167,85)
	end
else 
   return moveToCell(225,91)
end
end
function PokeFluteQuest:CeladonCity()
if not hasItem("Tea") and not dialogs.grandma.state then
 return moveToCell(144,82)
else 
  return moveToCell(185,86)
end
end 	

function PokeFluteQuest:CeladonCondominiums()
if not hasItem("Tea") and not dialogs.grandma.state then
 return talkToNpcOnCell(11,13)
else 
  return moveToCell(21,26)
end
end 
function PokeFluteQuest:LavenderTownGate()
  return moveToCell(13,23)
end
function PokeFluteQuest:Route12()
if game.inRectangle(83,70,92,77) then 
if not hasItem("Super Rod") then 
 talkToNpcOnCell(85,71)
 else
 moveToNearestLink()
 end 
else
if isNpcOnCell(262,133) then 
pushDialogAnswer(getItemId("Poké Flute")) 
talkToNpcOnCell(262,133)
elseif isNpcOnCell(257,147) then 
return talkToNpcOnCell(257,147)
elseif not hasItem("Super Rod") then 
return  moveToCell(261,149)
else
  return moveToCell(267,224)
end
end 
end 
function PokeFluteQuest:Route13()

  return moveToCell(137,236)

end 
function PokeFluteQuest:Route14()

  return moveToCell(108,260)

end 
function PokeFluteQuest:Route15()

  return moveToCell(42,263)

end 
function PokeFluteQuest:FuchsiaCityGate()

  return moveToCell(128,77)

end 
return PokeFluteQuest