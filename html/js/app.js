// Variables globales
let currentRecipes = {
    weapons: [],
    tools: [],
    materials: [],
    others: [],
    drinks: [],
    food: []
};
let currentCategory = 'tools'; // Categoría activa por defecto para generalstore
let playerData = {
    job: 'unemployed',
    level: 1,
    onDuty: false
};

let currentCrafting = null;
let craftingInterval = null;
let currentPage = 1;
const itemsPerPage = 6; // 2 columnas x 3 filas

// Inicialización
document.addEventListener('DOMContentLoaded', function() {
    // Asegurar que la interfaz esté oculta al cargar
    document.querySelector('.crafting-container').style.display = 'none';
    
    initializeEventListeners();
    // Los datos se cargarán desde el cliente Lua
});

// Event Listeners
function initializeEventListeners() {
    // Botón de cerrar
    document.getElementById('closeCrafting').addEventListener('click', closeCrafting);
    
    // Modal de confirmación
    document.getElementById('closeModal').addEventListener('click', closeModal);
    document.getElementById('cancelCraft').addEventListener('click', closeModal);
    document.getElementById('confirmCraft').addEventListener('click', confirmCrafting);
    
    // Barra de progreso
    document.getElementById('cancelProgress').addEventListener('click', cancelCrafting);
    
    // Paginación
    document.getElementById('prevPage').addEventListener('click', () => changePage(-1));
    document.getElementById('nextPage').addEventListener('click', () => changePage(1));
    
    // Cerrar modal con Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (document.getElementById('confirmModal').classList.contains('active')) {
                closeModal();
            } else if (document.getElementById('progressOverlay').classList.contains('active')) {
                cancelCrafting();
            } else {
                closeCrafting();
            }
        }
    });
}

// Cargar datos del jugador
function loadPlayerData(data) {
    playerData = { ...playerData, ...data };
    updatePlayerInfo();
}

// Cargar recetas
function loadRecipes(recipes) {
    console.log('[marc_crafting] Debug - Recetas recibidas:', recipes);
    console.log('[marc_crafting] Debug - Recetas de armas:', recipes.weapons ? recipes.weapons.length : 0);
    console.log('[marc_crafting] Debug - Recetas de otros:', recipes.others ? recipes.others.length : 0);
    
    currentRecipes = recipes;
    initializeTabs();
    renderRecipes();
}

// Actualizar información del jugador
function updatePlayerInfo() {
    document.getElementById('playerJob').textContent = getJobDisplayName(playerData.job);
    document.getElementById('stationLevel').textContent = `Nivel ${playerData.stationLevel || 'I'}`;
}

// Obtener nombre de display del job
function getJobDisplayName(job) {
    const jobNames = {
        'vlarmory': 'Armería Valentine',
        'rharmory': 'Armería Rhodes',
        'taberna': 'Taberna',
        'bwtabern': 'Taberna BW',
        'unemployed': 'Desempleado'
    };
    return jobNames[job] || job;
}

