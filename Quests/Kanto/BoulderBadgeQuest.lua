-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Boulder Badge'
local description = 'from route 2 to route 3'
local dialogs = {
	npcBugcatcherYolo = Dialog:new({
		"But you can find new Pokémon everywhere in tall grass!"
	}),
	npcGuardGate = Dialog:new({
	 "Good luck on your travels!"
	 }),
	 npcGuardGate2 = Dialog:new({
	 "Okay, nothing to worry about. Keep your Pokémon healthy!"
	 }),
	npcUncleDodge = Dialog:new({
	 "The forest is not safe with all the poisonous bugs around... "
	 }),
	 npcUncleDodge2 = Dialog:new({
	 "Don't forget to look for rare Pokémon in tall grass!"
	 }),
	npcLara = Dialog:new({
	 "Some Pokémon only appear rarely..."
	 }),
	 npcBugcatcherRiley = Dialog:new({
		"Careful!",
		"Don't scare the bugs away!"
	}),
	npcBugcatcherAbbey = Dialog:new({
		"But then again, catching bugs is my favorite!"
	}),
	npcBugcatcherCharles = Dialog:new({
		"Hanging around, catching some bugs...",
		"I like this forest!"
	}),
	npcDavePewter = Dialog:new({
		"It may not be the most beautiful city,",
	}),
	npcYoungsterJohn = Dialog:new({
		"is built on solid rocks!",
	}),	
	npcSteve = Dialog:new({
		"Nothing is as tough as",
	}),	
	npcRocky = Dialog:new({
		"Nothing is tougher than",
	}),
	npcEdwin = Dialog:new({
	"It took a lot of effort to build this gym!"
	}),
	npcBrock = Dialog:new({
	"Just as I thought! You're Pokémon champ material!"
		}),
    --Route 3 NPC
	npcHikerWilly = Dialog:new({
	"Take a look at the meteorite crater nearby.",
	"You should find a Moon Stone there!"
		}),
	npcHikerWilly2 = Dialog:new({
	"Mt. Moon holds many secrets...",
	}),	
	npcYoungsterJosh = Dialog:new({
	"Wait, we'll meet again!",
	"Until then I'll catch more Pokémon!"
		}),
	npcLassJanie = Dialog:new({
	"A lot of meteorites came down over Mt. Moon."
		}),
	npcBugcatcherKent = Dialog:new({
	"Find my two bugcatcher friends, and beat them!"
		}),
	npcYoungsterBen = Dialog:new({
	"Guess you don't like shorts!"
		}),
		npcNerdJason = Dialog:new({
	"I don't get it...",
	"shorts, battles, what am I doing wrong?"
		}),
		npcAndy = Dialog:new({
	"The Museum in Pewter City is interested in the fossils found in Mt. Moon."
		}),
}
local BoulderBadgeQuest = Quest:new()
function BoulderBadgeQuest:new()
	return Quest.new(BoulderBadgeQuest, name, description, 18 , dialogs )
end

function BoulderBadgeQuest:isDoable()
	if self:hasMap() and not hasItem("HM01")
	then
		return true
	end
	return false
end

function BoulderBadgeQuest:isDone()
	return getAreaName() == "Mt. Moon Pokémon Center" or getAreaName() == "Mt. Moon"
end

-- in case of black out
function BoulderBadgeQuest:ViridianPokémonCenter()
	return moveToCell(9, 129)
end

function BoulderBadgeQuest:ViridianCity()
	return moveToCell(142,48)
end

function BoulderBadgeQuest:Route2()
	if game.inRectangle(137, 50, 154, 0) then
	  if not dialogs.npcBugcatcherYolo.state then
	      talkToNpcOnCell(142,33)
	  elseif isNpcOnCell(143,27) then
	      talkToNpcOnCell(143,27)
	  else 
		return moveToCell(147,19)
		end 
	elseif game.inRectangle(5, 51, 50, 91) then
		self:route2Up()
	else
		error("BoulderBadgeQuest:Route2(): This position should not be possible")
	end
end

function BoulderBadgeQuest:ViridianForestGate()
if getPlayerY() > 17 then 
 if not dialogs.npcGuardGate.state   then
  return	talkToNpcOnCell(11,42) 
 else 
  return moveToCell(8,36)
