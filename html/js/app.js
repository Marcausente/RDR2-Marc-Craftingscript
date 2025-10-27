// Variables globales
let currentRecipes = [];
let playerData = {
    job: 'unemployed',
    level: 1,
    onDuty: false
};

let currentCrafting = null;
let craftingInterval = null;
let currentPage = 1;
const itemsPerPage = 6;

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
    console.log('[marc_crafting] Debug - Cantidad de recetas:', recipes.length);
    
    currentRecipes = recipes;
    renderRecipes();
}

// Actualizar información del jugador
function updatePlayerInfo() {
    document.getElementById('playerJob').textContent = getJobDisplayName(playerData.job);
    document.getElementById('stationLevel').textContent = playerData.stationLevel || 1;
}

// Obtener nombre de display del job
function getJobDisplayName(job) {
    const jobNames = {
        'vlarmory': 'Armería Valentine',
        'rharmory': 'Armería Rhodes',
        'taberna': 'Taberna',
        'unemployed': 'Desempleado'
    };
    return jobNames[job] || job;
}

// Renderizar recetas
function renderRecipes() {
    console.log('[marc_crafting] Debug - Renderizando recetas:', currentRecipes);
    
    const grid = document.getElementById('recipesGrid');
    grid.innerHTML = '';
    
    if (currentRecipes.length === 0) {
        grid.innerHTML = '<div style="text-align: center; color: #D2B48C; padding: 20px;">No hay recetas disponibles</div>';
        updatePagination();
        return;
    }
    
    currentRecipes.forEach((recipe, index) => {
        console.log('[marc_crafting] Debug - Creando tarjeta para receta:', recipe.name);
        const recipeCard = createRecipeCard(recipe, index);
        grid.appendChild(recipeCard);
    });
    
    currentPage = 1;
    showPage(1);
}

// Mostrar página específica
function showPage(page) {
    const totalPages = Math.ceil(currentRecipes.length / itemsPerPage);
    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    
    currentRecipes.forEach((recipe, index) => {
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
    const totalPages = Math.ceil(currentRecipes.length / itemsPerPage);
    const newPage = currentPage + direction;
    
    if (newPage >= 1 && newPage <= totalPages) {
        currentPage = newPage;
        showPage(currentPage);
    }
}

// Actualizar controles de paginación
function updatePagination() {
    const totalPages = Math.ceil(currentRecipes.length / itemsPerPage);
    document.getElementById('pageInfo').textContent = `Página ${currentPage} de ${totalPages}`;
    
    document.getElementById('prevPage').disabled = currentPage === 1;
    document.getElementById('nextPage').disabled = currentPage === totalPages || totalPages === 0;
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
            <span class="time-icon">⏱️</span>
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
            <h4 style="color: #F4E4BC; font-family: 'Cinzel', serif; margin-bottom: 10px;">${recipe.name}</h4>
            <p style="color: #D2B48C;">${recipe.description || 'Sin descripción'}</p>
        </div>
    `;
    
    // Lista de ingredientes
    document.getElementById('ingredientsList').innerHTML = `
        <div style="margin-bottom: 15px;">
            <h5 style="color: #D2B48C; margin-bottom: 10px;">Ingredientes necesarios:</h5>
            ${recipe.ingredients.map(ingredient => `
                <div style="display: flex; justify-content: space-between; padding: 5px 0; border-bottom: 1px solid rgba(101, 67, 33, 0.3);">
                    <span style="color: #F4E4BC;">${ingredient.item}</span>
                    <span style="color: ${hasIngredient(ingredient) ? '#90EE90' : '#FFB6C1'}; font-weight: 600;">
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
