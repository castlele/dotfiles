local function w(msg)
  print(string.format("⚠️ \27[33m%s\27[0m", msg))
end

local function e(msg)
  print(string.format("🚨 \27[31m%s\27[0m", msg))
end

return {
  e = e,
  w = w,
}
