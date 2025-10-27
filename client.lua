local QBCore = exports['rsg-core']:GetCoreObject()
local PlayerData = {}
local isCrafting = false
local currentCraftingStation = nil
local craftingProgress = 0
local craftingTimer = nil
local isUIOpen = false

-- Inicialización del cliente
CreateThread(function()
    while QBCore == nil do
        Wait(10)
    end
    
    PlayerData = QBCore.Functions.GetPlayerData()
    
    -- Crear blips para las estaciones de crafting
    CreateCraftingBlips()
    
    -- Crear puntos de interacción
    CreateCraftingStations()
end)

-- Comando de debug para verificar el estado del jugador
RegisterCommand('craftingdebug', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    print('=== DEBUG CRAFTING ===')
    print('Job:', PlayerData.job and PlayerData.job.name or 'nil')
    print('OnDuty:', PlayerData.job and PlayerData.job.onduty or 'nil')
    print('Job Label:', PlayerData.job and PlayerData.job.label or 'nil')
    print('Job Grade:', PlayerData.job and PlayerData.job.grade or 'nil')
    print('=====================')
    
    lib.notify({
        title = 'Debug Crafting',
        description = string.format('Job: %s | OnDuty: %s', 
            PlayerData.job and PlayerData.job.name or 'nil',
            PlayerData.job and tostring(PlayerData.job.onduty) or 'nil'
        ),
        type = 'inform',
        duration = 5000,
    })
end, false)

-- Comando para probar las recetas directamente
RegisterCommand('testrecipes', function()
    local recipes = Config.Recipes['armory'] or {}
    print('[marc_crafting] Debug - Recetas de armory:', #recipes)
    for i, recipe in pairs(recipes) do
        print('[marc_crafting] Debug - Receta', i, ':', recipe.name)
    end
    
    -- Simular apertura de interfaz
    local playerData = {
        job = PlayerData.job and PlayerData.job.name or 'unemployed',
        level = 1,
        experience = 0,
        maxExperience = 1000,
        onDuty = PlayerData.job and PlayerData.job.onduty or false
    }
    
    OpenCraftingUI(playerData, recipes)
end, false)

-- Comando para dar wood para testing
RegisterCommand('givewood', function()
    TriggerServerEvent('marc_crafting:server:giveWood')
end, false)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Crear blips para las estaciones
function CreateCraftingBlips()
    for _, station in pairs(Config.CraftingStations) do
        if station.enabled and station.blip then
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, station.coords.x, station.coords.y, station.coords.z)
            SetBlipSprite(blip, GetHashKey(station.blip.sprite), true)
            SetBlipScale(blip, station.blip.scale)
            Citizen.InvokeNative(0x662D364ABF16DE2F, blip, station.blip.color)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, station.blip.label)
        end
    end
end

-- Crear puntos de interacción con ox_target
function CreateCraftingStations()
    for _, station in pairs(Config.CraftingStations) do
        if station.enabled then
            exports.ox_target:addBoxZone({
                coords = station.coords,
                size = vec3(station.radius * 2, station.radius * 2, 2.0),
                rotation = station.heading,
                options = {
                    {
                        name = 'crafting_station_' .. station.stationType,
                        icon = 'fas fa-hammer',
                        label = 'Mesa de Crafting',
                        onSelect = function()
                            if CanUseStation(station) then
                                OpenCraftingMenu(station)
                            end
                        end,
                        canInteract = function()
                            return not isCrafting
                        end,
                    }
                }
            })
        end
    end
end

