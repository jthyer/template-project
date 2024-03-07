local jellyfishMove = {}

function jellyfishMove:load()
  self.sprite = global.getAsset("sprite","jellyfishMove")
end

function jellyfishMove:update(p)
  self.x = self.x - 1
end

return jellyfishMove