// Inicializar pestañas
function initializeTabs() {
    const tabsContainer = document.getElementById('categoryTabs');
    if (!tabsContainer) {
        console.error('No se encontró el contenedor de pestañas');
        return;
    }
    
    // Determinar qué categorías mostrar según las recetas disponibles
    let tabsHTML = '';
    
    if (currentRecipes.weapons && currentRecipes.weapons.length > 0) {
        tabsHTML += `<div class="tab ${currentCategory === 'weapons' ? 'active' : ''}" data-category="weapons">
            <span>Armas</span>
        </div>`;
    }
    
    if (currentRecipes.tools && currentRecipes.tools.length > 0) {
        tabsHTML += `<div class="tab ${currentCategory === 'tools' ? 'active' : ''}" data-category="tools">
            <span>Herramientas</span>
        </div>`;
    }
    
    if (currentRecipes.materials && currentRecipes.materials.length > 0) {
        tabsHTML += `<div class="tab ${currentCategory === 'materials' ? 'active' : ''}" data-category="materials">
            <span>Materiales</span>
        </div>`;
    }
    
    if (currentRecipes.others && currentRecipes.others.length > 0) {
        tabsHTML += `<div class="tab ${currentCategory === 'others' ? 'active' : ''}" data-category="others">
            <span>Otros</span>
        </div>`;
    }
    
    if (currentRecipes.food && currentRecipes.food.length > 0) {
        tabsHTML += `<div class="tab ${currentCategory === 'food' ? 'active' : ''}" data-category="food">
            <span>Comida</span>
        </div>`;
    }
    
    if (currentRecipes.drinks && currentRecipes.drinks.length > 0) {
        tabsHTML += `<div class="tab ${currentCategory === 'drinks' ? 'active' : ''}" data-category="drinks">
            <span>Bebidas</span>
        </div>`;
    }
    
    tabsContainer.innerHTML = tabsHTML;
    
    // Agregar event listeners a las pestañas
    tabsContainer.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', () => {
            const category = tab.dataset.category;
            switchCategory(category);
        });
    });
    
    // Establecer la categoría activa por defecto
    if (currentRecipes.weapons && currentRecipes.weapons.length > 0) {
        currentCategory = 'weapons';
    } else if (currentRecipes.food && currentRecipes.food.length > 0) {
        currentCategory = 'food';
    } else if (currentRecipes.drinks && currentRecipes.drinks.length > 0) {
        currentCategory = 'drinks';
    } else if (currentRecipes.others && currentRecipes.others.length > 0) {
        currentCategory = 'others';
    }
    
    // Actualizar pestañas activas
    tabsContainer.querySelectorAll('.tab').forEach(tab => {
        tab.classList.remove('active');
        if (tab.dataset.category === currentCategory) {
            tab.classList.add('active');
        }
    });
}

// Cambiar categoría
function switchCategory(category) {
    if (currentCategory === category) return;
    
    currentCategory = category;
    
    // Actualizar pestañas activas
    document.querySelectorAll('.tab').forEach(tab => {
        tab.classList.remove('active');
    });
    document.querySelector(`[data-category="${category}"]`).classList.add('active');
    
    // Renderizar recetas de la nueva categoría
    renderRecipes();
}

// Renderizar recetas
function renderRecipes() {
    console.log('[marc_crafting] Debug - Renderizando recetas de categoría:', currentCategory);
    
    const grid = document.getElementById('recipesGrid');
    grid.innerHTML = '';
    
    const recipes = currentRecipes[currentCategory] || [];
    
    if (recipes.length === 0) {
        grid.innerHTML = '<div style="text-align: center; color: #D2B48C; padding: 20px;">No hay recetas disponibles en esta categoría</div>';
        updatePagination();
        return;
    }
    
    recipes.forEach((recipe, index) => {
        console.log('[marc_crafting] Debug - Creando tarjeta para receta:', recipe.name);
        const recipeCard = createRecipeCard(recipe, index);
        grid.appendChild(recipeCard);
    });
    
    currentPage = 1;
    showPage(1);
}

// Mostrar página específica
function showPage(page) {
    const recipes = currentRecipes[currentCategory] || [];
    const totalPages = Math.ceil(recipes.length / itemsPerPage);
    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    
    recipes.forEach((recipe, index) => {
        const card = document.getElementById('recipesGrid').children[index];
        if (index >= start && index < end) {
            card.classList.remove('hidden');
        } else {
            card.classList.add('hidden');
        }
    });
    
    updatePagination();
}

// Cambiar página
function changePage(direction) {
    const recipes = currentRecipes[currentCategory] || [];
    const totalPages = Math.ceil(recipes.length / itemsPerPage);
    const newPage = currentPage + direction;
    
    if (newPage >= 1 && newPage <= totalPages) {
        currentPage = newPage;
        showPage(currentPage);
    }
}

