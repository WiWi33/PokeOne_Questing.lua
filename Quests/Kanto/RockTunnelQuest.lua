-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Rock Tunnel'
local description = 'Route 9 to Celadon'
local level = 15

local RockTunnelQuest = Quest:new()

function RockTunnelQuest:new()
	return Quest.new(RockTunnelQuest, name, description, level)
end

function RockTunnelQuest:isDoable()
	if self:hasMap() and not hasItem("Rainbow Badge") then
		return true
	end
	return false
end

function RockTunnelQuest:isDone()
	if getMapName() == "Celadon City" or getMapName() == "Pokecenter Vermilion" then --FIX Blackout if not Route10 or Lavander Pokecenter is Setup
		return true
	else
		return false
	end
end

function RockTunnelQuest:Route9()
if game.inRectangle(204,104,215,109) and isNpcOnCell(212,109) then
    return talkToNpcOnCell(212,109)
	elseif isNpcOnCell(222,137) then 
	    return talkToNpcOnCell(222,137)  -- rare candy
		elseif isNpcOnCell(222,142) then 
	    return talkToNpcOnCell(222,142)  --  super potion
				elseif isNpcOnCell(267,137) then 
	    return talkToNpcOnCell(267,137)  -- chestos berry
		elseif isNpcOnCell(309,139) then 
	    return talkToNpcOnCell(309,139)  --  persism berry
				elseif isNpcOnCell(317,147) then 
	    return talkToNpcOnCell(317,147)  --  panab berry
else
	return moveToCell(315,154)
end
end 

function RockTunnelQuest:Route10()
	if game.inRectangle(297,151,322,170) then
		if self:needPokecenter() or not game.isTeamFullyHealed() then
			return moveToCell(308,161)
		else
			return moveToCell(301,157)
		end
	else
		return moveToCell(120,110)
	end
end

function RockTunnelQuest:RockTunnelPok√©monCenter()
if self:needPokecenter() or not game.isTeamFullyHealed() then
	self:pokecenter("Route 10")
else 
   moveToCell(18,33)
end 
end

function RockTunnelQuest:RockTunnel()
	if game.inRectangle(43,14,58,27) then
	   if self:needPokecenter() or not game.isTeamFullyHealed() then
	   return moveToCell(56,19)
	   --elseif isNpcOnCell(41,27) then 
	  -- return talkToNpcOnCell(41,27)
	   else
		return moveToCell(47,25)
	  end 
	elseif game.inRectangle(1,59,59,76) then
	  if isNpcOnCell(16,67) then 
	   talkToNpcOnCell(16,67)
	  else 
		return moveToCell(17,62)
		end 
	elseif game.inRectangle(15,14,42,30) then
	   if isNpcOnCell(42,19) then 
	    return talkToNpcOnCell(42,19)
		else
		return moveToCell(20,26) 
		end
	elseif game.inRectangle(14,72,38,93) then 
	  return moveToCell(17,91)
	  else 
	  moveToCexl(33,46)
	end
end



function RockTunnelQuest:LavenderTown()
    if self:needPokecenter() or not game.isTeamFullyHealed() then
		return moveToCell(115,116)

	else 
		return moveToArea("Route 8")
	end
end

function RockTunnelQuest:PokecenterLavender()
	self:pokecenter("Lavender Town")
end

function RockTunnelQuest:Route8()
	if isNpcOnCell(56,3) then -- Item: Leppa Berry
		return talkToNpcOnCell(56,3)
	elseif isNpcOnCell(57,3) then -- Item: Leppa Berry
		return talkToNpcOnCell(57,3)
	elseif isNpcOnCell(52,9) then --Pokemon: Growlithe LvL 10 (BlueBall)
		return talkToNpcOnCell(52,9)
	elseif isNpcOnCell(17,3) then  -- Item: Rawst Berry
		return talkToNpcOnCell(17,3)
	elseif isNpcOnCell(18,3) then  -- Item: Lum Berry
		return talkToNpcOnCell(18,3)
	elseif isNpcOnCell(18,3) then  -- Item: Perism Berry
		return talkToNpcOnCell(18,3)
	else
		return moveToArea("Underground House 4")
	end
end

function RockTunnelQuest:UndergroundHouse4()
	return moveToArea("Underground1")
end

function RockTunnelQuest:Underground1()
	return moveToArea("Underground House 3")
end

function RockTunnelQuest:UndergroundHouse3()
	return moveToArea("Route 7")
end

function RockTunnelQuest:Route7()
	if isNpcOnCell(8,30) then -- Item: Sitrus Berry
		return talkToNpcOnCell(8,30)
	else
		return moveToArea("Celadon City")
	end
end

return RockTunnelQuest