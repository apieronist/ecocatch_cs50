-- ============================================================================
-- Proyecto Final CS50: EcoCatch - Reciclaje Activo
-- Archivo: main.lua
-- 
-- DECLARACIÓN DE ASISTENCIA DE IA:
-- Este código fue desarrollado con el apoyo de Gemini (herramienta de IA) 
-- para estructurar la lógica del bucle de juego (love.load, love.update, 
-- love.draw), la gestión de estados (menu, playing, gameover) y las 
-- rutinas de colisión y partículas. La arquitectura, diseño y autoría final 
-- del proyecto corresponden al alumno.
-- ============================================================================

-- EcoCatch - Reciclaje Activo con Fondo Colorido y Animado (CS50 Final Project)

function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("EcoCatch - Clasificación de Residuos")

    gameState = "menu"

    -- Cargar la imagen del contenedor (cesto)
    success, cestoImg = pcall(love.graphics.newImage, "assets/cesto.png")
    
    local cestoH = 70 
    if success and cestoImg then
        local imgW = cestoImg:getWidth()
        local imgH = cestoImg:getHeight()
        cestoH = 160 * (imgH / imgW)
    else
        cestoImg = nil 
    end

    player = {
        x = 320,
        y = 500,
        width = 160,
        height = cestoH,
        speed = 480
    }

    items = {}
    score = 0
    lives = 3
    spawnTimer = 0
    spawnInterval = 1.2

    -- Partículas de fondo animadas para dar dinamismo (asistido por IA)
    bgParticles = {}
    for i = 1, 20 do
        table.insert(bgParticles, {
            x = math.random(0, 800),
            y = math.random(0, 600),
            radius = math.random(6, 18),
            speed = math.random(25, 60),
            alpha = math.random(15, 35) / 100
        })
    end

    -- Tipos de residuos con sus respectivas imágenes cargadas
    itemTypes = {
        { 
            name = "Botella Plastica", 
            category = "recyclable", 
            img = (pcall(love.graphics.newImage, "assets/botella.png") and love.graphics.newImage("assets/botella.png") or nil), 
            points = 10 
        },
        { 
            name = "Papel/Carton",    
            category = "recyclable", 
            img = (pcall(love.graphics.newImage, "assets/carton.png") and love.graphics.newImage("assets/carton.png") or nil), 
            points = 10 
        },
        { 
            name = "Residuo Organico",
            category = "organic",    
            img = (pcall(love.graphics.newImage, "assets/organico.png") and love.graphics.newImage("assets/organico.png") or nil), 
            points = 15 
        },
        { 
            name = "Pila / Toxico",   
            category = "danger",     
            img = (pcall(love.graphics.newImage, "assets/pila.png") and love.graphics.newImage("assets/pila.png") or nil), 
            points = -20 
        }
    }
end