// Actualizar controles de paginación
function updatePagination() {
    const recipes = currentRecipes[currentCategory] || [];
    const totalPages = Math.ceil(recipes.length / itemsPerPage);
    document.getElementById('pageInfo').textContent = `Página ${currentPage} de ${totalPages}`;
    
    document.getElementById('prevPage').disabled = currentPage === 1;
    document.getElementById('nextPage').disabled = currentPage === totalPages || totalPages === 0;
}

// Función para crear iconos SVG de armas realistas
function createWeaponSVG(type) {
    const svgs = {
        'revolver': `
            <svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg">
                <defs>
                    <linearGradient id="metalGrad" x1="0%" y1="0%" x2="0%" y2="100%">
                        <stop offset="0%" style="stop-color:#8B7355;stop-opacity:1" />
                        <stop offset="50%" style="stop-color:#A0826D;stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#6B5A47;stop-opacity:1" />
                    </linearGradient>
                </defs>
                <!-- Body -->
                <ellipse cx="30" cy="25" rx="12" ry="15" fill="url(#metalGrad)" stroke="#654321" stroke-width="2"/>
                <rect x="18" y="20" width="24" height="8" fill="#654321" rx="2"/>
                <!-- Cylinder -->
                <circle cx="30" cy="18" r="6" fill="url(#metalGrad)" stroke="#654321" stroke-width="1"/>
                <line x1="30" y1="12" x2="30" y2="24" stroke="#654321" stroke-width="1.5"/>
                <!-- Grip -->
                <path d="M 18 35 Q 18 45 22 48 Q 18 45 18 35" fill="#8B6F47" stroke="#654321" stroke-width="1.5"/>
                <path d="M 42 35 Q 42 45 38 48 Q 42 45 42 35" fill="#8B6F47" stroke="#654321" stroke-width="1.5"/>
                <!-- Barrel -->
                <rect x="28" y="8" width="4" height="12" fill="url(#metalGrad)" stroke="#654321" stroke-width="1.5" rx="1"/>
            </svg>
        `,
        'rifle': `
            <svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg">
                <defs>
                    <linearGradient id="woodGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                        <stop offset="0%" style="stop-color:#8B7355;stop-opacity:1" />
                        <stop offset="50%" style="stop-color:#A0826D;stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#6B5A47;stop-opacity:1" />
                    </linearGradient>
                </defs>
                <!-- Stock -->
                <path d="M 5 25 L 5 40 L 20 45 L 20 30 Z" fill="url(#woodGrad)" stroke="#654321" stroke-width="1.5"/>
                <!-- Barrel -->
                <rect x="20" y="28" width="32" height="4" fill="#654321" stroke="#8B7355" stroke-width="1"/>
                <!-- Action -->
                <rect x="30" y="25" width="12" height="10" fill="#8B7355" stroke="#654321" stroke-width="1.5" rx="1"/>
                <!-- Sights -->
                <rect x="48" y="27" width="2" height="6" fill="#654321"/>
                <rect x="25" y="27" width="2" height="6" fill="#654321"/>
            </svg>
        `,
        'knife': `
            <svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg">
                <defs>
                    <linearGradient id="steelGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                        <stop offset="0%" style="stop-color:#C0C0C0;stop-opacity:1" />
                        <stop offset="50%" style="stop-color:#E0E0E0;stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#A0A0A0;stop-opacity:1" />
                    </linearGradient>
                </defs>
                <!-- Blade -->
                <path d="M 10 15 L 30 5 L 45 35 L 25 45 Z" fill="url(#steelGrad)" stroke="#654321" stroke-width="1.5"/>
                <!-- Handle -->
                <path d="M 25 45 L 20 50 L 20 60 L 35 60 L 35 50 L 30 45 Z" fill="#8B6F47" stroke="#654321" stroke-width="1.5"/>
                <!-- Bolster -->
                <rect x="28" y="35" width="4" height="10" fill="#654321"/>
            </svg>
        `,
        'bow': `
            <svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg">
                <!-- Bow -->
                <path d="M 20 35 Q 30 10 40 35" fill="none" stroke="#8B6F47" stroke-width="3" stroke-linecap="round"/>
                <!-- String -->
                <line x1="20" y1="35" x2="40" y2="35" stroke="#654321" stroke-width="1.5"/>
                <!-- Arrow shaft -->
                <line x1="10" y1="35" x2="20" y2="35" stroke="#8B7355" stroke-width="2"/>
                <!-- Arrowhead -->
                <path d="M 10 35 L 5 32 L 5 38 Z" fill="#654321"/>
                <!-- Arrow fletching -->
                <path d="M 15 33 L 18 32 L 18 38 L 15 37 Z" fill="#8B6F47"/>
            </svg>
        `,
        'hatchet': `
            <svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg">
                <!-- Handle -->
                <rect x="30" y="35" width="20" height="3" fill="#8B6F47" stroke="#654321" stroke-width="1"/>
                <rect x="45" y="32" width="3" height="8" fill="#8B6F47" stroke="#654321" stroke-width="1"/>
                <!-- Axe head -->
                <path d="M 30 35 L 20 25 L 25 15 L 28 18 L 30 35 Z" fill="#C0C0C0" stroke="#654321" stroke-width="2"/>
                <path d="M 20 25 L 22 22 L 25 25 Z" fill="#8B6F47"/>
            </svg>
        `
    };
    
    return svgs[type] || svgs['revolver'];
}

