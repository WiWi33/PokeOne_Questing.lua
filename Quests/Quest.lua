	-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys  = require "Libs/syslib"
local game = require "Libs/gamelib"
local blacklist = require "blacklist"

local Quest = {}


function Quest:new(name, description, level, dialogs)
	local o = {}
	setmetatable(o, self)
	self.__index     = self
	o.name        = name
	o.description = description
	o.level       = level or 1
	o.dialogs     = dialogs
	o.state       = true
	o.training    = true
	return o
end

function Quest:isDoable()
	sys.error("Quest:isDoable", "function is not overloaded in quest: " .. self.name)
	return nil
end

function Quest:isDone()
	return self:isDoable() == false
end

function Quest:mapToFunction()
	local mapName = getAreaName()
	local mapFunction = sys.removeCharacter(mapName, ' ')
	mapFunction = sys.removeCharacter(mapFunction, '.')
	mapFunction = sys.removeCharacter(mapFunction, '-')
	mapFunction = sys.removeCharacter(mapFunction, "'") -- Map "Fisherman House - Vermilion"
	return mapFunction
end

function Quest:hasMap()
	local mapFunction = self:mapToFunction()
	if self[mapFunction] then
		return true
	end
	return false
end
local  fireStoneTargets = {
 "Growlithe"
 }
function Quest:evolvePokemon()
	if getTeamSize() >0  then   
	local hasFireStone = hasItem("Fire Stone")
	for pokemonId=1, getTeamSize(), 1 do
		local pokemonName = getPokemonName(pokemonId)
		if hasFireStone and game.minTeamLevel() > 95 and getTeamSize() > 0
			and sys.tableHasValue(fireStoneTargets, pokemonName)
		then
			return useItemOnPokemon("Fire Stone", pokemonId)
		end
	end
	return false
	end 
end
function Quest:pokecenter(exitMapName) -- idealy make it work without exitMapName
	self.registeredPokecenter = getAreaName()
	sys.todo("add a moveDown() or moveToNearestLink() or getLinks() to PROShine")
	if not game.isTeamFullyHealed() then
		return usePokecenter()
	else 
	 return   moveToNearestLink()
	end
end

function Quest:pokecentercell(cellX,cellY) -- idealy make it work without exitMapName
	self.registeredPokecenter = getAreaName()
	sys.todo("add a moveDown() or moveToNearestLink() or getLinks() to PROShine")
	if not game.isTeamFullyHealed() then
		return usePokecenter()
	else
	  return moveToCell(cellX,cellY)
	end
end

-- at a point in the game we'll always need to buy the same things
-- use this function then
function Quest:pokemart(x,y,npcx,npcy)
	local pokeballCount = getItemQuantity("Poké Ball")
	local money         = getMoney()
	if money >= 200 and pokeballCount < 10 then
		if not isShopOpen() then
			return talkToNpcOnCell(npcx,npcy)
		else
			local pokeballToBuy = 10 - pokeballCount
			local maximumBuyablePokeballs = money / 200
			if maximumBuyablePokeballs < pokeballToBuy then
				pokeballToBuy = maximumBuyablePokeballs
			end
			return buyItem("Poké Ball", pokeballToBuy)
		
		end
	elseif isShopOpen() then 
	    return closeShop()
	else
		return moveToCell(x,y)
	end
end

function Quest:pokemart(npcx,npcy)
	local pokeballCount = getItemQuantity("Poké Ball")
	local money         = getMoney()
	if money >= 200 and pokeballCount < 10 then
		if not isShopOpen() then
			return talkToNpcOnCell(npcx,npcy)
		else
			local pokeballToBuy = 20 - pokeballCount
			local maximumBuyablePokeballs = money / 200
			if maximumBuyablePokeballs < pokeballToBuy then
				pokeballToBuy = maximumBuyablePokeballs
			end
			return buyItem("Poké Ball", pokeballToBuy)
		
		end
	elseif isShopOpen() then 
	    return closeShop()
	else
		return moveToNearestLink()
	end
end

