--[[
  Текст в игромов мире:
  DebugDrawText(hero:GetAbsOrigin(), "#addon_game_name", true, 60)
  Консоль:
    DebugPrint("text")
  Сообщение в чат:
    Say(nil,"text", false)
  Сообщение по центру (вверху):
    ShowCenterMessage("text",5);
  Сообщение в поле убийств (слева):
    GameRules:SendCustomMessage("<font color='#58ACFA'>Blue</font> white", 0, 0)
  Всплывающее окно (#popup_title and #popup_body from  addon_english.txt):
    ShowGenericPopup( "#popup_title", "#popup_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
  Текст вверху слева (добавляется/убирается)
    UTIL_MessageTextAll( "Sometextinwhite", 255, 255, 255, 255 )
    UTIL_MessageTextAll_WithContext(string message, int r, int g, int b, int a, table context)
    UTIL_ResetMessageTextAll()
    UTIL_ResetMessageText(int playerId)
  Текст 2д:
  DebugScreenTextPretty(50, 100, 1, "#hellotxt", 214, 237, 201, 255, 60, "Arial", 24, true)
  Уведомление:
  CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {text="#hellotxt", duration=60, class="TitleText", style="TitleText", continue=true} )
  Helpers:
    ShowCenterMessage
    PopupCriticalDamage (http://www.reddit.com/r/Dota2Modding/comments/2fh49i/floating_damage_numbers_and_damage_block_gold/)
]]

--[[
Numbered popup:
ShowPopup( {  Target = keys.caster, 
              PreSymbol = POPUP_SYMBOL_PRE_EVADE, 
              Color = Vector( 255, 255, 0 ), 
              Duration = 2 
          } ) 
]]
  POPUP_SYMBOL_PRE_PLUS = 0 
  POPUP_SYMBOL_PRE_MINUS = 1 
  POPUP_SYMBOL_PRE_SADFACE = 2 
  POPUP_SYMBOL_PRE_BROKENARROW = 3 
  POPUP_SYMBOL_PRE_SHADES = 4 
  POPUP_SYMBOL_PRE_MISS = 5 
  POPUP_SYMBOL_PRE_EVADE = 6 
  POPUP_SYMBOL_PRE_DENY = 7 
  POPUP_SYMBOL_PRE_ARROW = 8 
  POPUP_SYMBOL_POST_EXCLAMATION = 0 
  POPUP_SYMBOL_POST_POINTZERO = 1 
  POPUP_SYMBOL_POST_MEDAL = 2 
  POPUP_SYMBOL_POST_DROP = 3 
  POPUP_SYMBOL_POST_LIGHTNING = 4 
  POPUP_SYMBOL_POST_SKULL = 5 
  POPUP_SYMBOL_POST_EYE = 6 
  POPUP_SYMBOL_POST_SHIELD = 7 
  POPUP_SYMBOL_POST_POINTFIVE = 8 
  function ShowPopup( data ) 
    if not data then return end 
    local target = data.Target or nil 
    if not target then error( "ShowNumber without target" ) end 
    local number = tonumber( data.Number or nil ) 
    local pfx = data.Type or "miss" 
    local color = data.Color or Vector( 255, 255, 255 ) 
    local duration = tonumber( data.Duration or 1 ) 
    local presymbol = tonumber( data.PreSymbol or nil ) 
    local postsymbol = tonumber( data.PostSymbol or nil ) 
    local path = "particles/msg_fx/msg_" .. pfx .. ".vpcf" 
    local particle = ParticleManager:CreateParticle( path, PATTACH_ABSORIGIN_FOLLOW, target ) 
    local digits = 0 
    if number ~= nil then digits = #tostring( number ) end 
    if presymbol ~= nil then digits = digits + 1 end 
    if postsymbol ~= nil then digits = digits + 1 end 
    ParticleManager:SetParticleControl( particle, 1, Vector( presymbol, number, postsymbol ) ) 
    ParticleManager:SetParticleControl( particle, 2, Vector( duration, digits, 0 ) ) 
    ParticleManager:SetParticleControl( particle, 3, color ) 
  end 

function WelcomeHero(hero)
  Say(hero,"<font color='#ffd700'>UP TD</font> v" .. ADDON_VERSION, false)
end

function WelcomeAll()
  Say(nil,"<font color='#00ff00'>Start!</font>", false)
end

function GameInProgressMessage()
  DebugPrint("GameInProgressMessage")
end

function PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target) -- target:GetOwner()

    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end

function PopupCriticalDamage(target, amount)
    PopupNumbers(target, "crit", Vector(255, 0, 0), 1.0, amount, nil, POPUP_SYMBOL_POST_LIGHTNING)
end

function ShowCenterMessage(msg,dur)
  local msg = {
    message = msg,
    duration = dur
  }
  FireGameEvent("show_center_message",msg)
end
