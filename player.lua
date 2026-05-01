local M = {
}
local elapsed = 0

function M.init(x, y)
  return {
    x = x,
    y = y,
    vel = {
      x = 0,
      y = 0,
    },
    run_s = 100,
    low_jump_s = 8,
    high_jump_s = 10,
    spr = 1,
    facing = DIR.EAST,
    jumping = false
  }
end

function M.update(dt, p)
  elapsed += dt

  local moving = false

  -- gravity
  p.vel.y += GRAVITY * dt

  if input.down(input.LEFT) then
    p.vel.x = -p.run_s * dt
    p.facing = DIR.WEST
    moving = true
  elseif input.down(input.RIGHT) then
    p.vel.x = p.run_s * dt
    p.facing = DIR.EAST
    moving = true
  else
    p.vel.x = 0
  end

  if not p.jumping and input.pressed(input.BTN1) then
    p.vel.y = -p.low_jump_s
    p.jumping = true
  elseif not p.jumping and input.pressed(input.BTN2) then
    p.vel.y = -p.high_jump_s
    p.jumping = true
  end

  if moving then
    -- cheap animation
    p.spr = elapsed * 4 % 2 + 1
  else
    p.spr = 1
  end

  -- clamping
  p.x += p.vel.x
  p.y += p.vel.y

  -- check if on the ground
  if p.y >= usagi.GAME_H - SPR_SIZE then
    p.y = usagi.GAME_H - SPR_SIZE
    p.jumping = false
  else
    p.jumping = true
  end
end

function M.draw(p)
  local flip_x = p.facing == DIR.WEST and true or false
  gfx.spr_ex(p.spr, p.x, p.y, flip_x, false)
end

return M
