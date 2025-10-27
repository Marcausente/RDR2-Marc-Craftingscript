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
            name = 'Arco reforzado',
            item = 'weapon_bow_improved',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Arco mejorado con algo mas de potencia y durabilidad',
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
            name = 'Rifle Varmmint',
            item = 'weapon_rifle_varmint',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Rifle de caza pequeña hecho para alimañas',
        },
        {
            name = 'Carabina de repeticion',
            item = 'weapon_repeater_carbine',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 1,
            description = 'Carabina repetidora, arma de repeticion simple y rapida',
        },
        -- Nivel 2
        {
            name = 'Revolver Doble Acción',
            item = 'weapon_revolver_doubleaction',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Revolver de accion rapida, muy veloz pero poco preciso',
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
            description = 'Fusil de cerrojo, arma de precision y potencia, largo alcance pero lenta',
        },
        {
            name = 'Escopeta Repetidora',
            item = 'weapon_shotgun_repeating',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Escopeta repetidora, rapida pero con poca potencia y mucha dispersion',
        },
        {
            name = 'Lancaster de repeticion',
            item = 'weapon_repeater_winchester',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 2,
            description = 'Repetidora Lancaster, arma extremadamente versatil y rapida, perfecta para caza y defensa',
        },
        -- Nivel 3
        {
            name = 'Revolver Lemat',
            item = 'weapon_revolver_lemat',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Revolver de recarga lenta, pero con nueve balas en el cargador',
        },
        {
            name = 'Escopeta Recortada',
            item = 'weapon_shotgun_sawedoff',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Escopeta de cartuchera, letal a muy corto alcance, poco precisa pero muy poderosa',
        },
        {
            name = 'Repetidor Litchfield',
            item = 'weapon_repeater_henry',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Arma de repeticion rapida y precisa, con un buen cargador y alcance medio',
        },
        {
            name = 'Cuchillo Rústico',
            item = 'weapon_melee_knife_rustic',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Cuchillo rústico, un cuchillo ligeramente mas grande',
        },
        {
            name = 'Escopeta Doble Cañón',
            item = 'weapon_shotgun_doublebarrel',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 3,
            description = 'Escopeta de dos cañones, muy poderosa pero con poca precision y gran dispersion, con dos en la recamara',
        },
        -- Nivel 4
        {
            name = 'Revolver Schofield',
            item = 'weapon_revolver_schofield',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 4,
            description = 'Revolver muy preciso, con una potencia media y una recarga moderada',
        },
        {
            name = 'Repetidor Evans',
            item = 'weapon_repeater_evans',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 4,
            description = 'Arma extremadamente rapida y con un cargador muy ampliado, aunque poco potente y con un alcance medio',
        },
        {
            name = 'Rifle Springfield',
            item = 'weapon_rifle_springfield',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 4,
            description = 'Arma lenta, de recarga tras cada disparo, pero con un alcance muy largo y una gran potencia',
        },
        {
            name = 'Escopeta Doble Cañón Exótica',
            item = 'weapon_shotgun_doublebarrel_exotic',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 4,
            description = 'Escopeta de dos cañones con grabados exoticos, muy poderosa pero con poca precision y gran dispersion, con dos en la recamara',
        },
        -- Nivel 5
        {
            name = 'Revolver Navy',
            item = 'weapon_revolver_navy',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Revolver muy potente y preciso, pero con una recarga lenta y una cadencia también lenta',
        },
        {
            name = 'Pistola Volcanic',
            item = 'weapon_pistol_volcanic',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Pistola extremadamente potente, pero lenta en cuanto a cadencia y recarga',
        },
        {
            name = 'Rifle Rollingblock',
            item = 'weapon_sniperrifle_rollingblock',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Fusil de francotirador con cinco balas, potencia media y muy precisa, excelente para la caza de presas medianas',
        },
        {
            name = 'Escopeta de Corredera',
            item = 'weapon_shotgun_pump',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Escopeta con un mecanismo de corredera, muy rapida pero con gran dispersion y potencia media. Tiene cinco balas en el cargador',
        },
        {
            name = 'Cuchillo de comerciante',
            item = 'weapon_melee_knife_trader',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Cuchillo lustroso para gente con dinero',
        },
        {
            name = 'Hacha de Carnicero arrojadiza',
            item = 'weapon_melee_cleaver',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 5,
            description = 'Hacha arrojadiza de grandes dimensiones',
        },
        -- Nivel 6
        {
            name = 'Pistola Mauser',
            item = 'weapon_pistol_mauser',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 6,
            description = 'Pistola moderna de fabricacion alemana, poco potente pero rapida',
        },
        {
            name = 'Rifle Rollingblock Exótico',
            item = 'weapon_sniperrifle_rollingblock_exotic',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 6,
            description = 'Fusil de francotirador Rollingblock pero con grabados exoticos con cinco balas, potencia media y muy precisa, excelente para la caza de presas medianas',
        },
        {
            name = 'Hacha de Cazador arrojadiza',
            item = 'weapon_melee_hatchet_hunter',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 6,
            description = 'Hacha de dimensiones medias para arrojar',
        },
        -- Nivel 7
        {
            name = 'Pistola Semi-Automática',
            item = 'weapon_pistol_semiauto',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 7,
            description = 'Pistola de fabricacion estadounidense, con una potencia media, pero rapida',
        },
        {
            name = 'Rifle Carcano',
            item = 'weapon_sniperrifle_carcano',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 7,
            description = 'Fusil de francotirador extremadamente potente, con un alcance muy largo y una gran precision, pero con una sola bala. Excelente para la caza de presas muy grandes',
        },
        {
            name = 'Revolver Cattleman Mexicano',
            item = 'weapon_revolver_cattleman_mexican',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 7,
            description = 'Revolver cattelman con grabados mexicanos',
        },
        -- Nivel 8
        {
            name = 'Rifle Mataelefantes',
            item = 'weapon_rifle_elephant',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 8,
            description = 'Fusil de dos balas extremadamente potente, con un gran retoceso tras cada disparo. Excelente para la caza de presas muy grandes',
        },
        {
            name = 'Revolver Doble Acción decorado',
            item = 'weapon_revolver_doubleaction_gambler',
            amount = 1,
            time = 30000,
            ingredients = {{item = 'wood', amount = 5}},
            requiredLevel = 8,
            description = 'Revolver de doble accion con decoraciones de plata',
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
