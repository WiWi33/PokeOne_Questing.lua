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
local description = 'Lavender Town (get pokeflute ) and come fuchsia'
local level = 32

local dialogs = {
	checkFujiHouse = Dialog:new({ 
		"i should check out"
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
	if (hasItem("Poké Flute") and getAreaName() == "Fuchsia City")  then --FIX Blackout 
		return true
	else
		return false
	end
end

function PokeFluteQuest:LavenderPokémonCenter()

	self:pokecentercell(53,25)

end 
function PokeFluteQuest:LavenderTown()
	if self:needPokecenter() or not game.isTeamFullyHealed() or  self.registeredPokecenter ~= "Lavender Pokémon Center" 
	 then
		return moveToCell(115,116)
	elseif not hasItem("Poké Flute") then
		return moveToCell(126,117)
	else
		return moveToCell(119,160)
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
	return moveToCell(26,119)
end

--function PokeFluteQuest:UndergroundPath()
--if game.inRectangle(105, 6,115, 14) then
--	return moveToCell(108,10)
--elseif game.inRectangle(32, 4,88, 14) then
 ---- return moveToCell(33,9)
--else
--  return moveToCell(8,11)
--end 
--end
function PokeFluteQuest:Route7()
	if isNpcOnCell(198,104) then 
		return talkToNpcOnCell(198,104)
		elseif isNpcOnCell(204,94) then 
		return talkToNpcOnCell(204,94)
	else
		return moveToCell(167,85)
	end
end
function PokeFluteQuest:CeladonCity()
  return moveToCell(95,105)
end

function PokeFluteQuest:LavenderTownGate()
  return moveToCell(13,23)
end
function PokeFluteQuest:Route12()
if isNpcOnCell(262,133) then 
pushDialogAnswer(getItemId("Poké Flute")) 
talkToNpcOnCell(262,133)
elseif isNpcOnCell(257,147) then 
return talkToNpcOnCell(257,147)

else
  return moveToCell(267,224)
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