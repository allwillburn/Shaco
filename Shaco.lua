local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Shaco" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Shaco/master/Shaco.lua', SCRIPT_PATH .. 'Shaco.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Shaco/master/Shaco.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local ShacoMenu = Menu("Shaco", "Shaco")

ShacoMenu:SubMenu("Combo", "Combo")

ShacoMenu.Combo:Boolean("Q", "Use Q in combo", true)
ShacoMenu.Combo:Boolean("W", "Use W in combo", true)
ShacoMenu.Combo:Boolean("E", "Use E in combo", true)
ShacoMenu.Combo:Boolean("R", "Use R in combo", true)
ShacoMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
ShacoMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
ShacoMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
ShacoMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
ShacoMenu.Combo:Boolean("RHydra", "Use RHydra", true)
ShacoMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
ShacoMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
ShacoMenu.Combo:Boolean("Randuins", "Use Randuins", true)


ShacoMenu:SubMenu("AutoMode", "AutoMode")
ShacoMenu.AutoMode:Boolean("Level", "Auto level spells", false)
ShacoMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
ShacoMenu.AutoMode:Boolean("Q", "Auto Q", false)
ShacoMenu.AutoMode:Boolean("W", "Auto W", false)
ShacoMenu.AutoMode:Boolean("E", "Auto E", false)
ShacoMenu.AutoMode:Boolean("R", "Auto R", false)

ShacoMenu:SubMenu("LaneClear", "LaneClear")
ShacoMenu.LaneClear:Boolean("Q", "Use Q", true)
ShacoMenu.LaneClear:Boolean("W", "Use W", true)
ShacoMenu.LaneClear:Boolean("E", "Use E", true)
ShacoMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
ShacoMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

ShacoMenu:SubMenu("Harass", "Harass")
ShacoMenu.Harass:Boolean("Q", "Use Q", true)
ShacoMenu.Harass:Boolean("W", "Use W", true)

ShacoMenu:SubMenu("KillSteal", "KillSteal")
ShacoMenu.KillSteal:Boolean("Q", "KS w Q", true)
ShacoMenu.KillSteal:Boolean("E", "KS w E", true)

ShacoMenu:SubMenu("AutoIgnite", "AutoIgnite")
ShacoMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

ShacoMenu:SubMenu("Drawings", "Drawings")
ShacoMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

ShacoMenu:SubMenu("SkinChanger", "SkinChanger")
ShacoMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
ShacoMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if ShacoMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if ShacoMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 400) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end

            if ShacoMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastTargetSpell(target, _W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if ShacoMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if ShacoMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if ShacoMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if ShacoMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if ShacoMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
			CastTargetSpell(target, _E)
	    end

            if ShacoMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 400) then
		     if target ~= nil then 
                         CastTargetSpell(_Q,target)
                     end
            end

            if ShacoMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if ShacoMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if ShacoMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if ShacoMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then
			CastTargetSpell(_W,target)
	    end
	    
	    
            if ShacoMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 700) and (EnemiesAround(myHeroPos(), 700) >= ShacoMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 400) and ShacoMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and ShacoMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(target, _E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if ShacoMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 400) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if ShacoMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 700) then
	        	CastTargetSpell(target, _W)
	        end

                if ShacoMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastTargetSpell(target, _E)
	        end

                if ShacoMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if ShacoMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if ShacoMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 400) then
		      CastTargetSpell(target, _Q)
          end
        end 
        if ShacoMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 700) then
	  	      CastTargetSpell(target, _W)
          end
        end
        if ShacoMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 125) then
		      CastTargetSpell(target, _E)
	  end
        end
        if ShacoMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if ShacoMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if ShacoMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 400, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("Shacoempowertwo") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if ShacoMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Shaco</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