function Quest:pokemartrepel(npcx,npcy)
	local pokeballCount = getItemQuantity("Max Repel")
	local money         = getMoney()
	if money >= 200 and pokeballCount < 1 then
		if not isShopOpen() then
			return talkToNpcOnCell(npcx,npcy)
		else
			local pokeballToBuy = 1 - pokeballCount
			local maximumBuyablePokeballs = money / 700
			if maximumBuyablePokeballs < pokeballToBuy then
				pokeballToBuy = maximumBuyablePokeballs
			end
			return buyItem("Max Repel", pokeballToBuy)
		
		end
	elseif isShopOpen() then 
	    return closeShop()
	else
		return moveToNearestLink()
	end
end
function Quest:isTrainingOver()
	if game.maxTeamLevel() >= self.level then
		if self.training then -- end the training
			self:stopTraining()
		end
		return true
	end
	return false
end


function Quest:startTraining()
	self.training = true
end

function Quest:stopTraining()
	self.training = false
	self.healPokemonOnceTrainingIsOver = true
end

function Quest:needPokemart()
	-- TODO: ItemManager
	if getItemQuantity("Poké ball") < 10 and getMoney() >= 200 then
		return true
	end
	return false
end


function Quest:askPlayerStats()
	if not isTrainerInfoReceived() then
           log("getting trainer info")
           return askForTrainerInfo()
	end
	-- body
end
function Quest:useBikeAndOtherStuffs()
 for i=1,getTeamSize() do
	if getPokemonName(i) == "Blastoise"  and getPokemonCollectedEffortValue(i, "Def") > 0 
	        and  getPokemonEffortValue(i,"Def") ~=  getPokemonCollectedEffortValue(i, "Def")  then
	   return  setCollectedEffortValue(i, "Def", getPokemonCollectedEffortValue(i, "Def"))
	elseif 	 getPokemonName(i) == "Blastoise" and getPokemonCollectedEffortValue(i, "Spdef") > 0 
	        and  getPokemonEffortValue(i,"Spdef") ~=  getPokemonCollectedEffortValue(i, "Spdef")  then
	   return  setCollectedEffortValue(i, "Spdef", getPokemonCollectedEffortValue(i, "Spdef"))
	end 
 end 
end


function Quest:needPokecenter()

	if getTeamSize() == 1 then
		
			return false

	-- else we would spend more time evolving the higher level ones
	
	else
		if not game.isTeamFullyHealed() then
			if self.healPokemonOnceTrainingIsOver then
				return true
			end
		else
			-- the team is healed and we do not need training
			self.healPokemonOnceTrainingIsOver = false
		end
	end
	return false
end

function Quest:message()
	return self.name .. ': ' .. self.description
end

-- I'll need a TeamManager class very soon


function Quest:advanceSorting()
	local pokemonsUsable = game.getTotalUsablePokemonCount()
	
	
		 if hasPokemonInTeam("Squirtle")  and  not hasItem("Soul Badge") and not hasItem("HM03 - Surf")  then
		for i=1,getTeamSize() do 
				   if  getPokemonName(i) == "Squirtle" and isPokemonUsable(i) then 
				        return swapPokemon(1,i)
					end
				end
	end
	
		 if hasPokemonInTeam("Bulbasaur")  and  not hasItem("Soul Badge") and not hasItem("HM03 - Surf")  then
		for i=1,getTeamSize() do 
				   if  getPokemonName(i) == "Bulbasaur" and isPokemonUsable(i) then 
				        return swapPokemon(1,i)
					end
				end
	end
	
		 if hasPokemonInTeam("Charmander")  and  not hasItem("Soul Badge") and not hasItem("HM03 - Surf")  then
		for i=1,getTeamSize() do 
				   if  getPokemonName(i) == "Charmander" and isPokemonUsable(i) then 
				        return swapPokemon(1,i)
					end
				end
	end
	if  game.maxTeamLevel() - game.minTeamLevel() > 15  and game.maxTeamLevel() < self.level then 
	return sortTeamRangeByLevelAscending(1, pokemonsUsable)
	end 
	return sortTeamRangeByLevelDescending(1, pokemonsUsable)
end


