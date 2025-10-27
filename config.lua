Config = Config or {}

-- Configuración general del sistema de crafting
Config.Crafting = {
    -- Habilitar/deshabilitar el sistema completo
    enabled = true,
    
    -- Configuración de debug
    debug = false,
    
    -- Tiempo mínimo entre acciones de crafting (en ms)
    actionCooldown = 1000,
    
    -- Distancia máxima para interactuar con estaciones
    interactionDistance = 3.0,
}

-- Estaciones de crafting disponibles
Config.CraftingStations = {
    {
        name = 'Mesa de Armería - Valentine',
        coords = vector3(-280.0, 780.0, 119.5),
        heading = 0.0,
        radius = 2.0,
        enabled = true,
        stationType = 'armory',
        blip = {
            label = 'Mesa de Crafting',
            sprite = 'blip_shop_crafting',
            scale = 0.8,
            color = 1, -- rojo
        },
        requiredJobs = {'vlarmory', 'rharmory'}, -- Jobs que pueden usar esta estación
        requireDuty = true, -- Requiere estar de servicio
        requiredItems = {}, -- items necesarios para usar la estación
    },
    {
        name = 'Mesa de Armería - Rhodes',
        coords = vector3(1327.96, -1322.06, 77.89),
        heading = 0.0,
        radius = 2.0,
        enabled = true,
        stationType = 'armory',
        blip = {
            label = 'Mesa de Crafting',
            sprite = 'blip_shop_crafting',
            scale = 0.8,
            color = 1, -- rojo
        },
        requiredJobs = {'vlarmory', 'rharmory'}, -- Jobs que pueden usar esta estación
        requireDuty = true, -- Requiere estar de servicio
        requiredItems = {}, -- items necesarios para usar la estación
    },
    {
        name = 'Mesa de Taberna',
        coords = vector3(-275.0, 785.0, 119.5),
        heading = 90.0,
        radius = 2.0,
        enabled = true,
        stationType = 'tavern',
        blip = {
            label = 'Mesa de Crafting',
            sprite = 'blip_shop_crafting',
            scale = 0.8,
            color = 25, -- marrón
        },
        requiredJobs = {'taberna'}, -- Jobs que pueden usar esta estación
        requireDuty = true, -- Requiere estar de servicio
        requiredItems = {},
    },
}

-- Recetas de crafting por tipo de estación
Config.Recipes = {
    armory = {
        {
            name = 'Cattleman Revolver',
            item = 'weapon_revolver_cattleman',
            amount = 1,
            time = 30000, -- 30 segundos
            ingredients = {
                {item = 'wood', amount = 5},
            },
            requiredLevel = 1,
            experience = 15,
            description = 'Revolver básico para defensa personal',
        },
        {
            name = 'Schofield Revolver',
            item = 'weapon_revolver_schofield',
            amount = 1,
            time = 45000, -- 45 segundos
            ingredients = {
                {item = 'wood', amount = 10},
            },
            requiredLevel = 1,
            experience = 25,
            description = 'Revolver de alta calidad con mejor precisión',
        },
    },
    tavern = {
        {
            name = 'Botella de Whiskey',
            item = 'whiskey',
            amount = 1,
            time = 30000, -- 30 segundos
            ingredients = {
                {item = 'grain', amount = 3},
                {item = 'water', amount = 2},
            },
            requiredLevel = 1,
            experience = 10,
            description = 'Whiskey artesanal de la taberna',
        },
        {
            name = 'Cerveza Artesanal',
            item = 'beer',
            amount = 1,
            time = 25000, -- 25 segundos
            ingredients = {
                {item = 'hops', amount = 2},
                {item = 'water', amount = 1},
            },
            requiredLevel = 1,
            experience = 8,
            description = 'Cerveza fresca de barril',
        },
    },
}

-- Configuración de niveles y experiencia
Config.Levels = {
    maxLevel = 100,
    experiencePerLevel = 1000,
    bonusMultiplier = 1.1, -- Multiplicador de experiencia por nivel
}

-- Textos utilizados en la UI/notificaciones
Config.Texts = {
    -- Prompts de interacción
    interactPrompt = 'E - Usar mesa de crafting',
    craftingPrompt = 'E - Comenzar crafting',
    cancelPrompt = 'Escape - Cancelar',
    
    -- Notificaciones
    craftingStarted = 'Has comenzado a crear %s',
    craftingCompleted = 'Has completado %s',
    craftingCancelled = 'Has cancelado el crafting',
    notEnoughIngredients = 'No tienes suficientes ingredientes',
    notEnoughLevel = 'No tienes el nivel suficiente para esta receta',
    stationInUse = 'Esta estación está siendo usada por otro jugador',
    invalidStation = 'Estación de crafting no válida',
    wrongJob = 'No tienes el trabajo correcto para usar esta mesa',
    notOnDuty = 'Debes estar de servicio para usar esta mesa',
    unemployed = 'Los desempleados no pueden usar las mesas de crafting',
    
    -- UI
    craftingMenu = 'Mesa de Crafting',
    selectRecipe = 'Selecciona una receta',
    ingredients = 'Ingredientes necesarios:',
    timeRemaining = 'Tiempo restante: %s',
    progress = 'Progreso: %d%%',
    level = 'Nivel: %d',
    experience = 'Experiencia: %d/%d',
    description = 'Descripción: %s',
    requiredJob = 'Trabajo requerido: %s',
    onDuty = 'Debes estar de servicio',
    
    -- Tipos de notificaciones
    successType = 'success',
    errorType = 'error',
    infoType = 'inform',
}
