-- Buyer spawn etc.
function Randomize()

    lib.notify({
        title = Config.Language['notifytitle'],
        description = Config.Language['deliverdropoff'],
        type = 'info'
    })

    local waypoint = Config.Dropoffpoints[math.random(#Config.Dropoffpoints)]

    local model = randomPed[math.random(1, #randomPed)]
    lib.requestModel(model)

    local dealer = CreatePed(4, model, waypoint.coords, true, false)
    FreezeEntityPosition(dealer, true)
    SetEntityInvincible(dealer, true)
    TaskStartScenarioInPlace(dealer, 'WORLD_HUMAN_HANG_OUT_STREET', true)
    KannabisBlip = AddBlipForCoord(waypoint.coords)
    SetBlipSprite (KannabisBlip, Config.Blip['sprite'])
    SetBlipScale  (KannabisBlip, 1.2)
    SetBlipColour(KannabisBlip, Config.Blip['colour'])
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Dropoff')
    EndTextCommandSetBlipName(KannabisBlip)
end

-- Policealert
local function PoliceAlert()
    if Config.Psdispatch then
        exports['ps-dispatch']:DrugSale()
    else return end
end

-- Animation
    local function animation()
    TaskTurnPedToFaceEntity(dealer, PlayerPedId(), 1.0)
    TaskTurnPedToFaceEntity(PlayerPedId(), dealer, 1.0)
    Wait(100)
    PlayAmbientSpeech1(dealer, "Generic_Hi", "Speech_Params_Force")
    Wait(1000)
    PoliceAlert()

    lib.requestAnimDict("mp_safehouselost@")
    TaskPlayAnim(PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(1000)

    PlayAmbientSpeech1(dealer, "Chat_State", "Speech_Params_Force")
    Wait(500)

    lib.requestAnimDict("mp_safehouselost@")
    TaskPlayAnim(dealer, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(1500)
end

-- Functions for buyertarget
local function purchaseTarget()
    local count = exports.ox_inventory:Search('count', 'cannabis')

    if count > Config.Cannabis['amountneeded'] then
        exports.ox_target:disableTargeting(true)
        exports.ox_target:removeLocalEntity(dealer, 'weedrun1')
        exports.ox_target:removeLocalEntity(dealer, 'weedrun2')
        
        animation()
        
        exports.ox_target:disableTargeting(false)
        lib.callback.await('weedrun:server:reward', false)
        
        RemoveBlip(KannabisBlip)
        FreezeEntityPosition(dealer, false)
        SetEntityInvincible(dealer, false)
        SetBlockingOfNonTemporaryEvents(dealer, false)
        SetPedAsNoLongerNeeded(dealer)
        
        lib.notify({
            title = Config.Language['notifytitle'],
            description = Config.Language['deliverdropoff2'],
            type = 'success'
        })
        
        Wait(7000)
        DeletePed(dealer)
        Wait(30000)
        Randomize()
    else
        lib.notify({
            title = Config.Language['notifytitle'],
            description = Config.Language['notenoughcannabis'],
            type = 'error'
        })
        
        RemoveBlip(KannabisBlip)
        exports.ox_target:removeLocalEntity(dealer, 'weedrun1')
        exports.ox_target:removeLocalEntity(dealer, 'weedrun2')
        
        FreezeEntityPosition(dealer, false)
        SetEntityInvincible(dealer, false)
        SetPedAsNoLongerNeeded(dealer)
        
        Wait(10000)
        DeletePed(dealer)
    end
end


local function purchaseTarget2()
    exports.ox_target:disableTargeting(true)
    Wait(100)
    
    exports.ox_target:removeLocalEntity(dealer, 'weedrun1')
    exports.ox_target:removeLocalEntity(dealer, 'weedrun2')
    Wait(100)
    
    exports.ox_target:disableTargeting(false)
    
    RemoveBlip(KannabisBlip)
    SetPedAsNoLongerNeeded(dealer)
    Wait(5000)
    DeletePed(dealer)
end

-- Buyer
exports.ox_target:addLocalEntity(dealer, {
    {
        name = 'weedrun1',
        label = Config.Language['buyerlabel'],
        icon = 'fa-solid fa-cannabis',
        distance = 2,
        onSelect = function()
            purchaseTarget()
        end
    },
    {
        name = 'weedrun2',
        label = Config.Language['stoprun'],
        icon = 'fa-solid fa-x',
        distance = 2,
        onSelect = function()
            purchaseTarget2()
        end
    }
})


Dropoffpoints = {
    { coords = vec4(-1484.68, -604.82, 29.88, 249.27) },
    { coords = vec4(-1060.86, -520.79, 35.09, 13.39) },
    { coords = vec4(-739.62, 188.03, 72.86, 117.7) },
    { coords = vec4(-1046.91, 500.32, 83.16, 232.91) },
}

randomPed = {
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

    lib.requestModel(model)

    local weedRunPed = CreatePed(4, model, Config.StartLocation.x, Config.StartLocation.y, Config.StartLocation.z - 1.0, Config.StartLocation.w, false, false)
    FreezeEntityPosition(weedRunPed, true)
    SetEntityInvincible(weedRunPed, true)
    SetBlockingOfNonTemporaryEvents(weedRunPed, true)
    TaskStartScenarioInPlace(weedRunPed, 'WORLD_HUMAN_SMOKING', 0, true)
    
    exports.ox_target:addLocalEntity(weedRunPed, {
        {
            name = 'weedRunPed',
            label = Config.Language['startrun'],
            icon = 'fa-regular fa-comments',
            distance = 2.0,
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
