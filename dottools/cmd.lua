---@param self Dot
---@param cmd string
---@return T?, string? - returns result or error message
---@diagnostic disable-next-line: unused-local
Dot.exec = function(self, cmd)
  local handle, err = io.popen(cmd)

  if err or not handle then
    return nil, err
  end

  local result = handle:read("*l")

  handle:close()

  return result
end

---Equals to pwd in terminal
---@param self Dot
---@param proj string project name from with pwd is requested
---@return string?
Dot.pwd = function(self, proj)
  local res, err = self:exec("pwd")

  if err then
    self.e("got error during 'pwd' command execution: " .. err)
    return
  end

  if not res then
    self.e("can't get result of 'pwd' command")
    return
  end

  if proj then
    return res .. "/" .. proj
  end

  return res
end

---@param self Dot
---@param src string
---@param dst string
---@return number: result value. 0 is success
Dot.symlink = function(self, src, dst)
  local _, err = self:exec(string.format("ln -s %s %s", src, dst))

  if err then
    self.e("got error during symlink creation: " .. err)
    return -1
  end

  return 0
end

---@param self Dot
---@param code integer
---@diagnostic disable-next-line: unused-local
Dot.exit = function(self, code)
  os.exit(code)
end

---@param self Dot
---@param msg string
Dot.abort = function(self, msg)
  self.e(msg)
  self:exit(-1)
end

---@param self Dot
---@param package string
---@param cmd string?
---@return string?
Dot.installPackage = function(self, package, cmd)
  ---@type string
  local cmdName = ({
    darwin = "brew install"
  })[self.osType] or cmd

  if not cmdName then
    Dot:abort(string.format(
      "Unsupported ostype %s for package installation",
      cmdName
    ))
  end

  local installationCmd = string.format(
    "%s --quiet %s",
    cmdName, package
  )
  local _, err = self:exec(installationCmd)

  if err then
    self.e(
      string.format(
        "got error during '%s' command execution: %s",
        installationCmd, err
      ))
    return err
  end

  return nil
end