-- Verificar si el jugador puede usar la estación
function CanUseStation(station)
    -- Actualizar PlayerData antes de verificar
    PlayerData = QBCore.Functions.GetPlayerData()
    
    -- Debug: mostrar información del job
    if Config.Crafting.debug then
        print('[marc_crafting] Debug - Job actual:', PlayerData.job and PlayerData.job.name or 'nil')
        print('[marc_crafting] Debug - OnDuty:', PlayerData.job and PlayerData.job.onduty or 'nil')
        print('[marc_crafting] Debug - Jobs requeridos:', json.encode(station.requiredJobs))
        print('[marc_crafting] Debug - RequireDuty:', station.requireDuty)
    end
    
    -- Verificar si está desempleado
    if not PlayerData.job or PlayerData.job.name == 'unemployed' then
        lib.notify({
            title = 'Crafting',
            description = Config.Texts.unemployed,
            type = Config.Texts.errorType
        })
        return false
    end
    
    -- Verificar jobs requeridos (cualquier job de armería)
    if station.requiredJobs and #station.requiredJobs > 0 then
        local hasRequiredJob = false
        for _, requiredJob in pairs(station.requiredJobs) do
            if PlayerData.job.name == requiredJob then
                hasRequiredJob = true
                break
            end
        end
        
        if not hasRequiredJob then
            lib.notify({
                title = 'Crafting',
                description = 'Solo los armeros pueden usar esta mesa de crafting',
                type = Config.Texts.errorType
            })
            return false
        end
    end
    
    -- Verificar si debe estar de servicio
    if station.requireDuty and not PlayerData.job.onduty then
        lib.notify({
            title = 'Crafting',
            description = Config.Texts.notOnDuty,
            type = Config.Texts.errorType
        })
        return false
    end
    
    -- Verificar items requeridos
    if station.requiredItems and #station.requiredItems > 0 then
        for _, item in pairs(station.requiredItems) do
            local hasItem = QBCore.Functions.HasItem(item.item, item.amount or 1)
            if not hasItem then
                lib.notify({
                    title = 'Crafting',
                    description = 'No tienes los items necesarios para usar esta estación',
                    type = Config.Texts.errorType
                })
                return false
            end
        end
    end
    
    return true
end

-- Abrir menú de crafting
function OpenCraftingMenu(station)
    if isCrafting then
        lib.notify({
            title = 'Crafting',
            description = Config.Texts.stationInUse,
            type = Config.Texts.errorType
        })
        return
    end
    
    if isUIOpen then
        return
    end
    
    currentCraftingStation = station
    local recipes = Config.Recipes[station.stationType] or {}
    
    if #recipes == 0 then
        lib.notify({
            title = 'Crafting',
            description = 'No hay recetas disponibles para esta estación',
            type = Config.Texts.errorType
        })
        return
    end
    
    -- Preparar datos del jugador
    local playerData = {
        job = PlayerData.job.name,
        level = GetPlayerCraftingLevel(),
        experience = GetPlayerCraftingExperience(),
        maxExperience = Config.Levels.experiencePerLevel,
        onDuty = PlayerData.job.onduty
    }
    
    -- Debug: mostrar información de las recetas
    print('[marc_crafting] Debug - Total recetas encontradas:', #recipes)
    for i, recipe in pairs(recipes) do
        print('[marc_crafting] Debug - Receta', i, ':', recipe.name)
    end
    
    -- Mostrar todas las recetas disponibles (no filtrar por ingredientes)
    -- El JavaScript se encargará de mostrar si se puede crear o no
    
    -- Abrir interfaz HTML
    OpenCraftingUI(playerData, recipes)
end

-- Abrir interfaz HTML
function OpenCraftingUI(playerData, recipes)
    if isUIOpen then
        return
    end
    
    isUIOpen = true
    
    -- Abrir NUI
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = 'loadPlayerData',
        data = playerData
    })
    
    SendNUIMessage({
        type = 'loadRecipes',
        data = recipes
    })
    
    -- Mostrar HTML solo cuando se llama explícitamente
    SendNUIMessage({
        type = 'showUI'
    })
end

-- Cerrar interfaz HTML
function CloseCraftingUI()
    if not isUIOpen then
        return
    end
    
    isUIOpen = false
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        type = 'hideUI'
    })
end

-- Obtener nivel de crafting del jugador
function GetPlayerCraftingLevel()
    -- TODO: Implementar sistema de niveles persistente
    return 1
end

-- Obtener experiencia de crafting del jugador
function GetPlayerCraftingExperience()
    -- TODO: Implementar sistema de experiencia persistente
    return 0
end

-- Verificar si se puede crear una receta
function CanCraftRecipe(recipe)
    -- Verificar ingredientes
    for _, ingredient in pairs(recipe.ingredients) do
        local hasItem = QBCore.Functions.HasItem(ingredient.item, ingredient.amount)
        if not hasItem then
            return false
        end
    end
    
    -- TODO: Verificar nivel del jugador cuando implementemos el sistema de niveles
    -- if recipe.requiredLevel and GetPlayerCraftingLevel() < recipe.requiredLevel then
    --     return false
    -- end
    
    return true
end

