function tp1(event)
    print( "tp1 : " .. event.activator:GetClassname() )
    Say(nil,"tp1", false)
end

function resolve_teleport(event)
     local teleport_tbl = {} -- teleport name to entity name connections 
     -- Radiant
     teleport_tbl["tr10"] = "tr11"
     teleport_tbl["tr20"] = "tr21"
     teleport_tbl["tr30"] = "tr31"
     teleport_tbl["tr40"] = "tr41"
     teleport_tbl["tr11"] = "tr10"
     teleport_tbl["tr21"] = "tr20"
     teleport_tbl["tr31"] = "tr30"
     teleport_tbl["tr41"] = "tr40"
     -- Dire
     teleport_tbl["td10"] = "td11"
     teleport_tbl["td20"] = "td21"
     teleport_tbl["td30"] = "td31"
     teleport_tbl["td40"] = "td41"
     teleport_tbl["td11"] = "td10"
     teleport_tbl["td21"] = "td20"
     teleport_tbl["td31"] = "td30"
     teleport_tbl["td41"] = "td40"
     local unit = event.activator
     local wws= teleport_tbl[event.caller:GetName()] -- вот та сама точка, куда мы будем телепортировать героя, мы её указали в скрипте
     local ent = Entities:FindByName( nil, wws)
     unit:AddNewModifier(unit, nil, "modifier_bottle_regeneration", nil)
     Timers:CreateTimer({
        useGameTime = true,
        endTime = 3,
        callback = function()
            unit:RemoveModifierByName("modifier_bottle_regeneration")
            if (not event.caller:IsTouching(unit)) then 
                return nil 
            end
            local point = ent:GetAbsOrigin()+RandomVector(RandomFloat(150,200))
            event.activator:SetAbsOrigin( point )
            FindClearSpaceForUnit(event.activator, point, false) --нужно чтобы герой не застрял
            event.activator:Stop() --приказываем ему остановиться, иначе он побежит назад к предыдущей точке
            return nil
        end})
     print( "teleport_tbl : event.activator:GetClassname()" .. event.activator:GetClassname() )
     print( "teleport_tbl event.caller:GetClassname(): " .. event.caller:GetClassname() )
     --Say(nil,"teleported", false)
end

function resolve_wave(event)
     local unit = event.activator
     local callerName = event.caller:GetName()
     if (callerName == "rad_end_easy" or callerName == "rad_end_base") then
        if(unit:GetTeamNumber() == DOTA_TEAM_BADGUYS and unit:FindAbilityByName("ability_building")==nil and unit::GetPlayerOwner()==nil) then
            event.activator:Stop()
            RADIANT_LIFES = RADIANT_LIFES - 1
            LOST_LEFES_RAD_RESET = LOST_LEFES_RAD_RESET - 1
            for i=1,#radPID do
                if(radPID[i]~=nil and PlayerResource:GetPlayer(radPID[i])~=nil) then ModifyLifes( PlayerResource:GetPlayer(radPID[i]), -1 ) end
            end
            ShowCenterMessage("Radiant lost life! Lifes: ".. RADIANT_LIFES, 1);
            --Say(nil,"<font color='#ff0000'>Radiant</font> lost life! Remaining: ".. RADIANT_LIFES, false)
            if (RADIANT_LIFES <= 0) then
                GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
            end
            event.activator:Kill(nil,event.activator)
        end
     end
     if (callerName == "dire_end_easy" or callerName == "dire_end_base") then
        if(unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and unit:FindAbilityByName("ability_building")==nil and unit::GetPlayerOwner()==nil ) then
            event.activator:Stop()
            DIRE_LIFES = DIRE_LIFES - 1
            LOST_LEFES_DIRE_RESET = LOST_LEFES_DIRE_RESET - 1
            for i=1,#direPID do
                if(direPID[i]~=nil and PlayerResource:GetPlayer(direPID[i])~=nil) then ModifyLifes( PlayerResource:GetPlayer(direPID[i]), -1 ) end
            end
            ShowCenterMessage("Dire lost life! Lifes: ".. DIRE_LIFES,1);
            --Say(nil,"<font color='#ff0000'>Dire</font> lost life! Remaining: ".. DIRE_LIFES, false)
            if (DIRE_LIFES <= 0) then
                GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
            end
            event.activator:Kill(nil,event.activator)
        end
     end
    for i=1,#direPID do
        if(direPID[i]~=nil and PlayerResource:GetPlayer(direPID[i])~=nil) then updateStatGUI( PlayerResource:GetPlayer(direPID[i]), RADIANT_LIFES, DIRE_LIFES ) end
    end
    for i=1,#radPID do
        if(radPID[i]~=nil and PlayerResource:GetPlayer(radPID[i])~=nil) then updateStatGUI( PlayerResource:GetPlayer(radPID[i]), RADIANT_LIFES, DIRE_LIFES ) end
    end
     --print( "resolve_wave : event.activator:GetClassname()" .. event.activator:GetClassname() )
     --print( "resolve_wave event.caller:GetName(): " .. event.caller:GetName() )
end