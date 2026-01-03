---@type DimState
local State = {
  enabled = false,
  tint = nil,
  timer = nil,
  schedule = nil,
  update_interval = 60 * 1000,
  override = nil,
  original_hl = nil,
}

return State
