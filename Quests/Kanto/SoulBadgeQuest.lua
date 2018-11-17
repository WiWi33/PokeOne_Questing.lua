-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Sould Badge'
local description = 'Fuchsia City'
local level = 79

local dialogs = {
	questSurfAccept = Dialog:new({ 
		"There is something there I want you to take",
		"Did you get the HM broseph"
	})
}

local SoulBadgeQuest = Quest:new()

function SoulBadgeQuest:new()
	local o = Quest.new(SoulBadgeQuest, name, description, level, dialogs)
	o.zoneExp = 1
	o.pokemonId = 1
	return o
end

function SoulBadgeQuest:isDoable()	
	if self:hasMap() and not hasItem("Marsh Badge")  then
		if getMapName() == "Route 15" then 
			if hasItem("Soul Badge") and hasItem("HM03") then
				return false
			else
				return true
			end
		else
			return true
		end
	end
	return false
end

function SoulBadgeQuest:isDone()
	if (hasItem("Soul Badge") and hasItem("HM03") and getMapName() == "Route 15") or getMapName() == "Safari Entrance" or getMapName() == "Route 20"then
		return true
	else
		return false
	end
end

function SoulBadgeQuest:pokemart_()
	local pokeballCount = getItemQuantity("Pokeball")
	local money         = getMoney()
	if money >= 200 and pokeballCount < 50 then
		if not isShopOpen() then
			return talkToNpcOnCell(9,8)
		else
			local pokeballToBuy = 50 - pokeballCount
			local maximumBuyablePokeballs = money / 200
			if maximumBuyablePokeballs < pokeballToBuy then
				pokeballToBuy = maximumBuyablePokeballs
			end
				return buyItem("Pokeball", pokeballToBuy)
		end
	else
		return moveToArea("Fuchsia City")
	end
end

function SoulBadgeQuest:FuchsiaPokémonMart()
	local pokeballCount = getItemQuantity("Poké Ball")
	local money         = getMoney()
	if money >= 200 and pokeballCount < 50 then
		if not isShopOpen() then
			return talkToNpcOnCell(15,7)
		else
			local pokeballToBuy = 50 - pokeballCount
			local maximumBuyablePokeballs = money / 200
			if maximumBuyablePokeballs < pokeballToBuy then
				pokeballToBuy = maximumBuyablePokeballs
			end
				return buyItem("Poké Ball", pokeballToBuy)
		end
	else
		return moveToCell(9,16)
	end
end

function SoulBadgeQuest:needPokemart_()
	if getItemQuantity("Pokeball") < 50 and getMoney() >= 200 then
		return true
	end
	return false
end

function SoulBadgeQuest:canEnterSafari()
	return getMoney() > 5000	
end

function SoulBadgeQuest:randomZoneExp()
	if self.zoneExp == 1 then
		if game.inRectangle(51,18,55,22) then--Zone 1
			return moveToGrass()
		else
			return moveToCell(53,20)
		end
	elseif self.zoneExp == 2 then
		if game.inRectangle(65,29,70,31) then--Zone 2
			return moveToGrass()
		else
			return moveToCell(68,30)
		end
	elseif self.zoneExp == 3 then
		if game.inRectangle(62,14,66,15) then--Zone 3
			return moveToGrass()
		else
			return moveToCell(64,14)
		end
	else
		if game.inRectangle(89,14,91,18) then--Zone 4
			return moveToGrass()
		else
			return moveToCell(90,16)
		end
	end
end

function SoulBadgeQuest:FuchsiaPokémonCenter()

	self:pokecentercell(102,98)
end 
function SoulBadgeQuest:Route18()
	if  self:canEnterSafari() then
		return moveToArea("Fuchsia City")
	else
		return moveToRectangle(32,19,35,19)
	end
	
end

function SoulBadgeQuest:FuchsiaCity()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
     if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Fuchsia Pokémon Center" then
		return moveToCell(115,98)
	elseif countBadges() < 5	then
		return moveToCell(97,98)
	elseif not self:canEnterSafari() then
		return moveToArea("Route 18")	
	elseif not hasItem("HM03") then
		if not dialogs.questSurfAccept.state then
			return moveToArea("Fuchsia City Stop House")
		else
			return moveToArea("Safari Stop")
		end
	else
		return moveToArea("Fuchsia City Stop House")
	end
end 
end
function SoulBadgeQuest:FuchsiaHouse1()
	if hasItem("Old Rod") and not hasItem("Good Rod") and getMoney() > 15000 then
		return talkToNpcOnCell(3,6)
	else
		return moveToArea("Fuchsia City")
	end
end
function SoulBadgeQuest:SafariStop()
	if self:needPokemart_() then
		self:pokemart_()
	elseif hasItem("Soul Badge") and dialogs.questSurfAccept.state then
		if not hasItem("HM03") and self:canEnterSafari() then
			return talkToNpcOnCell(7,4)
		else
			return moveToArea("Fuchsia City")
		end
	else
		return moveToArea("Fuchsia City")
	end
end
 
function SoulBadgeQuest:Route15StopHouse()
	if game.maxTeamLevel() >= 95  and   hasItem("HM03") then
		return moveToArea("Route 15")
	elseif self:needPokecenter() or not self.registeredPokecenter == "Pokecenter Fuchsia" or ( self:isTrainingOver() and not hasPokemonInTeam("Ditto")) then
		return moveToArea("Fuchsia City")
	elseif hasItem("HM03") then
		return moveToArea("Route 15")
	elseif not self:isTrainingOver() then
		self.zoneExp = math.random(1,4)
		return moveToArea("Route 15")
	else
		return moveToArea("Route 15")
	end
end

function SoulBadgeQuest:FuchsiaCityStopHouse()
	if game.maxTeamLevel() >= 95  and   hasItem("HM03") then
		return moveToArea("Fuchsia City")
	elseif not hasItem("HM03") then
		if dialogs.questSurfAccept.state then
			return moveToArea("Fuchsia City")
		else
			return moveToArea("Route 19")
		end
	else
		return moveToArea("Route 19")
	end
end

function SoulBadgeQuest:Route19()
	if game.maxTeamLevel() >= 95 and   hasItem("HM03")  then
		return moveToArea("Fuchsia City Stop House")
	elseif hasItem("HM03") then
	   if not game.hasPokemonWithMove("Surf") then
			if self.pokemonId <= getTeamSize() then					
				useItemOnPokemon("HM03", self.pokemonId)
				log("Pokemon: " .. self.pokemonId .. " Try Learning: HM03")
				self.pokemonId = self.pokemonId + 1
				return
			
			else
				useItemOnPokemon("HM03", 2)
			end
		else
			return moveToArea("Route 20")
		end
	else
		if dialogs.questSurfAccept.state then
			return moveToArea("Fuchsia City Stop House")
		else
			return talkToNpcOnCell(33,19)
		end
	end
end

function SoulBadgeQuest:Route15()
	if self:needPokecenter() or self:isTrainingOver() or not self.registeredPokecenter == "Pokecenter Fuchsia"  then
		return moveToArea("Route 15 Stop House")
	else
	moveToRectangle(13,24,17,24)
		--return self:randomZoneExp()
	end
end

function SoulBadgeQuest:FuchsiaGym()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
	if countBadges() < 5 then
	 --   
		return talkToNpcOnCell(9,84)
	else
		return moveToCell(9,98)
	end
end
end 

return SoulBadgeQuest