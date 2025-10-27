local QBCore = exports['rsg-core']:GetCoreObject()

-- Variables del servidor
local activeCrafting = {} -- Tabla para rastrear crafting activos
local playerCraftingLevels = {} -- Tabla para niveles de crafting de jugadores

-- Inicialización del servidor
CreateThread(function()
    -- Cargar niveles de crafting de la base de datos
    LoadCraftingLevels()
end)

-- Cargar niveles de crafting de los jugadores
function LoadCraftingLevels()
    -- TODO: Implementar carga desde base de datos
    -- Por ahora inicializamos con niveles básicos
    print('[marc_crafting] Sistema de crafting inicializado')
end

-- Obtener nivel de crafting del jugador
function GetPlayerCraftingLevel(playerId)
    return playerCraftingLevels[playerId] or 1
end

-- Obtener experiencia de crafting del jugador
function GetPlayerCraftingExperience(playerId)
    -- TODO: Implementar sistema de experiencia
    return 0
end

-- Verificar si el jugador puede usar la estación
function CanPlayerUseStation(playerId, station)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then
        return false
    end
    
    -- Verificar si está desempleado
    if not Player.PlayerData.job or Player.PlayerData.job.name == 'unemployed' then
        return false
    end
    
    -- Verificar jobs requeridos
    if station.requiredJobs and #station.requiredJobs > 0 then
        local hasRequiredJob = false
        for _, requiredJob in pairs(station.requiredJobs) do
            if Player.PlayerData.job.name == requiredJob then
                hasRequiredJob = true
                break
            end
        end
        
        if not hasRequiredJob then
            return false
        end
    end
    
    -- Verificar si debe estar de servicio
    if station.requireDuty and not Player.PlayerData.job.onduty then
        return false
    end
    
    -- Verificar items requeridos
    if station.requiredItems and #station.requiredItems > 0 then
        for _, item in pairs(station.requiredItems) do
            local hasItem = Player.Functions.GetItemByName(item.item)
            if not hasItem or hasItem.amount < (item.amount or 1) then
                return false
            end
        end
    end
    
    return true
end

-- Verificar si el jugador puede crear la receta
function CanPlayerCraftRecipe(playerId, recipe)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then
        return false
    end
    
    -- Verificar ingredientes
    for _, ingredient in pairs(recipe.ingredients) do
        local hasItem = Player.Functions.GetItemByName(ingredient.item)
        if not hasItem or hasItem.amount < ingredient.amount then
            return false
        end
    end
    
    -- Verificar nivel requerido
    local playerLevel = GetPlayerCraftingLevel(playerId)
    if recipe.requiredLevel and playerLevel < recipe.requiredLevel then
        return false
    end
    
    return true
end

-- Remover ingredientes del inventario
function RemoveIngredients(playerId, recipe)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then
        return false
    end
    
    for _, ingredient in pairs(recipe.ingredients) do
        local success = Player.Functions.RemoveItem(ingredient.item, ingredient.amount)
        if not success then
            return false
        end
    end
    
    return true
end

-- Dar item creado al jugador
function GiveCraftedItem(playerId, recipe)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then
        return false
    end
    
    local success = Player.Functions.AddItem(recipe.item, recipe.amount)
    if success then
        TriggerClientEvent('inventory:client:ItemBox', playerId, QBCore.Shared.Items[recipe.item], 'add')
        return true
    end
    
    return false
end

-- Agregar experiencia de crafting
function AddCraftingExperience(playerId, experience)
    -- TODO: Implementar sistema de experiencia
    -- Por ahora solo registramos en consola
    print(string.format('[marc_crafting] Jugador %s ganó %d experiencia de crafting', playerId, experience))
end

-- Eventos del cliente
RegisterNetEvent('marc_crafting:server:startCrafting', function(recipe, station)
    local src = source
    local playerId = src
    
    -- Verificar si el jugador ya está craftando
    if activeCrafting[playerId] then
        TriggerClientEvent('marc_crafting:client:craftingFailed', src, Config.Texts.stationInUse)
        return
    end
    
    -- Verificar si puede usar la estación
    if not CanPlayerUseStation(playerId, station) then
        local Player = QBCore.Functions.GetPlayer(playerId)
        local reason = Config.Texts.invalidStation
        
        if not Player or not Player.PlayerData.job or Player.PlayerData.job.name == 'unemployed' then
            reason = Config.Texts.unemployed
        elseif station.requireDuty and not Player.PlayerData.job.onduty then
            reason = Config.Texts.notOnDuty
        elseif station.requiredJobs and #station.requiredJobs > 0 then
            reason = Config.Texts.wrongJob
        end
        
        TriggerClientEvent('marc_crafting:client:craftingFailed', src, reason)
        return
    end
    
    -- Verificar si puede crear la receta
    if not CanPlayerCraftRecipe(playerId, recipe) then
        local reason = Config.Texts.notEnoughIngredients
        local playerLevel = GetPlayerCraftingLevel(playerId)
        if recipe.requiredLevel and playerLevel < recipe.requiredLevel then
            reason = Config.Texts.notEnoughLevel
        end
        TriggerClientEvent('marc_crafting:client:craftingFailed', src, reason)
        return
    end
    
    -- Registrar crafting activo
    activeCrafting[playerId] = {
        recipe = recipe,
        station = station,
        startTime = os.time(),
        timer = recipe.time
    }
    
    -- Programar finalización del crafting
    SetTimeout(recipe.time, function()
        CompleteCrafting(playerId)
    end)
end)

