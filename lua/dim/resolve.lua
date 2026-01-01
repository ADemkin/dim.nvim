local function now_minutes()
  local t = os.date('*t')
  return t.hour * 60 + t.min
end

local function lerp(a, b, t)
  return a + (b - a) * t
end

local function is_valid_k(v)
  return type(v) == 'number' and v >= 0 and v <= 1
end

local function resolve(state)
  local base = 0

  -- base from schedule
  local schedule = state.schedule
  if schedule and #schedule > 0 then
    local now = now_minutes()

    if now <= schedule[1][1] then
      base = schedule[1][2]
    elseif now >= schedule[#schedule][1] then
      base = schedule[#schedule][2]
    else
      for i = 1, #schedule - 1 do
        local a = schedule[i]
        local b = schedule[i + 1]
        if now >= a[1] and now <= b[1] then
          local t = (now - a[1]) / (b[1] - a[1])
          base = lerp(a[2], b[2], t)
          break
        end
      end
    end
  end

  -- override as filter
  if state.override then
    local ok, v = pcall(state.override, base)
    if ok and v ~= nil then
      if not is_valid_k(v) then
        vim.notify('dim.nvim: override() must return number in [0,1] or nil', vim.log.levels.ERROR)
      else
        base = v
      end
    end
  end

  return base
end

return resolve