function love.update(dt)
    if gameState == "playing" then
        -- Animar partículas de fondo (suben suavemente)
        for _, p in ipairs(bgParticles) do
            p.y = p.y - p.speed * dt
            if p.y < -20 then
                p.y = 620
                p.x = math.random(0, 800)
            end
        end

        -- Movimiento del jugador
        if love.keyboard.isDown("left") and player.x > 0 then
            player.x = player.x - player.speed * dt
        end
        if love.keyboard.isDown("right") and player.x < 800 - player.width then
            player.x = player.x + player.speed * dt
        end

        -- Generación de elementos
        spawnTimer = spawnTimer + dt
        if spawnTimer >= spawnInterval then
            spawnTimer = 0
            local template = itemTypes[math.random(#itemTypes)]
            table.insert(items, {
                x = math.random(60, 720),
                y = -50,
                width = 45,
                height = 45,
                speed = math.random(170, 260),
                name = template.name,
                category = template.category,
                img = template.img,
                points = template.points
            })
        end

        -- Actualizar elementos y colisiones AABB
        for i = #items, 1, -1 do
            local item = items[i]
            item.y = item.y + item.speed * dt

            -- Colisión con el contenedor
            if item.x + item.width > player.x and item.x < player.x + player.width and
               item.y + item.height > player.y and item.y < player.y + player.height then
                
                score = score + item.points
                if item.category == "danger" then
                    lives = lives - 1
                end
                table.remove(items, i)

            -- Si cae al suelo sin ser atrapado
            elseif item.y > 600 then
                if item.category == "recyclable" or item.category == "organic" then
                    lives = lives - 1
                end
                table.remove(items, i)
            end
        end

        if lives <= 0 then
            gameState = "gameover"
        end
    end
end

function love.draw()
    if gameState == "menu" then
        love.graphics.setColor(0.1, 0.25, 0.4)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("ECOCATCH: RECICLAJE ACTIVO", 0, 160, 800, "center")
        love.graphics.printf("Atrapa reciclables y orgánicos. ¡Evita las pilas y tóxicos!", 0, 220, 800, "center")
        
        love.graphics.setColor(0.2, 0.8, 0.4)
        love.graphics.rectangle("fill", 300, 340, 200, 50, 8, 8)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Presiona ENTER para Jugar", 0, 355, 800, "center")

    elseif gameState == "playing" then
        -- 1. Fondo colorido y alegre (Tono verde/celeste suave)
        love.graphics.setColor(0.82, 0.94, 0.88)
        love.graphics.rectangle("fill", 0, 0, 800, 600)

        -- 2. Dibujar partículas animadas de fondo
        for _, p in ipairs(bgParticles) do
            love.graphics.setColor(0.2, 0.6, 0.4, p.alpha)
            love.graphics.circle("fill", p.x, p.y, p.radius)
        end

        -- Interfaz de puntaje y vidas (Texto oscuro para contraste con el fondo claro)
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.print("Flechas para mover | [ESC] para volver al Menú", 20, 15)
        love.graphics.print("Puntaje: " .. score, 20, 45)
        love.graphics.print("Vidas: " .. lives, 700, 45)

        -- Dibujar Contenedor del Jugador
        if cestoImg then
            love.graphics.setColor(1, 1, 1)
            local scale = player.width / cestoImg:getWidth()
            love.graphics.draw(cestoImg, player.x, player.y, 0, scale, scale)
        else
            love.graphics.setColor(0.15, 0.5, 0.3)
            love.graphics.rectangle("fill", player.x, player.y, player.width, player.height, 6, 6)
        end

        -- Dibujar Elementos que caen
        for _, item in ipairs(items) do
            if item.img then
                love.graphics.setColor(1, 1, 1)
                local scale = item.width / item.img:getWidth()
                love.graphics.draw(item.img, item.x, item.y, 0, scale, scale)
            else
                if item.category == "danger" then
                    love.graphics.setColor(0.9, 0.2, 0.2)
                else
                    love.graphics.setColor(0.2, 0.6, 0.9)
                end
                love.graphics.rectangle("fill", item.x, item.y, item.width, item.height, 4, 4)
            end
        end

    elseif gameState == "gameover" then
        love.graphics.setColor(0, 0, 0, 0.85)
        love.graphics.rectangle("fill", 0, 0, 800, 600)

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("¡JUEGO TERMINADO!", 0, 180, 800, "center")
        love.graphics.printf("Puntaje Final: " .. score, 0, 240, 800, "center")
        love.graphics.printf("Presiona R para reiniciar o M para ir al Menú", 0, 320, 800, "center")
    end
end

function love.keypressed(key)
    if gameState == "menu" then
        if key == "return" then
            gameState = "playing"
            score = 0
            lives = 3
            items = {}
        end
    elseif gameState == "playing" then
        if key == "escape" then
            gameState = "menu"
        end
    elseif gameState == "gameover" then
        if key == "r" then
            gameState = "playing"
            score = 0
            lives = 3
            items = {}
        elseif key == "m" then
            gameState = "menu"
        end
    end
end