// Mapear tipos de armas a SVG
function getWeaponSVGType(itemName) {
    if (itemName.includes('revolver') || itemName.includes('pistol')) return 'revolver';
    if (itemName.includes('rifle') || itemName.includes('repeater') || itemName.includes('shotgun') || itemName.includes('sniper')) return 'rifle';
    if (itemName.includes('knife') || itemName.includes('cleaver') || itemName.includes('machete')) return 'knife';
    if (itemName.includes('bow')) return 'bow';
    if (itemName.includes('tomahawk') || itemName.includes('hatchet')) return 'hatchet';
    return 'revolver';
}

// Obtener icono de arma
function getWeaponIcon(itemName) {
    const type = getWeaponSVGType(itemName);
    return createWeaponSVG(type);
}

// Crear tarjeta de receta
function createRecipeCard(recipe, index) {
    const card = document.createElement('div');
    card.className = 'recipe-card';
    card.style.animationDelay = `${index * 0.1}s`;
    
    // Las recetas ya vienen filtradas por nivel de estación desde el servidor
    // Todas las recetas mostradas se pueden craftear
    const canCraft = true;
    
    card.innerHTML = `
        <div class="recipe-header">
            <div class="recipe-name">${recipe.name}</div>
            <div class="recipe-level">Nivel ${recipe.requiredLevel}</div>
        </div>
        <div class="recipe-description">${recipe.description || 'Sin descripción'}</div>
        <div class="recipe-ingredients">
            <div class="ingredients-title">Ingredientes:</div>
            ${recipe.ingredients.map(ingredient => `
                <div class="ingredient-item">
                    <span class="ingredient-name">${ingredient.item}</span>
                    <span class="ingredient-amount ${hasIngredient(ingredient) ? 'has-item' : 'missing-item'}">
                        ${ingredient.amount}
                    </span>
                </div>
            `).join('')}
        </div>
        <div class="recipe-time">
            <span>Tiempo: ${formatTime(recipe.time)}</span>
        </div>
    `;
    
    // Todas las recetas mostradas se pueden craftear
    card.addEventListener('click', () => showConfirmModal(recipe));
    
    return card;
}

