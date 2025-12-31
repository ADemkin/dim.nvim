require('dim.commands')

local api = require('dim.api')
local state = require('dim.state')

local M = {}

local VALID_KEYS = {
  enabled = true,
  update_interval = true,
  schedule = true,
  override = true,
}

local function notify_err(msg)
  vim.notify('dim.nvim: ' .. msg, vim.log.levels.ERROR)
end

local function is_valid_time(k)
  if type(k) ~= 'string' then
    return false
  end
  local h, m = k:match('^(%d%d):(%d%d)$')
  h, m = tonumber(h), tonumber(m)
  return h and m and h >= 0 and h <= 23 and m >= 0 and m <= 59
end

local function to_minutes(k)
  local h, m = k:match('^(%d%d):(%d%d)$')
  return tonumber(h) * 60 + tonumber(m)
end

local function is_valid_k(v)
  return type(v) == 'number' and v >= 0 and v <= 1
end

local function normalize_schedule(tbl)
  local out = {}
  for k, v in pairs(tbl) do
    if not is_valid_time(k) then
      notify_err('invalid time key: ' .. tostring(k))
      return nil
    end
    if not is_valid_k(v) then
      notify_err('schedule value at ' .. k .. ' must be in [0,1]')
      return nil
    end
    table.insert(out, { to_minutes(k), v })
  end
  table.sort(out, function(a, b)
    return a[1] < b[1]
  end)
  return out
end

function M.setup(opts)
  opts = opts or {}

  for k in pairs(opts) do
    if not VALID_KEYS[k] then
      notify_err('unknown option: ' .. tostring(k))
      return
    end
  end

  if opts.enabled ~= nil then
    if type(opts.enabled) ~= 'boolean' then
      notify_err('enabled must be boolean')
      return
    end
    state.enabled = opts.enabled
  end

  if opts.update_interval ~= nil then
    if type(opts.update_interval) ~= 'number' then
      notify_err('update_interval must be number')
      return
    end
    state.update_interval = opts.update_interval
  end

  if opts.override ~= nil then
    if type(opts.override) ~= 'function' then
      notify_err('override must be function')
      return
    end
    state.override = opts.override
  end

  if opts.schedule ~= nil then
    if type(opts.schedule) ~= 'table' then
      notify_err('schedule must be table')
      return
    end
    local sched = normalize_schedule(opts.schedule)
    if not sched then
      return
    end
    state.schedule = sched
  end

  if state.enabled and state.schedule then
    api.start()
  else
    api.stop()
    api.apply()
  end
end

return M
