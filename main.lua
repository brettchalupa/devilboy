local Player = require "player"

GRAVITY = 25
DIR = {
  EAST = "EAST",
  WEST = "WEST",
}
SPR_SIZE = 16

function _config()
  return { name = "DEVILBOY", game_id = "com.brettmakesgames.devilboy" }
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
  gfx.text("Hello, DEVILBOY!", 10, 10, gfx.COLOR_WHITE)

  Player.draw(state.p)
end
