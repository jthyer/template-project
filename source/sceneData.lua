local sceneData = {}
local private = {}
local json = require("library.json")

local NUMSCENES = 1
local TILEWIDTH = global.WINDOW_WIDTH / global.TILE_DIMENSION
local TILEHEIGHT = global.WINDOW_HEIGHT / global.TILE_DIMENSION

function private.sceneLoad()
  for scene = 1,NUMSCENES do
    table.insert(sceneData,{})
   
    local raw = love.filesystem.read("scene/scene"..tostring(scene)..".json")
    local jsonData = json.decode(raw)
  
    private.loadTiles(scene,jsonData)
    private.loadObjects(scene,jsonData)
  end
end

function private.loadTiles(scene,jsonData)
  sceneData[scene].tileData = {} 
  
  for i = 1, TILEHEIGHT do
    local row = {}
    for i2 = 1, TILEWIDTH do
      local coord = jsonData["layers"][1]["data"][i2+((i-1)*TILEWIDTH)]
      table.insert(row,coord)
    end
    table.insert(sceneData[scene].tileData,row)
  end
end

function private.loadObjects(scene,jsonData)
  sceneData[scene].objectData = {}
  
  -- load solids
  --  The only reason these are a separate layer is that ogmo doesn't
  --  let me click and drag to create many "entities", so I have to 
  --  make these in tile mode if I want to easily draw a bunch of them.
  for i = 1, TILEHEIGHT do
    local row = {}
    for i2 = 1, TILEWIDTH do
      local coord = jsonData["layers"][2]["data"][i2+((i-1)*TILEWIDTH)]
      if coord == 0 then
        local object = {}
        object.class = "wall"
        object.x = (i2-1)*16
        object.y = (i-1)*16
        table.insert(sceneData[scene].objectData,object)
      end
    end
  end
  
  -- load entity objects
  for key,v in pairs(jsonData["layers"][3]["entities"]) do
    local object = {}
    object.class = v["name"]
    object.x = v["x"]
    object.y = v["y"]
    table.insert(sceneData[scene].objectData,object)
  end
end

private.sceneLoad()

return sceneData