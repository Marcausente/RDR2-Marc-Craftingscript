# Marc Crafting System

Sistema de crafting avanzado para RedM con múltiples estaciones de trabajo y gestión de niveles.

## Características

- **Múltiples Estaciones**: Carpintería, Herrería, Sastrería
- **Sistema de Niveles**: Progresión de habilidades de crafting
- **Recetas Configurables**: Fácil configuración de nuevas recetas
- **Interfaz Intuitiva**: Menús interactivos con ox_lib
- **Control de Acceso**: Restricciones por job y items requeridos
- **Progreso Visual**: Barra de progreso en tiempo real

## Instalación

1. Coloca la carpeta `marc_crafting` en `resources/[cfx-default]/[local]/`
2. Asegúrate de tener las dependencias instaladas:
   - rsg-core
   - ox_lib
   - ox_target
   - rsg-inventory
3. Agrega `ensure marc_crafting` a tu `server.cfg`
4. Reinicia el servidor

## Configuración

### Estaciones de Crafting

Las estaciones se configuran en `config.lua` bajo `Config.CraftingStations`:

```lua
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
        color = 25,
    },
    requiredJob = nil, -- nil = todos pueden usar
    requiredItems = {}, -- items necesarios para usar la estación
}
```

### Recetas

Las recetas se configuran por tipo de estación en `Config.Recipes`:

```lua
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
}
```

## Tipos de Estaciones

### Carpintería (`carpentry`)
- Creación de muebles y objetos de madera
- Requiere: madera, clavos, herramientas

### Herrería (`blacksmith`)
- Creación de armas y herramientas metálicas
- Requiere: lingotes de hierro, carbón

### Sastrería (`tailoring`)
- Creación de ropa y accesorios
- Requiere: tela, hilo, cuero

## Comandos de Administración

- `/craftinglevel [id]` - Ver nivel de crafting de un jugador
- `/setcraftinglevel [id] [nivel]` - Establecer nivel de crafting (admin)

## Sistema de Niveles

- **Nivel Máximo**: 100
- **Experiencia por Nivel**: 1000 puntos
- **Multiplicador de Bonus**: 1.1x por nivel

## Integración con Otros Recursos

El sistema está diseñado para integrarse fácilmente con otros recursos:

```lua
-- Obtener nivel de crafting de un jugador
local level = exports['marc_crafting']:GetPlayerCraftingLevel(playerId)

-- Verificar si puede usar una estación
local canUse = exports['marc_crafting']:CanPlayerUseStation(playerId, station)

-- Verificar si puede crear una receta
local canCraft = exports['marc_crafting']:CanPlayerCraftRecipe(playerId, recipe)
```

## Personalización

### Agregar Nueva Estación

1. Agrega la configuración en `Config.CraftingStations`
2. Crea las recetas correspondientes en `Config.Recipes`
3. Ajusta las coordenadas y parámetros según necesites

### Agregar Nueva Receta

1. Agrega la receta en la sección correspondiente de `Config.Recipes`
2. Define los ingredientes necesarios
3. Establece el tiempo de crafting y experiencia ganada

### Modificar Textos

Todos los textos están centralizados en `Config.Texts` para fácil traducción y personalización.

## Solución de Problemas

### El menú no aparece
- Verifica que ox_target esté funcionando correctamente
- Comprueba que las coordenadas de la estación sean correctas
- Asegúrate de tener los items requeridos

### Error al crear items
- Verifica que los items existan en `rsg-inventory`
- Comprueba que el jugador tenga espacio en el inventario
- Revisa los logs del servidor para errores específicos

### Blips no aparecen
- Verifica que las coordenadas sean válidas
- Comprueba que el sprite del blip exista
- Asegúrate de que `enabled = true` en la configuración

## Soporte

Para soporte o sugerencias, contacta al desarrollador o revisa los logs del servidor para información adicional.

## Versión

**Versión Actual**: 1.0.0
**Última Actualización**: Octubre 2025
