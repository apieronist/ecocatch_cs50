# EcoCatch: Juego de Clasificación de Residuos

#### Video Demo: <URL-DE-TU-VIDEO-EN-YOUTUBE>

#### Descripción del Proyecto:
**EcoCatch** es un videojuego 2D desarrollado en Lua sobre el motor LÖVE2D (LÖVE). El objetivo del proyecto es concientizar sobre la correcta separación de residuos urbanos mediante una dinámica de juego fluida, ágil e intuitiva.

El jugador controla un contenedor en la parte inferior de la pantalla y debe recolectar los materiales reciclables (plásticos, cartón) y compostables (residuos orgánicos), evitando a toda costa capturar residuos peligrosos o tóxicos (como pilas), los cuales descuentan puntos y vidas.

---

### Arquitectura y Estructura del Código

El proyecto está organizado en una arquitectura limpia mediante una **máquina de estados finita** (Finite State Machine) gestionada principalmente en el archivo `main.lua`:

1. **`conf.lua`**:
   Configura los parámetros globales de la ventana del sistema (título, dimensiones de 800x600 y deshabilitación del redimensionado para mantener la proporción de las colisiones).

2. **`main.lua`**:
   Contiene todo el ciclo de vida del juego dividido en los callbacks principales de LÖVE2D:
   - **`love.load()`**: Inicializa las variables de estado (`gameState`), la estructura del jugador, las tablas de objetos y las configuraciones de puntuación.
   - **`love.update(dt)`**: Gestiona la física del juego, el movimiento continuo con delta time (`dt`), la generación aleatoria de elementos en intervalos regularizados (`spawnInterval`) y la detección de colisiones AABB (*Axis-Aligned Bounding Box*).
   - **`love.draw()`**: Renderiza dinámicamente los gráficos según el estado activo (`menu`, `playing`, `gameover`).
   - **`love.keypressed(key)`**: Maneja los eventos de teclado para la navegación en menús, el reinicio de partidas y la interrupción fluida del juego mediante la tecla `ESC`.

---

### Decisiones de Diseño y Desafíos Técnicos

- **Manejo de Estados (`gameState`)**: Se optó por una variable central para modularizar las pantallas de Menú, Juego Activo y Game Over. Esto evita que los cálculos de física o generación de entidades sigan corriendo en segundo plano mientras se visualizan las pantallas de menú.
- **Detección de Colisiones**: Se implementó una lógica AABB en Lua sin necesidad de librerías externas pesadas, asegurando un rendimiento ligero y eficiente en cualquier sistema operativo.
- **Control de Interrupción**: Se incorporó la escucha de la tecla `Escape` durante el juego activo para brindar control total al usuario sobre el flujo de la aplicación.

---

### Instrucciones de Ejecución

1. Descargar e instalar [LÖVE2D](https://love2d.org/).
2. Clonar este repositorio:
   ```bash
   git clone [https://github.com/apieronist/ecocatch_cs50.git](https://github.com/apieronist/ecocatch_cs50.git)