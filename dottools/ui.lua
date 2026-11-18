---Hides the cursor on `block` execution
---@param self Dot
---@param block fun()
---@diagnostic disable-next-line: unused-local
Dot.hideCursor = function(self, block)
  io.write("\27[?25l")
  block()
  io.write("\27[?25h\n")
end

---@param self Dot
---@param name string
---@param steps table<fun(): boolean>
Dot.progress = function(self, name, steps)
  local count = #steps

  if count == 0 then
    return
  end

  local width = 30
  local rawPrint = print
  local lines = 0

  ---@param part integer
  ---@return string
  local function getProgressBar(part)
    local filled = math.floor(width * part / count)
    local percent = part / count * 100

    return string.format(
      "[%s%s] %3d%%",
      string.rep("█", filled),
      string.rep("•", width - filled),
      percent
    )
  end

  ---@param part integer
  local function drawProgressBar(part)
    local up = lines + 1

    io.write(
      "\27[", up, "A",
      "\r",
      getProgressBar(part),
      "\27[", up, "B",
      "\r"
    )

    io.stdout:flush()
  end

  ---@param status boolean show wheather the progress was finished successfully
  local function drawStatus(status)
    local barLine = lines + 1
    ---@type string
    local statusMessage

    if status then
      statusMessage = string.format("✅ Done: %s", name)
    else
      statusMessage = string.format("❌ Done with error: %s", name)
    end

    io.write(
      "\27[", barLine, "A",
      "\27[M",
      "\27[", 1, "A",
      statusMessage,
      "\27[", lines, "B",
      "\r"
    )

    io.stdout:flush()
  end

  print = function(...)
    local parts = {}

    for i = 1, select("#", ...) do
      parts[i] = tostring((select(i, ...)))
    end

    local text = table.concat(parts, "\t")
    rawPrint(text)

    lines = lines + 1 + select(2, text:gsub("\n", "")) -- count embedded newlines
  end

  self:hideCursor(function()
    local status = true
    io.write(
      string.format("Executing: %s\n", name),
      getProgressBar(0),
      "\n"
    )
    io.stdout:flush()

    local ok, err = pcall(function()
      for index, step in ipairs(steps) do
        local stepStatus = step()

        if stepStatus ~= nil then
          status = stepStatus == true
        end

        drawProgressBar(index)
      end
    end)

    print = rawPrint

    if not ok then
      self.e(string.format("Execution finished with error: %s", err))
      lines = lines + 1
      status = false
    end

    drawStatus(status)
  end)
end
