-- Copyright © 2016 Rympex <Rympex@noemail>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Cascade Badge Quest'
local description = 'From Cerulean to Route 5'
local level       = 10

local dialogs = {
	npcMisty = Dialog:new({
		"Oh!! You found it!",
		"Have you enjoyed the Cruise yet?"
	}),
	npcafterbeat = Dialog:new({
		"Good luck!",
		"And remember: expect the unexpected!"
	}),
	billTicketDone = Dialog:new({
		"Good luck!",
		"And remember: expect the unexpected!"
	}),
	pokebill = Dialog:new({
	     "Good luck!",
		"And remember: expect the unexpected!"
	}),
}

local CascadeBadgeQuest = Quest:new()

function CascadeBadgeQuest:new()
	return Quest.new(CascadeBadgeQuest, name, description, level, dialogs )
end

function CascadeBadgeQuest:isDoable()
	if self:hasMap() and not hasItem("HM01 - Cut") then
		return true
	end
	return false
end

function CascadeBadgeQuest:isDone()
	if getMapName() == "Route 5" then
		return true
	else
		return false
	end
end


function CascadeBadgeQuest:CeruleanCity()
    if self:needPokecenter()  or not game.isTeamFullyHealed() then
		return moveToCell(162,114)
	--elseif self:needPokemart() then
	--	return moveToCell(166,133) -- pokemart
	elseif  not self:isTrainingOver() then
		return moveToCell(39,0)-- Route 24 Bridge'
	elseif not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
	elseif countBadges() <= 1 and countBadges() >= 0  then
		return moveToCell(177,114) -- 2nd Gym
    elseif not hasItem("S.S. Ticket") then 
	     return moveToCell(183,73)
	else
		return moveToCell(155,138) -- Route 5
	end
end

function CascadeBadgeQuest:CeruleanHouse6()
	if not hasItem("TM28") then
		return talkToNpcOnCell(9,8)
	else 
		moveToMap("Cerulean City")
	end
end

function CascadeBadgeQuest:CeruleanPokémonMart()
	self:pokemart(22,7)
end

function CascadeBadgeQuest:CeruleanPokémonCenter()
 if not game.isTeamFullyHealed() then
	return self:pokecenter("Cerulean City")
  else
  return moveToCell(61,26)
  end 
end



function CascadeBadgeQuest:Route24()
if not hasItem("S.S. Ticket") then
	moveToCell(233,24)
else 
   moveToCell(190,80)
end 
end

function CascadeBadgeQuest:Route25()
	if not hasItem("S.S. Ticket") then -- RocketGuy -> Give Nugget($15.000)
		return moveToCell(284,15)
	else
		moveToCell(197,29)
	end
end

function CascadeBadgeQuest:SeaCottage() -- get ticket 
	if hasItem("S.S. Ticket") then
		return moveToCell(11,14)
	else
		if isNpcOnCell(14,10) then
			return talkToNpcOnCell(14, 10)
		else
			return talkToNpcOnCell(9,10)
		end
	end
end


function CascadeBadgeQuest:CeruleanGym() -- get Cascade Badge
		if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
		   elseif  not game.isTeamFullyHealed() then
		return moveToCell(51,136)
	elseif countBadges() <= 1 and ccountBadges() >= 0 then
		return talkToNpcOnCell(51, 109)
	elseif countBadges() == 2  and not dialogs.npcafterbeat.state then 
	     return talkToNpcOnCell(55, 131)
	else 
	   return  moveToCell(51,136)
	end
end

return CascadeBadgeQuest