-- Crear descripción de la receta
function CreateRecipeDescription(recipe)
    local description = Config.Texts.ingredients .. '\n'
    
    for _, ingredient in pairs(recipe.ingredients) do
        local hasItem = QBCore.Functions.HasItem(ingredient.item, ingredient.amount)
        local status = hasItem and '✓' or '✗'
        description = description .. string.format('%s %s x%d\n', status, ingredient.item, ingredient.amount)
    end
    
    description = description .. string.format('\nTiempo: %ds', recipe.time / 1000)
    
    if recipe.requiredLevel then
        description = description .. string.format('\nNivel requerido: %d', recipe.requiredLevel)
    end
    
    return description
end

-- Iniciar proceso de crafting
function StartCrafting(recipe)
    if isCrafting then
        return
    end
    
    isCrafting = true
    craftingProgress = 0
    
    -- Notificar inicio
    lib.notify({
        title = 'Crafting',
        description = string.format(Config.Texts.craftingStarted, recipe.name),
        type = Config.Texts.infoType
    })
    
    -- Enviar al servidor para verificar ingredientes y comenzar crafting
    TriggerServerEvent('marc_crafting:server:startCrafting', recipe, currentCraftingStation)
    
    -- Iniciar barra de progreso
    StartCraftingProgress(recipe)
end

-- Iniciar barra de progreso
function StartCraftingProgress(recipe)
    local startTime = GetGameTimer()
    local duration = recipe.time
    
    craftingTimer = CreateThread(function()
        while isCrafting do
            local currentTime = GetGameTimer()
            local elapsed = currentTime - startTime
            craftingProgress = math.min(elapsed / duration, 1.0)
            
            if craftingProgress >= 1.0 then
                break
            end
            
            Wait(100)
        end
    end)
end

-- Cancelar crafting
function CancelCrafting()
    if not isCrafting then
        return
    end
    
    isCrafting = false
    craftingProgress = 0
    
    if craftingTimer then
        craftingTimer = nil
    end
    
    TriggerServerEvent('marc_crafting:server:cancelCrafting')
    
    lib.notify({
        title = 'Crafting',
        description = Config.Texts.craftingCancelled,
        type = Config.Texts.infoType
    })
end

-- Callbacks de NUI
RegisterNUICallback('closeCrafting', function(data, cb)
    CloseCraftingUI()
    cb('ok')
end)

RegisterNUICallback('startCrafting', function(data, cb)
    local recipe = json.decode(data)
    StartCrafting(recipe)
    cb('ok')
end)

RegisterNUICallback('cancelCrafting', function(data, cb)
    CancelCrafting()
    cb('ok')
end)

RegisterNUICallback('craftingCompleted', function(data, cb)
    -- Este callback se puede usar para limpiar el estado si es necesario
    cb('ok')
end)

RegisterNUICallback('checkIngredient', function(data, cb)
    local ingredient = json.decode(data)
    local hasItem = QBCore.Functions.HasItem(ingredient.item, ingredient.amount)
    cb(hasItem)
end)

-- Eventos del servidor
RegisterNetEvent('marc_crafting:client:craftingCompleted', function(recipe)
    isCrafting = false
    craftingProgress = 0
    
    if craftingTimer then
        craftingTimer = nil
    end
    
    -- Notificar a la UI
    SendNUIMessage({
        type = 'craftingCompleted',
        data = recipe
    })
    
    lib.notify({
        title = 'Crafting',
        description = string.format(Config.Texts.craftingCompleted, recipe.name),
        type = Config.Texts.successType
    })
end)

RegisterNetEvent('marc_crafting:client:craftingFailed', function(reason)
    isCrafting = false
    craftingProgress = 0
    
    if craftingTimer then
        craftingTimer = nil
    end
    
    -- Notificar a la UI
    SendNUIMessage({
        type = 'craftingFailed',
        message = reason
    })
    
    lib.notify({
        title = 'Crafting',
        description = reason,
        type = Config.Texts.errorType
    })
end)

-- Controles
CreateThread(function()
    while true do
        if isCrafting then
            -- Mostrar progreso en pantalla
            local progressText = string.format(Config.Texts.progress, math.floor(craftingProgress * 100))
            DrawText2D(progressText, 0.5, 0.8, 0.5, 255, 255, 255, 255)
            
            -- Permitir cancelar con Escape
            if IsControlJustPressed(0, 322) then -- Escape key
                CancelCrafting()
            end
        end
        
        Wait(0)
    end
end)

-- Función para dibujar texto en pantalla
function DrawText2D(text, x, y, scale, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
