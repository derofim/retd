function tp3(event)
     local unit = event.activator
     local  wws= "pnt1" -- вот та сама точка, куда мы будем телепортировать героя, мы её указали в скрипте

     local ent = Entities:FindByName( nil, wws) --строка ищет как раз таки нашу точку pnt1
     local point = ent:GetAbsOrigin() --эта строка выясняет где находится pnt1 и получает её координаты
     event.activator:SetAbsOrigin( point ) -- получили координаты, теперь меняем место героя на pnt1
     FindClearSpaceForUnit(event.activator, point, false) --нужно чтобы герой не застрял
     event.activator:Stop() --приказываем ему остановиться, иначе он побежит назад к предыдущей точке
             print( "tp3 : " .. event.activator:GetClassname() )
       Say(nil,"tp3", false)
end

function PassCorner(trigger)
        print("===============trigger.activator===============")
        -- local target = data.caller
        print(trigger.activator)
        print(trigger.caller)
        print( "OnStartTouch : " .. trigger.activator:GetClassname() )
       Say(nil,"text", false)
end