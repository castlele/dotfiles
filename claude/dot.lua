--- Steps:
--- 1. create a symlink to .claude
local function init(name)
  local pwd = Dot:pwd(name)

  if not pwd then
    Dot:w("can't get path to the project, skipping: " .. name)
    return
  end

  local src = pwd .. "/.claude"
  local dst = Dot.home .. "/.claude"
  Dot:symlink(src, dst)
end

return {
  init = init,
}
