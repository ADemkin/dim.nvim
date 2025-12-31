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
  if state.override then
    local ok, v = pcall(state.override)
    if ok and v ~= nil then
      if not is_valid_k(v) then
        vim.notify('dim.nvim: override() must return number in [0,1]', vim.log.levels.ERROR)
        return nil
      end
      return v
    end
  end

  local sched = state.schedule
  if not sched or #sched == 0 then
    return nil
  end

  local now = now_minutes()

  if now <= sched[1][1] then
    return sched[1][2]
  end

  if now >= sched[#sched][1] then
    return sched[#sched][2]
  end

  for i = 1, #sched - 1 do
    local a = sched[i]
    local b = sched[i + 1]
    if now >= a[1] and now <= b[1] then
      local t = (now - a[1]) / (b[1] - a[1])
      return lerp(a[2], b[2], t)
    end
  end

  return sched[#sched][2]
end

return resolve