function Quest:path()
	if self.inBattle then
		self.inBattle = false
		self:battleEnd()
	end
	if self:useBikeAndOtherStuffs() then	
		return true
	end
	if self:advanceSorting() then --or self:askPlayerStats() then
		return true
	end
	local mapFunction = self:mapToFunction()
	assert(self[mapFunction] ~= nil, self.name .. " quest has no method for map: " .. getAreaName())
	self[mapFunction](self)
end



function Quest:isPokemonBlacklisted(pokemonName)
	return sys.tableHasValue(blacklist, pokemonName)
end

function Quest:battleBegin()
	self.canRun = true
end

function Quest:battleEnd()
	self.canRun = true
end

-- I'll need a TeamManager class very soon
local blackListTargets = { --it will kill this targets instead catch
	 "Caterpie",     
	 "Metapod",      
	 "Butterfree",   
	 "Weedle",       
	 "Kakuna",       
	 "Beedrill",            
	 "Pidgeotto",    
	 "Pidgeot",
     "Pidgey",
     "Zubat",
     "HootHoot",	 
	 "Ekans",     
	 "Arbok",            
	 "Raichu",         
	 "Nidoran F",    
	 "Nidorina",     
	 "Nidoqueen",    
	 "Nidoran M",    
	 "Nidorino",     
	 "Nidoking",          
	 "Clefable",       
	 "Ninetales",    
	 "Jigglypuff",           
	 "Onix",    
	 "Abra",    
	 "Spinarak",  
	 "Dodrio",  
	 "Zigzagoon",
	 "Diglett",
	 "Magnemite",
	 "Clefairy",
	 "Hypno",
	 "Spearow",
	 "Drowzee",
}

function Quest:wildBattle()
if getTeamSize() >0 then
if getAreaName() == "Mt. Moon"  and game.inRectangle(98,39,103,40)  then -- we need to train if lose jessie and james  so that's it
return attack()  or sendUsablePokemon()  or sendAnyPokemon() or run() 
end
if hasItem("Safari Ball") then 
if useItem("Safari Ball") or useItem("Great Ball") or useItem("Poké Ball") or useItem("Luxury Ball") or sendUsablePokemon() or run() or sendAnyPokemon() then
			return true
		end
end 
if ( getAreaName() == "Rock Tunnel" or getAreaName() == "Mt. Moon"
 or getAreaName() == "Mt. Moon B1F" or getAreaName() == "Diglett's Cave" 
 or getAreaName() == "Seafoam B4F" or getAreaName() == "Route 23"
or getAreaName() == "Victory Road 1F" ) and getPokemonLevel(1) == game.maxTeamLevel()   then  
     return run()  or sendUsablePokemon()  or sendAnyPokemon() or attack()
end	
 
if isOpponentShiny()   then -- formal catch
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Poké Ball") or useItem("Luxury Ball") or sendUsablePokemon() or run() or sendAnyPokemon() then
			return true
		end
end


   if  not isAlreadyCaught()  and getTeamSize() < 6--and getPokedexOwned() < 11 
  and getOpponentLevel() > 5
 and not sys.tableHasValue(blackListTargets, getOpponentName())  and hasItem("Poké Ball")    then 
   return useItem("Poké Ball")   or sendUsablePokemon() or run() or sendAnyPokemon()
 -- else
 --  return attack() or useAnyMove()  or sendAnyPokemon()  or run()
  end 
	


--if (getPokemonLevel(1) - 55 < getOpponentLevel()  ) and getPokemonName(1) == "Magikarp"  then
	--	local opponentLevel = getOpponentLevel()
	--	local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
	---	if opponentLevel >= (myPokemonLvl - 55) and getPokemonName(getActivePokemonNumber()) == "Magikarp" then
	--		local requestedId, requestedLevel = game.getMaxLevelUsablePokemon()
	---		if requestedId ~= nil and (requestedLevel >  (myPokemonLvl - 55) ) then
	---			return sendPokemon(requestedId)
	--		end
	--	end
--end

