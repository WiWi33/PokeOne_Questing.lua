-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Volcano Badge'
local description = 'Revive Fossil + Secret Key III  + Exp on Seafoam B4F'
local level = 49--49
local dialogs = {
	gymconfirm = Dialog:new({ 
		"Blaine is in the cave in Seafoam Island.",
		"They are building a new gym there."
	}),
}


local VolcanoBadgeQuest = Quest:new()

function VolcanoBadgeQuest:new()
	local o =  Quest.new(VolcanoBadgeQuest, name, description, level, dialogs)
	o.pokemonId = 1
	return o
end

function VolcanoBadgeQuest:isDoable()
	if self:hasMap() then 
		return true
	end
	return false
end

function VolcanoBadgeQuest:isDone()
	if getAreaName() == "Route 21" then
		return true
	end
	return false
end

function VolcanoBadgeQuest:CinnabarPokémonCenter()
	return self:pokecenter("Cinnabar Island")
end

function VolcanoBadgeQuest:CinnabarIsland()
	--if not game.hasPokemonWithMove("Surf") then
		--	if self.pokemonId <= getTeamSize() then					
		--		useItemOnPokemon("HM03 - Surf", self.pokemonId)
		--		log("Pokemon: " .. self.pokemonId .. " Try Learning: HM03 - Surf")
		--		self.pokemonId = self.pokemonId + 1
		--		return
		--	end
	--else
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
	if  self:needPokecenter() or  self.registeredPokecenter ~= "Cinnabar Pokémon Center"  then
	-- if getPlayerX() > 105 then
	--	return moveToCell(105,132)
	--else
		return moveToCell(102,119)
		--end 
	
--	elseif ( getItemQuantity("Elixir") < 10 ) and getMoney() > 15000 then
	--     return moveToArea("Cinnabar Pokemart")
	elseif not hasItem("Secret Key III")  then
		--if isNpcOnCell(18,15) then
		--	return talkToNpcOnCell(18,15)
		--else
			return moveToCell(94,93)
		--end
	elseif  not self:isTrainingOver() then
		return moveToCell(94,93)
	elseif countBadges() < 7 and dialogs.gymconfirm.state == false then
	 -- if getPlayerX() < 125 then
	--	return moveToCell(125,130)
	-- else
	    if isNpcOnCell(128,81) then
	    return talkToNpcOnCell(128,81)
		else 
		return moveToCell(128,81)
	    end
	elseif countBadges() < 7 and dialogs.gymconfirm.state == true then
	    return moveToCell(160,130)
	--elseif hasItem("Dome Fossil") or hasItem("Helix Fossil") then
		--return moveToArea("Cinnabar Lab")
	else
		
			return moveToArea("Route 21")
	end
end
end 

function VolcanoBadgeQuest:PokémonMansion()
 if not hasItem("Secret Key III") then 
	if game.inRectangle(3,12,16,37) then 
	moveToCell(14,14)
	elseif game.inRectangle(19,19,40,37) then
	moveToCell(28,29)
	end 
 else 
  if not self:isTrainingOver() then
   moveToRectangle(8,27,14,30)
  else
    if game.inRectangle(3,12,16,37) then 
	   moveToCell(11,35)
	 elseif game.inRectangle(19,19,40,37) then 
	moveToCell(37,35)
	end 
	end 
 end 
end

function VolcanoBadgeQuest:PokémonMansion2F()
if not hasItem("Secret Key III") then
 if game.inRectangle(3,59,39,95) then 
 if isNpcOnCell(15,64) then 
	talkToNpcOnCell(5,72)
 else 
    
	   moveToCell(13,61)
	end 
	end 
end
end
function VolcanoBadgeQuest:PokémonMansion3F()
if not hasItem("Secret Key III") then
 if game.inRectangle(2,124,39,145) then 
 if isNpcOnCell(19,134) then 
	talkToNpcOnCell(14,128)
 else 
    
	   moveToCell(20,140)
	end 
	end 
end
end

function VolcanoBadgeQuest:PokémonMansionB1F()
if not hasItem("Secret Key III") then
 if isNpcOnCell(15,184) then 
	talkToNpcOnCell(30,178)
 else 
    
	  talkToNpcOnCell(5,182)
	end 
else
  	if not isNpcOnCell(15,184) then 
	talkToNpcOnCell(30,178)
 else 
    
	 moveToCell(42,203)
	end 
end
end
function VolcanoBadgeQuest:CinnabarPokemart()
	if (getItemQuantity("Elixir") < 10 ) and getMoney() > 7500 then
	   if not isShopOpen() then
			return talkToNpcOnCell(3,5)
		else
		    return buyItem("Elixir", 10)
		end
	else
	    return moveToArea("Cinnabar Island")
end
end 
function VolcanoBadgeQuest:CinnabarGym()
	if dialogs.gymconfirm.state == false then
	  if isNpcOnCell(95,9) then 
	 return talkToNpcOnCell(92,10)
	  elseif isNpcOnCell(86,12) then
	return   talkToNpcOnCell(84,2)
		  elseif isNpcOnCell(86,21) then
	return   talkToNpcOnCell(84,13)
	 -- elseif isNpcOnCell(82,28) then 
	 -- return talkToNpcOnCell(83,22)
	  elseif isNpcOnCell(74,21) then
	  return talkToNpcOnCell(71,22)
	  elseif isNpcOnCell(74,12) then 
	  return talkToNpcOnCell(71,13)
	  else
	  return talkToNpcOnCell(74,5)
	  end 
	 else
	 return moveToCell(94,35)
	 end
end

function VolcanoBadgeQuest:CinnabarGymB1F()
	if not hasItem("Volcano Badge") and   game.isTeamFullyHealed() then
		return talkToNpcOnCell(18,16)
	else
		return moveToArea("Cinnabar Gym")
	end
end

--** EXP SECTION **

function VolcanoBadgeQuest:canUseNurse()
	return getMoney() > 1500
end



function VolcanoBadgeQuest:Route20()
	-- if ( hasItem('Good Rod') or hasItem("Old Rod"))  and not hasPokemonInTeam("Magikarp") then
      --     return   useItem('Good Rod') or useItem('Old Rod')
    --else
      --     return moveToArea("Cinnabar Island")
        --end
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
    if countBadges() < 7  then
	    return moveToCell(214,125)
    else 
	   return moveToCell(119,129)
	end 
end 
end


function VolcanoBadgeQuest:SeafoamIslands()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
    if countBadges() < 7  then
	    return moveToCell(14,251)
    else 
	   return moveToCell(10,256)
	end 
end 
end

function VolcanoBadgeQuest:SeafoamGym()
if not isTrainerInfoReceived()   then
           log("getting trainer info")
           return askForTrainerInfo()
else 
    if countBadges() < 7  then
	  if isNpcOnCell(17,353) then
	     return talkToNpcOnCell(17,353)
	  elseif isNpcOnCell(10,353) then 
	  return talkToNpcOnCell(10,353)
	    elseif isNpcOnCell(11,348) then 
	  return talkToNpcOnCell(11,348)
	  else
	    return talkToNpcOnCell(15,348)
		end 
    else 
	   return moveToCell(16,360)
	end 
end 
end



return VolcanoBadgeQuest
