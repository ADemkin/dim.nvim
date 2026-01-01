local function patch_devicons()
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if ok and devicons and devicons.get_icon_color then
    local orig_get = devicons.get_icon_color

    devicons.get_icon_color = function(...)
      local icon, color = orig_get(...)
      if not color then
        return icon, color
      end

      local api = require('dim.api')
      local state = api.get_state()

      local k
      if state.tint ~= nil then
        k = state.tint
      else
        k = require('dim.resolve')(state) or 0
      end

      local tint = require('dim.tint')(k)
      return icon, tint(color)
    end
  end
end

return patch_devicons