// Verificar si se puede crear la receta (ya no necesario, las recetas ya vienen filtradas)
function canCraftRecipe(recipe) {
    // Las recetas ya están filtradas por el servidor según el nivel de la estación
    // Solo verificar ingredientes en el momento del crafting
    return true;
}

// Verificar si tiene el ingrediente
function hasIngredient(ingredient) {
    // Por ahora retornamos true, pero se puede implementar verificación real
    // usando el callback 'checkIngredient' si es necesario
    return true;
}

// Formatear tiempo
function formatTime(milliseconds) {
    const seconds = Math.floor(milliseconds / 1000);
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
        return `${minutes}m ${remainingSeconds}s`;
    }
    return `${remainingSeconds}s`;
}

// Mostrar modal de confirmación
function showConfirmModal(recipe) {
    document.getElementById('modalTitle').textContent = `Confirmar: ${recipe.name}`;
    
    // Preview de la receta
    document.getElementById('recipePreview').innerHTML = `
        <div style="text-align: center; margin-bottom: 20px;">
            <h4 style="color: #1F1509; font-family: 'Cinzel', serif; margin-bottom: 10px;">${recipe.name}</h4>
            <p style="color: #2C1F13;">${recipe.description || 'Sin descripción'}</p>
        </div>
    `;
    
    // Lista de ingredientes
    document.getElementById('ingredientsList').innerHTML = `
        <div style="margin-bottom: 15px;">
            <h5 style="color: #1F1509; margin-bottom: 10px; font-weight: 700;">Ingredientes necesarios:</h5>
            ${recipe.ingredients.map(ingredient => `
                <div style="display: flex; justify-content: space-between; padding: 5px 0; border-bottom: 1px solid rgba(101, 67, 33, 0.3);">
                    <span style="color: #1F1509;">${ingredient.item}</span>
                    <span style="color: ${hasIngredient(ingredient) ? '#3A6B27' : '#8B2D2D'}; font-weight: 700;">
                        ${ingredient.amount}
                    </span>
                </div>
            `).join('')}
        </div>
    `;
    
    // Tiempo de crafting
    document.getElementById('craftingTime').textContent = formatTime(recipe.time);
    
    // Guardar receta actual
    currentCrafting = recipe;
    
    // Mostrar modal
    document.getElementById('confirmModal').classList.add('active');
}

// Cerrar modal
function closeModal() {
    document.getElementById('confirmModal').classList.remove('active');
    currentCrafting = null;
}

// Confirmar crafting
function confirmCrafting() {
    if (!currentCrafting) {
        console.error('currentCrafting es null');
        return;
    }
    
    // Guardar la receta antes de cerrar el modal
    const recipeToCraft = currentCrafting;
    
    closeModal();
    
    console.log('Enviando receta al servidor:', recipeToCraft);
    
    // NO iniciar la barra de progreso aquí, esperar confirmación del servidor
    // Solo enviar al cliente Lua y esperar su respuesta
    fetch(`https://${GetParentResourceName()}/startCrafting`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(recipeToCraft)
    }).then(resp => {
        console.log('Respuesta recibida:', resp);
        return resp.json();
    }).then(resp => {
        console.log('Callback completado:', resp);
    }).catch(err => {
        console.error('Error al iniciar crafting:', err);
    });
}

// Iniciar barra de progreso
function startCraftingProgress(recipe) {
    const progressOverlay = document.getElementById('progressOverlay');
    const progressFill = document.getElementById('progressFill');
    const progressText = document.getElementById('progressText');
    const progressTime = document.getElementById('progressTime');
    
    progressOverlay.classList.add('active');
    
    let progress = 0;
    const duration = recipe.time;
    const startTime = Date.now();
    
    craftingInterval = setInterval(() => {
        const elapsed = Date.now() - startTime;
        progress = Math.min(elapsed / duration, 1);
        
        progressFill.style.width = `${progress * 100}%`;
        progressText.textContent = `${Math.floor(progress * 100)}%`;
        
        const remaining = Math.max(0, duration - elapsed);
        progressTime.textContent = `Tiempo restante: ${formatTime(remaining)}`;
        
        if (progress >= 1) {
            clearInterval(craftingInterval);
            craftingInterval = null;
            completeCrafting();
        }
    }, 100);
}

