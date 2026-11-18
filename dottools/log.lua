Dot.w = function(msg)
  print(string.format("⚠️ \27[33m%s\27[0m", msg))
end

Dot.e = function(msg)
  print(string.format("🚨 \27[31m%s\27[0m", msg))
end
