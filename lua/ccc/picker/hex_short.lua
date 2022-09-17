local sa = require("ccc.utils.safe_array")

---@class HexPicker: ColorPicker
local HexShortPicker = {
    pattern = "#(%x)(%x)(%x)",
}

---@param s string
---@return integer start
---@return integer end_
---@return integer[] RGB
---@overload fun(self: HexPicker, s: string): nil
function HexShortPicker.parse_color(s)
    local start, end_, cap1, cap2, cap3 = s:find(HexShortPicker.pattern)
    if start == nil then
        ---@diagnostic disable-next-line
        return nil
    end
    local RGB = sa.new({ cap1, cap2, cap3 })
        :map(function(c)
            return tonumber(c .. c, 16)
        end)
        :unpack()
    return start, end_, RGB
end

return HexShortPicker
