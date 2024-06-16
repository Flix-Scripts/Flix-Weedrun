-- Buyer spawn etc.
function Randomize()
    lib.notify({
        title = Config.Language['notifytitle'],
        description = Config.Language['deliverdropoff'],
        type = 'info'
    })

    local waypoint =  Config.Dropoffpoints[math.random(#Config.Dropoffpoints)]

    local model = Randomped[math.random(1, #Randomped)]
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1000)
    end

    local buyer = CreatePed(4, model, waypoint.coords, true, false)
    FreezeEntityPosition(buyer, true)
    SetEntityInvincible(buyer, true)
    TaskStartScenarioInPlace(buyer, 'WORLD_HUMAN_HANG_OUT_STREET', true)
    CannabisBlip = AddBlipForCoord(waypoint.coords)
    SetBlipSprite (CannabisBlip, Config.Blip['sprite'])
    SetBlipScale  (CannabisBlip, 1.2)
    SetBlipColour(CannabisBlip, Config.Blip['colour'])
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Dropoff')
    EndTextCommandSetBlipName(CannabisBlip)

-- Policealert
local function PoliceAlert()
    if Config.Psdispatch then
        exports['ps-dispatch']:DrugSale()
    else return end
end

-- Animation
    local function Animation()
        TaskTurnPedToFaceEntity(buyer, PlayerPedId(), 1.0)
        TaskTurnPedToFaceEntity(PlayerPedId(), buyer, 1.0)
        Wait(100)
        PlayAmbientSpeech1(buyer, "Generic_Hi", "Speech_Params_Force")
        Wait(1000)
        PoliceAlert()

        RequestAnimDict("mp_safehouselost@")
        while not HasAnimDictLoaded("mp_safehouselost@") do Wait(10) end
        TaskPlayAnim(PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        Wait(1000)

        PlayAmbientSpeech1(buyer, "Chat_State", "Speech_Params_Force")
        Wait(500)
        RequestAnimDict("mp_safehouselost@")
        while not HasAnimDictLoaded("mp_safehouselost@") do Wait(10) end
        TaskPlayAnim(buyer, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        Wait(1500)
    end

-- Functions for buyertarget
local function BuyerTarget()
    local count = exports.ox_inventory:Search('count', 'cannabis')
        if count > Config.Cannabis['amountneeded'] then
        exports.ox_target:disableTargeting(true)
        exports.ox_target:removeLocalEntity(buyer, 'weedrunbuyer')
        exports.ox_target:removeLocalEntity(buyer, 'weedrunbuyera')
        Animation()
        exports.ox_target:disableTargeting(false)
        lib.callback.await('weedrun:reward', source)
        RemoveBlip(CannabisBlip)
        FreezeEntityPosition(buyer, false)
        SetEntityInvincible(buyer, false)
        SetBlockingOfNonTemporaryEvents(buyer, false)
	    SetPedAsNoLongerNeeded(buyer)
        lib.notify({
            title = Config.Language['notifytitle'],
            description = Config.Language['deliverdropoff2'],
            type = 'success'
        })
        Wait(15000)
        DeletePed(buyer)
        Wait(20000)
        Randomize()
        else
        lib.notify({
        title = Config.Language['notifytitle'],
        description = Config.Language['notenoughcannabis'],
        type = 'error'
        })
        RemoveBlip(CannabisBlip)
        exports.ox_target:removeLocalEntity(buyer, 'weedrunbuyer')
        exports.ox_target:removeLocalEntity(buyer, 'weedrunbuyera')
        FreezeEntityPosition(buyer, false)
        SetEntityInvincible(buyer, false)
	    SetPedAsNoLongerNeeded(buyer)
        Wait(15000)
        DeletePed(buyer)
    end
end

local function BuyerTarget2()
    exports.ox_target:disableTargeting(true)
    Wait(100)
    exports.ox_target:removeLocalEntity(buyer, 'weedrunbuyer')
    exports.ox_target:removeLocalEntity(buyer, 'weedrunbuyera')
    Wait(100)
    exports.ox_target:disableTargeting(false)
    RemoveBlip(CannabisBlip)
    SetPedAsNoLongerNeeded(buyer)
    Wait(15000)
    DeletePed(buyer)
end
-- Buyer
    exports.ox_target:addLocalEntity(buyer, {
        {
            name = 'weedrunbuyer',
            label = Config.Language['buyerlabel'],
            icon = 'fa-solid fa-cannabis',
            distance = 2,
            onSelect = function()
                BuyerTarget()
            end
        },
        {
            name = 'weedrunbuyera',
            label = Config.Language['stoprun'],
            icon = 'fa-solid fa-x',
            distance = 2,
            onSelect = function()
                BuyerTarget2()
            end
        }})
    end

Randomped = {
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

    local startnpc = CreatePed(4, model, Config.StartLocation.x, Config.StartLocation.y, Config.StartLocation.z-1.0, Config.StartLocation.w, false, false)
    FreezeEntityPosition(startnpc, true)
    SetEntityInvincible(startnpc, true)
    SetBlockingOfNonTemporaryEvents(startnpc, true)
    TaskStartScenarioInPlace(startnpc, 'WORLD_HUMAN_SMOKING', true)
    exports.ox_target:addLocalEntity(startnpc, {
        {
            name = 'startnpc',
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
                Randomize()
            end
        }
    })
end)