end
else
  if  not  dialogs.npcGuardGate2.state then
  return	 talkToNpcOnCell(11,9)
 else 
  return  moveToCell(8,3)
end
end 
end

function BoulderBadgeQuest:ViridianForest()
dialogs.npcGuardGate.state = false
	 if dialogs.npcUncleDodge2.state then
	   dialogs.npcUncleDodge.state = true
	   dialogs.npcLara.state = true 
	 elseif not dialogs.npcUncleDodge.state then
	   return	talkToNpcOnCell(37,78)
	 elseif not dialogs.npcLara.state then 
	 return talkToNpcOnCell(20,52)
	 end 
	  if not dialogs.npcBugcatcherRiley.state then 
	 return talkToNpcOnCell(41,68)
	 elseif not dialogs.npcBugcatcherAbbey.state then 
	 return talkToNpcOnCell(46,31)
	 	 elseif not dialogs.npcBugcatcherCharles.state then 
	 return talkToNpcOnCell(16,28)
	 else 
	 return moveToCell(11,16)
      end
end

function BoulderBadgeQuest:Route2Stop2()
	return moveToArea("Route 2")
end

function BoulderBadgeQuest:route2Up()
    if not dialogs.npcYoungsterJohn.state then 
	   talkToNpcOnCell(26,78)
    else 
	   moveToCell(20,56)
	end
end

function BoulderBadgeQuest:PewterCity()
	--if not hasBadge("Boulder Badge") then 
	 if not  dialogs.npcBrock.state then
		if not dialogs.npcDavePewter.state    then 
		   return talkToNpcOnCell(22,55)
		elseif   not game.isTeamFullyHealed() then
			return moveToCell(35,48)
		else
			return moveToCell(30,26)
		end 
	 else 
		if  not game.isTeamFullyHealed() then
			return moveToCell(35,48)
		else
			return moveToCell(89,46)
		end
	 end 
	--else 
	--  return moveToCell(89,46)
	--end 
end 
function BoulderBadgeQuest:PewterGym()
	if dialogs.npcBrock.state or  not game.isTeamFullyHealed() then
		sys.todo("BoulderBadgeQuest::PewterGym(): buy the TM")
		return moveToCell(15,116)
    elseif not dialogs.npcSteve.state then
	    return talkToNpcOnCell(14,107)
    elseif not dialogs.npcRocky.state then
	    return talkToNpcOnCell(17,104)
    elseif not dialogs.npcEdwin.state then
	    return talkToNpcOnCell(16,101)
	elseif not dialogs.npcBrock.state then
		return talkToNpcOnCell(15,92)
    else 
	return moveToCell(15,116)
	end
end

function BoulderBadgeQuest:Route3()
    if  not game.isTeamFullyHealed() and  not dialogs.npcNerdJason.state then
		return moveToCell(35,48)
    elseif dialogs.npcHikerWilly2.state and not dialogs.npcHikerWilly.state  then 
	     dialogs.npcHikerWilly.state = true 
	elseif not dialogs.npcHikerWilly.state then
	   return talkToNpcOnCell(109,43)
	--elseif not dialogs.npcYoungsterJosh.state then 
	--  return talkToNpcOnCell(106,52)
	elseif isNpcOnCell(105,69) then 
	 return talkToNpcOnCell(105,69)
	elseif not dialogs.npcHikerWilly2.state then
	   return talkToNpcOnCell(109,43)
	--elseif not dialogs.npcLassJanie.state then
	 --  return talkToNpcOnCell(123,45)
    --elseif not dialogs.npcBugcatcherKent.state then
	--   return talkToNpcOnCell(131,54)
    --elseif not dialogs.npcYoungsterBen.state then
	--   return talkToNpcOnCell(148,55)
    elseif not dialogs.npcNerdJason.state then
	   return talkToNpcOnCell(164,68)
	elseif not dialogs.npcAndy.state then
	   return talkToNpcOnCell(189,49)
	elseif not game.isTeamFullyHealed() then 
	   return moveToCell(178,48)
	else 
	    return moveToCell(188,47)
	end 
end

function BoulderBadgeQuest:PewterPokémonCenter()
if  not game.isTeamFullyHealed() then
	return talkToNpcOnCell(69,107)
else
    return moveToCell(69,117)
end
end 
function BoulderBadgeQuest:PewterPokemart()
	self:pokemart(1,1,1,1)
end

return BoulderBadgeQuest
