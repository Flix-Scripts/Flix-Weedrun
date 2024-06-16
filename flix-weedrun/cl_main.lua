-- Buyer spawn etc.
function Randomsijainti()
    lib.notify({
        title = Config.Language['notifytitle'],
        description = Config.Language['deliverdropoff'],
        type = 'info'
    })

    local waypoint =  Config.Dropoffpoints[math.random(#Config.Dropoffpoints)]

    local model = Randompedi[math.random(1, #Randompedi)]
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1000)
    end

    local kauppias = CreatePed(4, model, waypoint.coords, true, false)
    FreezeEntityPosition(kauppias, true)
    SetEntityInvincible(kauppias, true)
    TaskStartScenarioInPlace(kauppias, 'WORLD_HUMAN_HANG_OUT_STREET', true)
    KannabisBlip = AddBlipForCoord(waypoint.coords)
    SetBlipSprite (KannabisBlip, Config.Blip['sprite'])
    SetBlipScale  (KannabisBlip, 1.2)
    SetBlipColour(KannabisBlip, Config.Blip['colour'])
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Dropoff')
    EndTextCommandSetBlipName(KannabisBlip)

-- Policealert
local function PoliceAlert()
    if Config.Psdispatch then
        exports['ps-dispatch']:DrugSale()
    else return end
end

-- Animation
    local function Animaatio()
        TaskTurnPedToFaceEntity(kauppias, PlayerPedId(), 1.0)
        TaskTurnPedToFaceEntity(PlayerPedId(), kauppias, 1.0)
        Wait(100)
        PlayAmbientSpeech1(kauppias, "Generic_Hi", "Speech_Params_Force")
        Wait(1000)
        PoliceAlert()

        RequestAnimDict("mp_safehouselost@")
        while not HasAnimDictLoaded("mp_safehouselost@") do Wait(10) end
        TaskPlayAnim(PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        Wait(1000)

        PlayAmbientSpeech1(kauppias, "Chat_State", "Speech_Params_Force")
        Wait(500)
        RequestAnimDict("mp_safehouselost@")
        while not HasAnimDictLoaded("mp_safehouselost@") do Wait(10) end
        TaskPlayAnim(kauppias, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        Wait(1500)
    end

-- Functions for buyertarget
local function OstoTarget()
    local count = exports.ox_inventory:Search('count', 'cannabis')
        if count > Config.Cannabis['amountneeded'] then
        exports.ox_target:disableTargeting(true)
        exports.ox_target:removeLocalEntity(kauppias, 'weedrunostaja')
        exports.ox_target:removeLocalEntity(kauppias, 'weedrunostajaa')
        Animaatio()
        exports.ox_target:disableTargeting(false)
        lib.callback.await('huumekaupat:reward', source)
        RemoveBlip(KannabisBlip)
        FreezeEntityPosition(kauppias, false)
        SetEntityInvincible(kauppias, false)
        SetBlockingOfNonTemporaryEvents(kauppias, false)
	    SetPedAsNoLongerNeeded(kauppias)
        lib.notify({
            title = Config.Language['notifytitle'],
            description = Config.Language['deliverdropoff2'],
            type = 'success'
        })
        Wait(15000)
        DeletePed(kauppias)
        Wait(20000)
        Randomsijainti()
        else
        lib.notify({
        title = Config.Language['notifytitle'],
        description = Config.Language['notenoughcannabis'],
        type = 'error'
        })
        RemoveBlip(KannabisBlip)
        exports.ox_target:removeLocalEntity(kauppias, 'weedrunostaja')
        exports.ox_target:removeLocalEntity(kauppias, 'weedrunostajaa')
        FreezeEntityPosition(kauppias, false)
        SetEntityInvincible(kauppias, false)
	    SetPedAsNoLongerNeeded(kauppias)
        Wait(15000)
        DeletePed(kauppias)
    end
end

local function OstoTarget2()
    exports.ox_target:disableTargeting(true)
    Wait(100)
    exports.ox_target:removeLocalEntity(kauppias, 'weedrunostaja')
    exports.ox_target:removeLocalEntity(kauppias, 'weedrunostajaa')
    Wait(100)
    exports.ox_target:disableTargeting(false)
    RemoveBlip(KannabisBlip)
    SetPedAsNoLongerNeeded(kauppias)
    Wait(15000)
    DeletePed(kauppias)
end
-- Buyer
    exports.ox_target:addLocalEntity(kauppias, {
        {
            name = 'weedrunostaja',
            label = Config.Language['buyerlabel'],
            icon = 'fa-solid fa-cannabis',
            distance = 2,
            onSelect = function()
                OstoTarget()
            end
        },
        {
            name = 'weedrunostajaa',
            label = Config.Language['stoprun'],
            icon = 'fa-solid fa-x',
            distance = 2,
            onSelect = function()
                OstoTarget2()
            end
        }})
    end

Dropoffpoints = {
    {coords = vec4(-1484.68, -604.82, 29.88, 249.27)},
    {coords = vec4(-1060.86, -520.79, 35.09, 13.39)},
    {coords = vec4(-739.62, 188.03, 72.86, 117.7)},
    {coords = vec4(-1046.91, 500.32, 83.16, 232.91)},
}

Randompedi = {
    0x68709618,
    0x62018559,
    0xCF623A2C,
    0xF42EE883,
    0x37FACDA6,
    0x379F9596,
    0x9D0087A8
}

-- Start npc
CreateThread(function()
    local model = 0x68709618

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1000)
    end

    local weedrunpedi = CreatePed(4, model, Config.StartLocation.x, Config.StartLocation.y, Config.StartLocation.z-1.0, Config.StartLocation.w, false, false)
    FreezeEntityPosition(weedrunpedi, true)
    SetEntityInvincible(weedrunpedi, true)
    SetBlockingOfNonTemporaryEvents(weedrunpedi, true)
    TaskStartScenarioInPlace(weedrunpedi, 'WORLD_HUMAN_SMOKING', true)
    exports.ox_target:addLocalEntity(weedrunpedi, {
        {
            name = 'weedrunpedi',
            label = Config.Language['startrun'],
            icon = 'fa-regular fa-comments',
            distance = 2,
            onSelect = function()
                lib.notify({
                    title = Config.Language['notifytitle'],
                    description = Config.Language['startdesc'],
                    type = 'info'
                })
                Wait(30000)
                Randomsijainti()
            end
        }
    })
end)
