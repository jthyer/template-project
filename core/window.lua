--[[
window.lua

Defines window information. values are static for now. 
May allow per-game editing in a later version of engine.
]]--

local window = {}

window.WINDOW_WIDTH = 640
window.WINDOW_HEIGHT = 480
window.TILE_DIMENSION = 16
window.current_width = window.WINDOW_WIDTH
window.current_height = window.WINDOW_HEIGHT

return window