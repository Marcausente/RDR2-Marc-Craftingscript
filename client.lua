local QBCore = exports['rsg-core']:GetCoreObject()
local PlayerData = {}
local isCrafting = false
local currentCraftingStation = nil
local craftingProgress = 0
local craftingTimer = nil

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

-- Eventos del core
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

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
                        label = Config.Texts.interactPrompt,
                        onSelect = function()
                            OpenCraftingMenu(station)
                        end,
                        canInteract = function()
                            return not isCrafting and CanUseStation(station)
                        end,
                    }
                }
            })
        end
    end
end

-- Verificar si el jugador puede usar la estación
function CanUseStation(station)
    -- Verificar job requerido
    if station.requiredJob and PlayerData.job and PlayerData.job.name ~= station.requiredJob then
        return false
    end
    
    -- Verificar items requeridos
    if station.requiredItems and #station.requiredItems > 0 then
        for _, item in pairs(station.requiredItems) do
            local hasItem = QBCore.Functions.HasItem(item.item, item.amount or 1)
            if not hasItem then
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
    
    -- Crear opciones del menú
    local menuOptions = {}
    for _, recipe in pairs(recipes) do
        local canCraft = CanCraftRecipe(recipe)
        local description = CreateRecipeDescription(recipe)
        
        table.insert(menuOptions, {
            title = recipe.name,
            description = description,
            disabled = not canCraft,
            onSelect = function()
                StartCrafting(recipe)
            end,
        })
    end
    
    lib.registerContext({
        id = 'crafting_menu',
        title = station.name,
        options = menuOptions
    })
    
    lib.showContext('crafting_menu')
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

-- Eventos del servidor
RegisterNetEvent('marc_crafting:client:craftingCompleted', function(recipe)
    isCrafting = false
    craftingProgress = 0
    
    if craftingTimer then
        craftingTimer = nil
    end
    
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
