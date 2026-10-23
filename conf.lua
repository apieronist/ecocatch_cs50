-- ============================================================================
-- Proyecto Final CS50: EcoCatch - Reciclaje Activo
-- Archivo: conf.lua
-- 
-- DECLARACIÓN DE ASISTENCIA DE IA:
-- Este código fue desarrollado con el apoyo de Gemini (herramienta de IA) 
-- para estructurar la configuración inicial de la ventana del juego. 
-- La arquitectura, diseño y autoría final del proyecto corresponden al alumno.
-- ============================================================================

function love.conf(t)
    t.identity = nil               
    t.appendidentity = false       
    t.title = "EcoCatch - Clasificación de Residuos" 
    t.window.width = 800           
    t.window.height = 600          
    t.window.resizable = false     
end