RegisterNetEvent('marc_crafting:server:cancelCrafting', function()
    local src = source
    local playerId = src
    
    if activeCrafting[playerId] then
        activeCrafting[playerId] = nil
    end
end)

-- Completar proceso de crafting
function CompleteCrafting(playerId)
    local crafting = activeCrafting[playerId]
    if not crafting then
        return
    end
    
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then
        activeCrafting[playerId] = nil
        return
    end
    
    -- Verificar nuevamente los ingredientes (por si los gastó mientras craftaba)
    if not CanPlayerCraftRecipe(playerId, crafting.recipe) then
        TriggerClientEvent('marc_crafting:client:craftingFailed', playerId, Config.Texts.notEnoughIngredients)
        activeCrafting[playerId] = nil
        return
    end
    
    -- Remover ingredientes
    if not RemoveIngredients(playerId, crafting.recipe) then
        TriggerClientEvent('marc_crafting:client:craftingFailed', playerId, 'Error al remover ingredientes')
        activeCrafting[playerId] = nil
        return
    end
    
    -- Dar item creado
    if not GiveCraftedItem(playerId, crafting.recipe) then
        TriggerClientEvent('marc_crafting:client:craftingFailed', playerId, 'Error al dar el item creado')
        activeCrafting[playerId] = nil
        return
    end
    
    -- Agregar experiencia
    if crafting.recipe.experience then
        AddCraftingExperience(playerId, crafting.recipe.experience)
    end
    
    -- Notificar éxito
    TriggerClientEvent('marc_crafting:client:craftingCompleted', playerId, crafting.recipe)
    
    -- Limpiar crafting activo
    activeCrafting[playerId] = nil
end

-- Comandos de administración
QBCore.Commands.Add('craftinglevel', 'Ver nivel de crafting', {{name = 'id', help = 'ID del jugador'}}, false, function(source, args)
    local src = source
    local targetId = tonumber(args[1]) or src
    
    local level = GetPlayerCraftingLevel(targetId)
    local experience = GetPlayerCraftingExperience(targetId)
    
    TriggerClientEvent('QBCore:Notify', src, string.format('Nivel: %d | Experiencia: %d', level, experience), 'inform')
end, 'admin')

QBCore.Commands.Add('setcraftinglevel', 'Establecer nivel de crafting', {{name = 'id', help = 'ID del jugador'}, {name = 'level', help = 'Nivel a establecer'}}, true, function(source, args)
    local src = source
    local targetId = tonumber(args[1])
    local level = tonumber(args[2])
    
    if not targetId or not level then
        TriggerClientEvent('QBCore:Notify', src, 'Uso: /setcraftinglevel [id] [nivel]', 'error')
        return
    end
    
    playerCraftingLevels[targetId] = level
    TriggerClientEvent('QBCore:Notify', src, string.format('Nivel de crafting establecido a %d para el jugador %d', level, targetId), 'success')
end, 'admin')

-- Limpiar crafting activo cuando el jugador se desconecta
AddEventHandler('playerDropped', function(reason)
    local src = source
    if activeCrafting[src] then
        activeCrafting[src] = nil
    end
end)

-- Comando para dar wood para testing
RegisterNetEvent('marc_crafting:server:giveWood', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    Player.Functions.AddItem('wood', 20)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wood'], 'add')
    TriggerClientEvent('QBCore:Notify', src, 'Se te han dado 20 unidades de wood para testing', 'success')
end)

-- Exportar funciones para otros recursos
exports('GetPlayerCraftingLevel', GetPlayerCraftingLevel)
exports('GetPlayerCraftingExperience', GetPlayerCraftingExperience)
exports('CanPlayerUseStation', CanPlayerUseStation)
exports('CanPlayerCraftRecipe', CanPlayerCraftRecipe)
