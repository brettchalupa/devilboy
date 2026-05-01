local M = {
}
local elapsed = 0
local last_dir = DIR.NONE
local last_flip = false
local MAX_BULLETS = 20

function init_bullet_pool()
  local bullets = {}
  for i = 1, MAX_BULLETS do
    bullets[i] = Bullet.init(0, 0, DIR.EAST)
    bullets[i].alive = false
  end
  return bullets
end

function M.init(x, y)
  return {
    x = x,
    y = y,
    bullets = init_bullet_pool(),
    dir = DIR.NONE,
    facing = DIR.EAST,
    vel = {
      x = 0,
      y = 0,
    },
    run_s = 100,
    low_jump_s = 6,
    high_jump_s = 8,
    spr = 1,
    jumping = false
  }
end

function M.update(dt, p)
  elapsed += dt
  last_dir = p.dir

  local moving = false

  -- gravity
  p.vel.y += GRAVITY * dt

  if input.down(input.LEFT) then
    p.dir = DIR.WEST
    p.facing = p.dir
  elseif input.down(input.RIGHT) then
    p.dir = DIR.EAST
    p.facing = p.dir
  else
    p.dir = DIR.NONE
  end

  p.vel.x = p.dir * p.run_s * dt
  moving = p.dir ~= DIR.NONE

  if not p.jumping and input.pressed(input.BTN1) then
    p.vel.y = -p.low_jump_s
    p.jumping = true
  elseif not p.jumping and input.pressed(input.BTN2) then
    p.vel.y = -p.high_jump_s
    p.jumping = true
  end

  if input.pressed(input.BTN3) then
    for i = 1, MAX_BULLETS do
      local b = p.bullets[i]
      if not b.alive then
        p.bullets[i] = Bullet.init(p.x + (p.facing * 4), p.y, p.facing)
        break
      end
    end
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

  for i = 1, #p.bullets do
    local b = p.bullets[i]
    if b.alive then
      Bullet.update(dt, b)
    end
  end
end

function M.draw(p)
  local flip_x = p.facing == DIR.WEST
  gfx.spr_ex(p.spr, p.x, p.y, flip_x, false)

  for i = 1, #p.bullets do
    local b = p.bullets[i]
    if b.alive then
      Bullet.draw(b)
    end
  end

  if usagi.IS_DEV then
    local alive_bullets = 0
    for i = 1, MAX_BULLETS do
      if p.bullets[i].alive then
        alive_bullets += 1
      end
    end
    gfx.text("Alive Bullets: " .. alive_bullets .. "/" .. #p.bullets, 10, 10, gfx.COLOR_BLACK)
  end
end

return M
