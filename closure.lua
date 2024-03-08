local class = {}

class.player = require("player")
class.wall = require("wall")

objects = {}

objects[1] = class["player"](68,100)
objects[2] = class["wall"](100,132)
objects[3] = class["wall"](132,132)
objects[4] = class["wall"](164,132)

