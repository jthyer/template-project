local window = require("core.window")

function love.conf(t)
  t.window.width = window.WINDOW_WIDTH
  t.window.height = window.WINDOW_HEIGHT
end