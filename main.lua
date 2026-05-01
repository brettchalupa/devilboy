SPR = {
  PLAYER_RUN_1 = 1,
  PLAYER_RUN_2 = 2,
  BULLET = 3,
}
GRAVITY = 25
DIR = {
  EAST = 1,
  WEST = -1,
  NONE = 0,
}
SPR_SIZE = 16
Bullet = require("bullet")
Player = require("player")


function _config()
  return { name = "DEVILBOY", game_id = "com.brettmakesgames.devilboy", icon = 1 }
end

function _init()
  state = {
    p = Player.init(10, 10)
  }
end

function _update(dt)
  Player.update(dt, state.p)
end

function _draw(dt)
  gfx.clear(gfx.COLOR_INDIGO)
  gfx.text("DEVILBOY!", 260, 10, gfx.COLOR_WHITE)

  Player.draw(state.p)
end
