local M = {
}

function M.init(x, y, dir)
  return {
    x = x,
    y = y,
    alive = true,
    spd = 200, -- px/sec
    dir = dir,
    vel = {
      x = 0,
      y = 0,
    }
  }
end

function M.update(dt, b)
  if not b.alive then
    return
  end

  b.vel.x = b.dir * b.spd * dt

  b.x += b.vel.x
  b.y += b.vel.y

  if b.x < 0 - SPR_SIZE or b.x > usagi.GAME_W then
    b.alive = false
  end
end

function M.draw(b)
  local flip_x = b.dir == DIR.WEST
  gfx.spr_ex(SPR.BULLET, b.x, b.y, flip_x, false)
end

return M
