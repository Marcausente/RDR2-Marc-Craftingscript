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
        name = 'Mesa de Carpintería',
        coords = vector3(-280.0, 780.0, 119.5),
        heading = 0.0,
        radius = 2.0,
        enabled = true,
        stationType = 'carpentry',
        blip = {
            label = 'Carpintería',
            sprite = 'blip_shop_crafting',
            scale = 0.8,
            color = 25, -- marrón
        },
        requiredJob = nil, -- nil = todos pueden usar
        requiredItems = {}, -- items necesarios para usar la estación
    },
    {
        name = 'Forja de Herrero',
        coords = vector3(-275.0, 785.0, 119.5),
        heading = 90.0,
        radius = 2.0,
        enabled = true,
        stationType = 'blacksmith',
        blip = {
            label = 'Herrería',
            sprite = 'blip_shop_crafting',
            scale = 0.8,
            color = 1, -- rojo
        },
        requiredJob = nil,
        requiredItems = {},
    },
    {
        name = 'Mesa de Sastrería',
        coords = vector3(-285.0, 775.0, 119.5),
        heading = 180.0,
        radius = 2.0,
        enabled = true,
        stationType = 'tailoring',
        blip = {
            label = 'Sastrería',
            sprite = 'blip_shop_crafting',
            scale = 0.8,
            color = 2, -- verde
        },
        requiredJob = nil,
        requiredItems = {},
    },
}

-- Recetas de crafting por tipo de estación
Config.Recipes = {
    carpentry = {
        {
            name = 'Tabla de Madera',
            item = 'wooden_table',
            amount = 1,
            time = 30000, -- 30 segundos
            ingredients = {
                {item = 'wood', amount = 5},
                {item = 'nails', amount = 10},
            },
            requiredLevel = 1,
            experience = 10,
        },
        {
            name = 'Silla de Madera',
            item = 'wooden_chair',
            amount = 1,
            time = 20000,
            ingredients = {
                {item = 'wood', amount = 3},
                {item = 'nails', amount = 5},
            },
            requiredLevel = 1,
            experience = 8,
        },
    },
    blacksmith = {
        {
            name = 'Espada Básica',
            item = 'basic_sword',
            amount = 1,
            time = 45000,
            ingredients = {
                {item = 'iron_ingot', amount = 2},
                {item = 'coal', amount = 3},
            },
            requiredLevel = 2,
            experience = 15,
        },
        {
            name = 'Herramienta de Reparación',
            item = 'repair_tool',
            amount = 1,
            time = 25000,
            ingredients = {
                {item = 'iron_ingot', amount = 1},
                {item = 'wood', amount = 1},
            },
            requiredLevel = 1,
            experience = 12,
        },
    },
    tailoring = {
        {
            name = 'Camisa de Lino',
            item = 'linen_shirt',
            amount = 1,
            time = 35000,
            ingredients = {
                {item = 'linen_cloth', amount = 2},
                {item = 'thread', amount = 5},
            },
            requiredLevel = 1,
            experience = 10,
        },
        {
            name = 'Chaleco de Cuero',
            item = 'leather_vest',
            amount = 1,
            time = 40000,
            ingredients = {
                {item = 'leather', amount = 3},
                {item = 'thread', amount = 8},
            },
            requiredLevel = 2,
            experience = 15,
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
    interactPrompt = 'E - Usar estación de crafting',
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
    
    -- UI
    craftingMenu = 'Menú de Crafting',
    selectRecipe = 'Selecciona una receta',
    ingredients = 'Ingredientes necesarios:',
    timeRemaining = 'Tiempo restante: %s',
    progress = 'Progreso: %d%%',
    level = 'Nivel: %d',
    experience = 'Experiencia: %d/%d',
    
    -- Tipos de notificaciones
    successType = 'success',
    errorType = 'error',
    infoType = 'inform',
}
