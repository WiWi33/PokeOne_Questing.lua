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
local level = 48

local dialogs = {
	questSurfAccept = Dialog:new({ 
		"There is something there I want you to take",
		"Did you get the HM broseph"
	}),
	questRockSmash = Dialog:new({ 
		"Hif fuff hefifoo!",
		"Ha lof ha feef ee hafahi ho."
	}),
}

local SoulBadgeQuest = Quest:new()

function SoulBadgeQuest:new()
	local o = Quest.new(SoulBadgeQuest, name, description, level, dialogs)
	o.zoneExp = 1
	o.pokemonId = 1
	o.nosurf = false
	return o
end

function SoulBadgeQuest:isDoable()	
	if self:hasMap() and not hasItem("Secret Key III")  then
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
	if   getAreaName()== "Cinnabar Pokémon Center" then
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
 if hasItem("HM03") and getTeamSize() == 6 then 
       if not game.hasPokemonWithMove("Surf") then
			if self.pokemonId <= getTeamSize() then					
				useItemOnPokemon("HM03", self.pokemonId)
				log("Pokemon: " .. self.pokemonId .. " Try Learning: HM03 - Surf")
				self.pokemonId = self.pokemonId + 1
				return
			else
				 if isPCOpen() then
				    self.nosurf = true
                    return depositPokemonToPC(6)
                 else 
                     return usePC()
                 end
			end
		else
			 self:pokecentercell(102,98)
		end 
 else 
	self:pokecentercell(102,98)
 end 
end 
function SoulBadgeQuest:Route18()
	if  self:canEnterSafari() then
		return moveToArea("Fuchsia City")
	else
		return moveToRectangle(32,19,35,19)
	end
	
end

function SoulBadgeQuest:FuchsiaCity()
self.pokemonId = 1
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
  if game.inRectangle(63,41,77,52) then
       if (not dialogs.questRockSmash.state or hasItem("Gold Teeth")) and not hasItem("HM06") then
			return talkToNpcOnCell(68,47)
		else
			return moveToNearestLink()
		end
  elseif  game.inRectangle(95,43,107,54) then
       if not hasItem("Good Rod") then
			return talkToNpcOnCell(105,46)
		else
			return moveToCell(99,52)
		end
  else 
     if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Fuchsia Pokémon Center" then
		return moveToCell(115,98)
	elseif not hasItem("Good Rod") then 
	    return moveToCell(141,93)
	elseif countBadges() < 6	then
		return moveToCell(97,98)
	elseif not self:canEnterSafari() then
		return moveToArea("Route 18")	
	elseif not hasItem("HM06") then
		if not dialogs.questRockSmash.state or hasItem("Gold Teeth") then
			return moveToCell(134,93)
		else
			return moveToCell(121,51)
		end
    elseif  not game.hasPokemonWithMove("Surf") and getTeamSize() == 6 and hasItem("HM03") then
	    return moveToCell(115,98)
	else
		return moveToCell(108,118)
	end
   end 
end 
end
function SoulBadgeQuest:FuchsiaCityGate()
	if  not game.hasPokemonWithMove("Surf") and getTeamSize() == 6 and hasItem("HM03") then
		return moveToCell(73,134)
	else
		return moveToCell(73,147) --73,134
	end
end
function SoulBadgeQuest:SafariGate()

    if getPlayerY() > 15  then 
		if not hasItem("HM03") and self:canEnterSafari() then
			return talkToNpcOnCell(36,15)
		else
			return moveToCell(33,24)
		end
    else 
	    if  hasItem("HM03") and self:canEnterSafari() then
			return talkToNpcOnCell(36,15)
		else
			return moveToCell(33,11)
		end
	end 
 end 
function SoulBadgeQuest:KantoSafariZone()
 if game.inRectangle(123,125,155,150) or game.inRectangle(144,112,155,124) or game.inRectangle(144,112,170,113) then 
	if not  hasItem("HM03") then
		 return moveToCell(169,113)
	else
		return moveToCell(126,148)
	end
end 
end

function SoulBadgeQuest:KantoSafariZoneEast()
	if not  hasItem("HM03") then
	      if getPlayerX() < 162 then 
	      return  moveToCell(182,113)
		  elseif game.inRectangle(178,104,194,118) then 
		  return moveToCell(177,110)
		  elseif getPlayerY() > 100 then 
		   return moveToCell(166,100)
		  else 
		 return moveToCell(151,67)
		 end 
		 
	else
		return moveToCell(160,113)
	end
end

function SoulBadgeQuest:CinnabarIsland()
	moveToCell(102,119)
end

function SoulBadgeQuest:KantoSafariZoneNorth()
	if not  hasItem("Gold Teeth") then
		 return moveToCell(83,73)
    elseif not hasItem("HM03") then 
	  if getPlayerX() > 76 and getPlayerY() > 40 then 
	  return moveToCell(87,40)
	  else 
	  return moveToCell(40,74)
	  end
	else
		return moveToCell(160,113)
	end
end

function SoulBadgeQuest:KantoSafariZoneWest()
	if not  hasItem("Gold Teeth") then
		 return talkToNpcOnCell(52,107)
	    elseif not hasItem("HM03") then 
	  return moveToCell(40,74)
	   elseif  hasItem("HM03") then 
	  return moveToGrass()
	else
		return moveToCell(83,67)
	end
end

function SoulBadgeQuest:SecretHouse()
	if  not hasItem("HM03") then --isNpcOnCell(10,80) then
		 return talkToNpcOnCell(10,80)
	 
	else
		return moveToCell(10,85)
	end
end

function SoulBadgeQuest:FuchsiaCityStopHouse()
	if not hasItem("HM03") then
	   return moveToCell(169,113)
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

if  not game.hasPokemonWithMove("Surf") then 
    if getTeamSize() < 6 then
	    if  getPlayerX() != 284 and getPlayerY() != 90 then
			return moveToCell(284,90)
		else
			return useItem("Super Rod")
		end
	else
			return moveToCell(287,74)
	end
else 
moveToCell(263,111)
end 

end 

function SoulBadgeQuest:Route20()
if game.inRectangle(206,125,225,135) or  game.inRectangle(184,128,206,141) or   getPlayerX() < 183 then
   moveToCell(110,125)
else
 moveToCell(199,118)
 end
end

function SoulBadgeQuest:SeafoamIslands()
if game.inRectangle(27,290,40,303) then 

 moveToCell(35,296)
 else 
 moveToCell(10,256)
 end 
end
function SoulBadgeQuest:SeafoamIslandsB1F()
if not game.hasPokemonWithMove("Rock Smash") then
			if self.pokemonId <= getTeamSize() then					
				useItemOnPokemon("HM06", self.pokemonId)
				log("Pokemon: " .. self.pokemonId .. " Try Learning: HM06 - Rock Smash")
				self.pokemonId = self.pokemonId + 1
				return
			else
				fatal("no pokemon can learn rock smash")
			end
elseif isNpcOnCell(14,16) then 
			 talkToNpcOnCell(14,16)
			 else
			 moveToCell(49,24)
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
	if countBadges() < 6 then
	 --   
		return talkToNpcOnCell(9,84)
	else
		return moveToCell(9,98)
	end
end
end 

return SoulBadgeQuest