// Completar crafting
function completeCrafting() {
    const progressOverlay = document.getElementById('progressOverlay');
    progressOverlay.classList.remove('active');
    
    // Mostrar notificación de éxito
    showNotification('¡Crafting completado!', 'success');
    
    // Enviar al cliente Lua
    fetch(`https://${GetParentResourceName()}/craftingCompleted`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(currentCrafting)
    }).then(resp => resp.json()).then(resp => {
        // Callback completado
    }).catch(err => {
        console.error('Error al completar crafting:', err);
    });
    
    currentCrafting = null;
}

// Cancelar crafting
function cancelCrafting() {
    if (craftingInterval) {
        clearInterval(craftingInterval);
        craftingInterval = null;
    }
    
    const progressOverlay = document.getElementById('progressOverlay');
    progressOverlay.classList.remove('active');
    
    // Enviar al cliente Lua
    fetch(`https://${GetParentResourceName()}/cancelCrafting`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(resp => {
        // Callback completado
    }).catch(err => {
        console.error('Error al cancelar crafting:', err);
    });
    
    currentCrafting = null;
}

// Cerrar crafting
function closeCrafting() {
    document.querySelector('.crafting-container').style.display = 'none';
    
    // Enviar callback al cliente Lua
    fetch(`https://${GetParentResourceName()}/closeCrafting`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(resp => {
        // Callback completado
    }).catch(err => {
        console.error('Error al cerrar crafting:', err);
    });
}

// Mostrar notificación
function showNotification(message, type = 'info') {
    // Crear elemento de notificación
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        background: ${type === 'success' ? '#228B22' : type === 'error' ? '#DC143C' : '#8B4513'};
        color: #F4E4BC;
        padding: 15px 25px;
        border-radius: 8px;
        border: 2px solid #654321;
        font-family: 'Cinzel', serif;
        font-weight: 600;
        z-index: 1003;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        animation: slideDown 0.3s ease;
    `;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Remover después de 3 segundos
    setTimeout(() => {
        notification.style.animation = 'slideUp 0.3s ease';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Eventos desde el cliente Lua
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch (data.type) {
        case 'showUI':
            document.querySelector('.crafting-container').style.display = 'block';
            break;
        case 'hideUI':
            document.querySelector('.crafting-container').style.display = 'none';
            break;
        case 'loadPlayerData':
            loadPlayerData(data.data);
            break;
        case 'loadRecipes':
            loadRecipes(data.data);
            break;
        case 'craftingConfirmed':
            // El servidor confirmó que puede comenzar, iniciar la barra de progreso
            console.log('[marc_crafting] Server confirmó crafting, datos:', data);
            if (data.data) {
                // Usar la receta enviada por el servidor
                startCraftingProgress(data.data);
            }
            break;
        case 'craftingCompleted':
            completeCrafting();
            break;
        case 'craftingFailed':
            if (craftingInterval) {
                clearInterval(craftingInterval);
                craftingInterval = null;
            }
            document.getElementById('progressOverlay').classList.remove('active');
            showNotification(data.message, 'error');
            currentCrafting = null;
            break;
    }
});

// CSS para animaciones de notificaciones
const style = document.createElement('style');
style.textContent = `
    @keyframes slideDown {
        from {
            transform: translateX(-50%) translateY(-100%);
            opacity: 0;
        }
        to {
            transform: translateX(-50%) translateY(0);
            opacity: 1;
        }
    }
    
    @keyframes slideUp {
        from {
            transform: translateX(-50%) translateY(0);
            opacity: 1;
        }
        to {
            transform: translateX(-50%) translateY(-100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);
