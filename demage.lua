local dm = {}
dm.Menu = {"Awareness", "Damage Informer"}
dm.Enable = Menu.AddOptionBool(dm.Menu, "Enable", false)

dm.fontItem = Renderer.LoadFont("Arial", 18, Enum.FontWeight.EXTRABOLD)
local kol_udar = 0
local myHero
local enemy
local name
local x = 791
local y = 92
local speed
local kol_udar_super = 0
function dm.OnUpdate()
    if not Menu.IsEnabled(dm.Enable) or not Heroes.GetLocal() or not Engine.IsInGame() then
        return
    end
    dm.Informer()
end
function dm.Informer()
    myHero = Heroes.GetLocal()
    scor=NPC.GetAttackTime(myHero)

    kol_damege=NPC.GetTrueDamage(myHero)
    enemy = Entity.GetHeroesInRadius(myHero, 900, Enum.TeamType.TEAM_ENEMY)
    if enemy and #enemy > 0 then
        for i=1, #enemy do
            local enemy = enemy[i]
            if enemy then
                armor = NPC.GetArmorDamageMultiplier(enemy)*100
                regen = NPC.GetHealthRegen(enemy)
                name = NPC.GetUnitName(enemy)
                healthEn = Entity.GetHealth(enemy)
                MaxHeal = Entity.GetMaxHealth(enemy)
                kol_damege=armor*kol_damege/100
                kol_damege_fromregenuch = kol_damege/scor
                speed1 = healthEn/kol_damege_fromregenuch
                healthWithRegen = (speed1*regen)+healthEn+1
                kol_udar_withregen = healthWithRegen/kol_damege
                speedwithregen =  kol_udar_withregen*scor            
            end
        end
    else
        name = 0
    end
end

function dm.OnDraw()
    icon = Renderer.LoadImage("panorama/images/heroes/icons/"..name.."_png.vtex_c")
    IconDraw = Renderer.DrawImage(icon, x, y, 30, 40)
    TextName = Renderer.DrawText(dm.fontItem, 732, 105, "Герой: ")
    if regen < kol_damege_fromregenuch then
        Text_Draw_Kol = Renderer.DrawText(dm.fontItem, 732, 125, "Для убийства нужно ударов: "..string.format("%.0f",kol_udar_withregen+0.5))
        Text_Draw_Time = Renderer.DrawText(dm.fontItem, 732, 140, "Время убийства: "..string.format("%.0f",speedwithregen+0.5).. " sec")
    else
        Text_Draw_Kol = Renderer.DrawText(dm.fontItem, 732, 125, "Для убийства нужно ударов: Реген превышает урон")
        Text_Draw_Time = Renderer.DrawText(dm.fontItem, 732, 140, "Время убийства: Бесконечно")
    end
    if name == 0 then
        IconDraw = nil
        Text_Draw_Kol = nil
        Text_Draw_Time = nil
    end
end

return dm