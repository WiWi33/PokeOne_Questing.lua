-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'StartKantoQuest'
local description = 'Getting starter and finishing Viridian City quests!'
local dialogs = {
	momTalk = Dialog:new({
	"Right. All girls leave home someday. It said so on TV.",
    "Right. All boys leave home someday.",
    "Oh good! You and your Pokémon are looking great! Take care now!"
        }),
    regisBeat = Dialog:new({
    "Smell ya'"
    }),
    yougsterBeat = Dialog:new({
        "It's all about catching and training!"
    }),
    shermanBeat = Dialog:new({
        "There are lots of Pokémon in the tall grass!"
    }),
    lassBeat = Dialog:new({
        "I'm sure you will make your way"
    }),
    nurse = Dialog:new({
        "There you go, take care of them!"
    }),
    carl = Dialog:new({
        "She can teach you something about Pokémon!",
		"How may I help you?"
    }),
    dizzy = Dialog:new({
        "If not, feel free to use the computers!"
    }),
    papi = Dialog:new({
        "Go ahead, young trainer. May the good winds be with you"
    }),
    
}



local StartKantoQuest = Quest:new()

function StartKantoQuest:new()
	return Quest.new(StartKantoQuest, name, description, 18 , dialogs )
end

function StartKantoQuest:isDoable()
	if self:hasMap() and not hasItem("Poké Flute")
	then
		return true
	end
	return false
end

function StartKantoQuest:isDone()
	return getAreaName() == "Route 2"
end

-- in case of black out
function StartKantoQuest:PalletTown()
    --You are in your house
    if game.inRectangle(9, 7, 19, 12) or game.inRectangle(59, 4, 78, 15)  then
        MyHouse()
    elseif  game.inRectangle(133, 172, 170, 201) then
        PalletTownOut()
    end

end

function StartKantoQuest:ViridianPokémonMart()
    if not dialogs.carl.state then
        talkToNpcOnCell(10, 68)
    elseif isShopOpen() then
        log("CLOSING SHOP.....")
        closeShop()
    else
        log("Need to move to ViridianCity")
        moveToCell(13, 78)
    end

end

function StartKantoQuest:OaksLab()
    if getTeamSize() == 0 and KANTO_STARTER_ID == 1 then
		pushDialogAnswer("Bulbasaur")
        talkToNpcOnCell(22, 103) -- TODO : Choose you damn pokemon
	elseif getTeamSize() == 0 and KANTO_STARTER_ID == 2 then
		pushDialogAnswer("Charmander")
        talkToNpcOnCell(22, 103) -- TODO : Choose you damn pokemon
		elseif getTeamSize() == 0 and KANTO_STARTER_ID == 3 then
		pushDialogAnswer("Squirtle")
        talkToNpcOnCell(22, 103) -- TODO : Choose you damn pokemon
    else 
        moveToCell(22, 108)
    end

end

function StartKantoQuest:ViridianPokémonCenter()
    if  not game.isTeamFullyHealed() then
	    return talkToNpcOnCell(9,119)
    elseif not (dialogs.nurse.state) then
        return talkToNpcOnCell(9,119)
    else 
        moveToCell(9, 129)
    end
end

function StartKantoQuest:ViridianCity()
    if not (dialogs.nurse.state) then
        if game.inRectangle(3, 6, 22, 22) then
            moveToCell(14, 21)
        else
            moveToCell(146, 91)
        end
    elseif not (dialogs.carl.state) then
        moveToCell(156, 81)
    elseif not (dialogs.dizzy.state) and not game.inRectangle(3, 6, 22, 22) then
        moveToCell(148, 72)
    elseif not (dialogs.dizzy.state) and game.inRectangle(3, 6, 22, 22) then
        talkToNpcOnCell(14, 8)
    elseif  dialogs.dizzy.state and game.inRectangle(3, 6, 22, 22) then
        moveToCell(13, 21)
    elseif not dialogs.papi.state then 
        talkToNpcOnCell(142, 51)
    else  
	    moveToCell(142,48)  -- move to Route 2 to complete a quest 
    end
end

function StartKantoQuest:Route1()
	if not (dialogs.yougsterBeat.state) then
        talkToNpcOnCell(155, 158)
    elseif  not (dialogs.shermanBeat.state) then
        talkToNpcOnCell(158, 136)
    elseif not (dialogs.lassBeat.state) then 
        talkToNpcOnCell(148, 106)
    else
        moveToArea("Viridian City")
    end
end

function MyHouse()
    if game.inRectangle(59, 4, 78, 15) then
        log("Je suis en haut maman !")
        moveToCell(73, 7)
    elseif not dialogs.momTalk.state then 
        if (isNpcOnCell(14, 7)) then
            talkToNpcOnCell(14, 7)
        end
    else 
        moveToCell(12, 13)      
    end
    
end

function PalletTownOut()
    if getTeamSize() == 0 then 
        moveToCell(158, 192)
    elseif not dialogs.regisBeat.state and isNpcOnCell(150,174) then
        talkToNpcOnCell(150, 174)
    else 
        moveToArea("Route 1")
    end
end

return StartKantoQuest