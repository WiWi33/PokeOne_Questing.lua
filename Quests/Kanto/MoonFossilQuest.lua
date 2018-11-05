-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"
            



local name        = 'Mt. Moon Fossil'
local description = 'from Route 3 to Cerulean City'
local level       = 25

local dialogs = {

}

local MoonFossilQuest = Quest:new()
function MoonFossilQuest:new()
	return Quest.new(MoonFossilQuest, name, description, level, dialogs )
end

function MoonFossilQuest:isDoable()
	if not hasItem("Cascade Badge") and self:hasMap()
	then
		return true
	end
	return false
end

function MoonFossilQuest:isDone()
	return getAreaName() == "Cerulean City" or getAreaName() == "Pewter Pokémon Center" 
end

function MoonFossilQuest:Route3()
	if not game.isTeamFullyHealed()
	then
		return moveToCell(178,48)
	else
		return moveToCell(188,47)
	end
end

function MoonFossilQuest:MtMoon()
		if not game.isTeamFullyHealed()
	then
	return moveToCell(105,49)
	elseif not self:isTrainingOver() then 
	   return moveToRectangle(98,39,103,40) 
	else
		return moveToCell(95,16) -- Mt. Moon B1F
	end
end

function MoonFossilQuest:MtMoonB1F()
     
	if game.inRectangle(4, 128, 25, 147) then
	--if  not game.isTeamFullyHealed()then
	--return moveToCell(6, 130)
	
	--else 
		return moveToCell(21, 145) -- Mt. Moon B2F (wrong way)
	--end 
	else 
	  return moveToCell(36,219)
	end 
end

function MoonFossilQuest:MtMoonB2F()

	--if  not game.isTeamFullyHealed() and isNpcOnCell(20,76) then
	--return moveToCell(35,86)
	--else
	if isNpcOnCell(20,76) then 
	return talkToNpcOnCell(20,76)
	else
	return 	moveToCell(11,75)
	end 
end


function MoonFossilQuest:Route4()
	return moveToCell(123, 100) -- Cerulean City (avoid water link)
end

function MoonFossilQuest:MtMoonPokémonCenter()
  if  not game.isTeamFullyHealed() then 
    return usePokecenter()
	else 
	return moveToCell(10,25)
end
end 

return MoonFossilQuest
