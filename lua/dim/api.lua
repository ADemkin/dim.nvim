local dim = require('dim.dim')
local state = require('dim.state')
local tint_fn = require('dim.tint')
local resolve = require('dim.resolve')

local M = {}

---@param k Amount
---@return nil
local function apply_k(k)
  dim(tint_fn(k))
end

---@return nil
function M.apply()
  if not state.enabled then
    apply_k(0)
    return
  end

  if state.tint ~= nil then
    apply_k(state.tint)
    return
  end

  local v = resolve(state)
  if v ~= nil then
    apply_k(v)
    return
  end

  apply_k(0)
end

---@return nil
function M.enable()
  state.enabled = true
  M.apply()
end

---@return nil
function M.disable()
  state.enabled = false
  M.apply()
end

---@return nil
function M.toggle()
  state.enabled = not state.enabled
  M.apply()
end

---@param k Amount
---@return nil
function M.set_tint(k)
  state.tint = k
  state.enabled = true
  M.stop()
  M.apply()
end

---@return nil
function M.clear_tint()
  state.tint = nil
  M.apply()
end

---@return DimState
function M.get_state()
  return state
end

---@param schedule Schedule
---@param interval_ms number?
---@return nil
function M.set_schedule(schedule, interval_ms)
  state.schedule = schedule
  if interval_ms then
    state.update_interval = interval_ms
  end
end

---@return nil
function M.start()
  if state.timer then
    return
  end
  if not state.schedule then
    return
  end
  if state.tint ~= nil then
    state.tint = nil
  end

  state.timer = vim.uv.new_timer()
  state.timer:start(
    0,
    state.update_interval,
    vim.schedule_wrap(function()
      M.apply()
    end)
  )
end

---@return nil
function M.stop()
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end
end

---@return nil
function M.remove_original_hl()
  state.original_hl = nil
end

return M
