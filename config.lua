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
        coords = vector3(-276.60, 779.0, 119.5),
        heading = 0.0,
        radius = 2.0,
        enabled = true,
        stationType = 'armory',
        craftingLevel = 8, -- Nivel de esta estación de crafting
        blip = {
            label = 'Mesa de Crafting',
            sprite = 'blip_shop_crafting',
            scale = 0.8,
            color = 1, -- rojo
        },
        requiredJobs = {'vlarmory'}, -- Solo armería de Valentine puede usar esta estación en concreto
        requireDuty = true, -- Requiere estar de servicio
        requiredItems = {}, -- items necesarios para usar la estación
    },
    {
        name = 'Mesa de Armería - Rhodes',
        coords = vector3(1326.60, -1322.06, 77.89),
        heading = 0.0,
        radius = 2.0,
        enabled = true,
        stationType = 'armory',
        craftingLevel = 6, -- Nivel de esta estación de crafting
        blip = {
            label = 'Mesa de Crafting',
            sprite = 'blip_shop_crafting',
            scale = 0.8,
            color = 1, -- rojo
        },
        requiredJobs = {'rharmory'}, -- Jobs que pueden usar esta estación
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
        -- Nivel 1
        {
            name = 'Revolver Cattleman',
            item = 'weapon_revolver_cattleman',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Revolver básico para defensa personal',
        },
        {
            name = 'Arco Estándar',
            item = 'weapon_bow',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Arco estándar',
        },
        {
            name = 'Arco Mejorado',
            item = 'weapon_bow_improved',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Arco mejorado',
        },
        {
            name = 'Cuchillo Estándar',
            item = 'weapon_melee_knife',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Cuchillo estándar',
        },
        {
            name = 'Tomahawk',
            item = 'weapon_thrown_tomahawk',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Tomahawk arrojadizo',
        },
        {
            name = 'Rifle de Caza Menor',
            item = 'weapon_rifle_varmint',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Rifle para alimañas',
        },
        {
            name = 'Repetidor Carabina',
            item = 'weapon_repeater_carbine',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Carabina repetidora',
        },
        -- Nivel 2
        {
            name = 'Revolver Doble Acción',
            item = 'weapon_revolver_doubleaction',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Revolver de doble acción',
        },
        {
            name = 'Cuchillos Arrojadizos',
            item = 'weapon_thrown_throwing_knives',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Cuchillos arrojadizos',
        },
        {
            name = 'Machete',
            item = 'weapon_melee_machete',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Machete',
        },
        {
            name = 'Rifle de Cerrojo',
            item = 'weapon_rifle_boltaction',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Fusil de cerrojo',
        },
        {
            name = 'Escopeta Repetidora',
            item = 'weapon_shotgun_repeating',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Escopeta repetidora',
        },
        {
            name = 'Repetidor Winchester',
            item = 'weapon_repeater_winchester',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Repetidora Lancaster',
        },
        -- Nivel 3
        {
            name = 'Revolver Lemat',
            item = 'weapon_revolver_lemat',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Revolver Lemat',
        },
        {
            name = 'Escopeta Recortada',
            item = 'weapon_shotgun_sawedoff',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Escopeta recortada',
        },
        {
            name = 'Repetidor Litchfield',
            item = 'weapon_repeater_henry',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Repetidora Litchfield',
        },
        {
            name = 'Cuchillo Rústico',
            item = 'weapon_melee_knife_rustic',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Cuchillo rústico',
        },
        {
            name = 'Escopeta Doble Cañón',
            item = 'weapon_shotgun_doublebarrel',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Escopeta de dos cañones',
        },
        -- Nivel 4
        {
            name = 'Revolver Schofield',
            item = 'weapon_revolver_schofield',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 4,
            description = 'Revolver Schofield',
        },
        {
            name = 'Repetidor Evans',
            item = 'weapon_repeater_evans',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 4,
            description = 'Repetidora Evans',
        },
        {
            name = 'Rifle Springfield',
            item = 'weapon_rifle_springfield',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 4,
            description = 'Fusil Springfield',
        },
        {
            name = 'Escopeta Doble Cañón Exótica',
            item = 'weapon_shotgun_doublebarrel_exotic',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 4,
            description = 'Escopeta de dos cañones exótica',
        },
        -- Nivel 5
        {
            name = 'Revolver Navy',
            item = 'weapon_revolver_navy',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Revolver Navy',
        },
        {
            name = 'Pistola Volcanic',
            item = 'weapon_pistol_volcanic',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Pistola Volcanic',
        },
        {
            name = 'Rifle Rollingblock',
            item = 'weapon_sniperrifle_rollingblock',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Fusil de francotirador Rolling Block',
        },
        {
            name = 'Escopeta de Corredera',
            item = 'weapon_shotgun_pump',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Escopeta de corredera',
        },
        {
            name = 'Cuchillo Comerciante',
            item = 'weapon_melee_knife_trader',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Cuchillo comerciante',
        },
        {
            name = 'Cuchillo de Carnicero',
            item = 'weapon_melee_cleaver',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Cuchillo de carnicero',
        },
        -- Nivel 6
        {
            name = 'Pistola Mauser',
            item = 'weapon_pistol_mauser',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 6,
            description = 'Pistola Mauser',
        },
        {
            name = 'Rifle Rollingblock Exótico',
            item = 'weapon_sniperrifle_rollingblock_exotic',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 6,
            description = 'Fusil de francotirador Rolling Block exótico',
        },
        {
            name = 'Hacha de Cazador',
            item = 'weapon_melee_hatchet_hunter',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 6,
            description = 'Hacha de cazador',
        },
        -- Nivel 7
        {
            name = 'Pistola Semi-Automática',
            item = 'weapon_pistol_semiauto',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 7,
            description = 'Pistola semi-automática',
        },
        {
            name = 'Rifle Carcano',
            item = 'weapon_sniperrifle_carcano',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 7,
            description = 'Fusil de francotirador Carcano',
        },
        {
            name = 'Revolver Cattleman Mexicano',
            item = 'weapon_revolver_cattleman_mexican',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 7,
            description = 'Cattleman mexicano',
        },
        -- Nivel 8
        {
            name = 'Rifle Mataelefantes',
            item = 'weapon_rifle_elephant',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 8,
            description = 'Fusil mataelefantes',
        },
        {
            name = 'Revolver Doble Acción Jugador',
            item = 'weapon_revolver_doubleaction_gambler',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 8,
            description = 'Doble acción jugador',
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