if getPokemonLevel(1) < getOpponentLevel() then
		local opponentLevel = getOpponentLevel()
		local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
		if opponentLevel >= myPokemonLvl then
		local requestedId, requestedLevel = game.getMaxLevelUsablePokemon()
		if requestedId ~= nil and requestedLevel > myPokemonLvl then
			return sendPokemon(requestedId)
			end
		else 
		   return attack() or useAnyMove()  or sendAnyPokemon()  or run()
		end
	end

--else 

return attack()  or useAnyMove() or run() or sendUsablePokemon() or sendAnyPokemon()  
end 
end
function Quest:trainerBattle()
   -- if getAreaName() == "Saffron Gym" and game.inRectangle(149,50,157,58) then 
	--return useMove("Dragon Rage") or  attack() or useAnyMove() or sendUsablePokemon() or sendAnyPokemon()   
	--end 
	if  sys.canSwitch  == false then 
	return game.useAnyMove()
	end
	if not self.canRun then -- trying to switch while a pokemon is squeezed end up in an infinity loop
		return  attack() or game.useAnyMove()
	else
	return  attack() or sendUsablePokemon()  or useAnyMove() or sendAnyPokemon()   
	end
	
end

function Quest:battle()
	if not self.inBattle then
		self.inBattle = true
		self:battleBegin()
	end
--	if self:askPlayerStats() then
	--	return true
---	end
	if isWildBattle() then
		return self:wildBattle()
	else
		return self:trainerBattle()
	end
end

function Quest:dialog(message)
	if self.dialogs == nil then
		return false
	end
	for _, dialog in pairs(self.dialogs) do
		if dialog:messageMatch(message) then
			dialog.state = true
			return true
		end
	end
	return false
end

function Quest:battleMessage(message)
sys.canSwitch  = true
sys.slakingSleep = false 
	if sys.stringContains(message, "You can not run away!") then
		sys.canRun = false
	elseif stringContains(message,"Slaking is loafing around") then
	    sys.slakingSleep = true 
	elseif self.pokemon ~= nil and self.forceCaught ~= nil then
		if sys.stringContains(message, "caught") and sys.stringContains(message, self.pokemon) then --Force caught the specified pokemon on quest 1time
			log("Selected Pokemon: " .. self.pokemon .. " is Caught")
			self.forceCaught = true
			return true
		end
	elseif sys.stringContains(message, "You have lost the battle!") and self.level < 97 and self:isTrainingOver() then
		self.level = self.level + 1
		self:startTraining()
		log("Increasing " .. self.name .. " quest level to " .. self.level .. ". Training time!")
		return true
	elseif sys.stringContains(message, "You can not switch this Pokemon!") then
	 sys.canSwitch  = false 
     end
	return false
end

function Quest:systemMessage(message)	
	return false
end

local hmMoves = {
	"Cut",
	"Surf",
	"Flash"
}
function Quest:learningMove(moveName, pokemonIndex)
if getTeamSize() > 0 then 

	return forgetAnyMoveExcept({"Dig","Aqua Tail","Headbutt","Confusion", "Shadow Ball","Water Pulse", 
	"Dark Pulse", "Surf", "Hex", "Air Slash", "Cut", "Acrobatics", "Poison Fang","Thunder Fang", "Thunderbolt", 
    "Sleep Powder",  "Petal Dance","Dragon Rage","Spark","Signal Beam","Ice Fang","Earthquake","Water Gun","Slash","Scald",
	"Discharge","Electro Ball","Rock Smash","Surf","Dig","Dive","Sucker Punch","Play Rough","Earthquake",
    "Covet", "Shadow Ball", "Shadow Claw", "Blaze Kick", "Dragon Claw", "Psychic", "Night Slash",
	"X-Scissor", "Razor Wind", "Ice Beam", "Megahorn", "Wild charge", "Crunch", "Air Slash", "FlameThrower", "Poison Jab",
	"Ice Fang", "Thunder Fang", "Fire Fang", "Play Rough", "Bite", "Covet", "Low Kick", "Quick Attack", "Ice Punch", "Thunder Punch", "Fire Punch",
	"Sky Uppercut", "Thunderbolt", "Thunder", "Thrash", "Horn Attack", "Nuzzle", "HeadButt", "False Swipe", "Fire Blast","Rock Smash"}) 
end 
end 
return Quest
