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
	})
}

local CascadeBadgeQuest = Quest:new()

function CascadeBadgeQuest:new()
	return Quest.new(CascadeBadgeQuest, name, description, level, dialogs , state)
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
	elseif self:needPokemart() then
		return moveToCell(166,133) -- pokemart
	elseif  not self:isTrainingOver() then
		return moveToCell(39,0)-- Route 24 Bridge
	elseif countBadges() <= 1 and countBadges() >= 0  then
		return moveToCell(177,114) -- 2nd Gym
    elseif not hasItem("Bill Ticket") then 
	     return moveToCell(39,0)
	else
		return moveToCell(23,50) -- Route 5
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
	self:pokemart("Cerulean City")
end

function CascadeBadgeQuest:CeruleanPokémonCenter()
 if not game.isTeamFullyHealed() then
	return self:pokecenter("Cerulean City")
  else
  return moveToCell(61,26)
  end 
end



function CascadeBadgeQuest:Route24()
	moveToCell(233,24)
end

function CascadeBadgeQuest:Route25()
	if not dialogs.billTicketDone.state then -- RocketGuy -> Give Nugget($15.000)
		return moveToCell(256,19)
	elseif not dialogs.billTicketDone.state then
		return moveToMap("Bills House")
	else
		moveToCell(14, 30)
	end
end

function CascadeBadgeQuest:BillsHouse() -- get ticket 
	if dialogs.billTicketDone.state then
		return moveToMap("Route 25")
	else
		if dialogs.bookPillowDone.state then
			return talkToNpcOnCell(11, 3)
		else
			return talkToNpcOnCell(18, 2)
		end
	end
end

function CascadeBadgeQuest:ItemManiacHouse() -- sell nugget
	if hasItem("Nugget") then
		return talkToNpcOnCell(6, 5)
	else
		return moveToMap("Route 25")
	end
end

function CascadeBadgeQuest:CeruleanGym() -- get Cascade Badge
	if  not game.isTeamFullyHealed() then
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
