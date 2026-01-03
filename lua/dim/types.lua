---@meta
---@diagnostic disable:unused-local

---@alias Amount number : Tint amount, from 0.0 to 1.0
---@alias TimeString string : time string in format "HH:MM"
---@alias Minute number : Minute number from day start (0-1439)

---@alias Schedule table<TimeString, Amount>
---@alias NormalizedSchedule {Minute, Amount}[]

---@alias Override fun(amount: Amount): Amount|nil

---@class DimOpts
---@field enabled boolean? : global on/off switch
---@field update_interval number? : sleep between timer ticks, ms
---@field schedule Schedule? : User input schedule
---@field override Override? : Override function

---@class DimState
---@field enabled boolean : global toggle switch
---@field tint Amount? : tint force, from 0 to 1
---@field timer uv.uv_timer_t? : update timer
---@field schedule NormalizedSchedule? : normalized schedule
---@field update_interval number : timer sleep interval
---@field override Override? : override(amount) -> number {0..1} or nil
---@field original_hl table<string, vim.api.keyset.highlight>? : original highlight groups

return {}
