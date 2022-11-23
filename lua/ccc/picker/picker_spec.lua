local hex = require("ccc.picker.hex")
local css_rgb = require("ccc.picker.css_rgb")
local css_hsl = require("ccc.picker.css_hsl")
local css_hwb = require("ccc.picker.css_hwb")
local css_lab = require("ccc.picker.css_lab")
local css_lch = require("ccc.picker.css_lch")
local css_oklab = require("ccc.picker.css_oklab")
local css_oklch = require("ccc.picker.css_oklch")
local css_name = require("ccc.picker.css_name")

---@param module ColorPicker
---@param str string
---@param expect_rgb integer[] #range in [0-255]
---@param expect_alpha Alpha
local function test(module, str, expect_rgb, expect_alpha)
  local start, end_, rgb, alpha = module:parse_color(str)
  assert.equals(2, start)
  assert.equals(#str - 1, end_)
  ---@cast rgb RGB
  for i = 1, 3 do
    local diff = math.abs(rgb[i] - expect_rgb[i] / 255)
    assert.is_true(
      diff < 1 / 255,
      ("expect: rgb(%0.3f %0.3f %0.3f), actual: rgb(%0.3f %0.3f %0.3f)"):format(
        expect_rgb[1] / 255,
        expect_rgb[2] / 255,
        expect_rgb[3] / 255,
        rgb[1],
        rgb[2],
        rgb[3]
      )
    )
  end
  if expect_alpha == nil then
    assert.is_nil(alpha)
  else
    assert.equals(expect_alpha, alpha)
  end
end

describe("Color detection test", function()
  before_each(function()
    require("ccc").setup({})
  end)

  it("none", function()
    test(css_rgb, " rgb(255 none 255) ", { 255, 0, 255 }, nil)
  end)

  describe("hex", function()
    it("6 digits", function()
      test(hex, " #ffff00 ", { 255, 255, 0 }, nil)
    end)
    it("8 digits (with alpha)", function()
      test(hex, " #ffff0000 ", { 255, 255, 0 }, 0)
    end)
    it("3 digits", function()
      test(hex, " #ff0 ", { 255, 255, 0 }, nil)
    end)
    it("4 digits (with alpha)", function()
      test(hex, " #ff00 ", { 255, 255, 0 }, 0)
    end)
  end)

  describe("The RGB functions: rgb() and rgba()", function()
    it("Modern, rgb()", function()
      test(css_rgb, " rgb(255 0 255) ", { 255, 0, 255 }, nil)
      test(css_rgb, " rgb(255 0 255 / 0.8) ", { 255, 0, 255 }, 0.8)
      test(css_rgb, " rgb(100% 0% 100%) ", { 255, 0, 255 }, nil)
      test(css_rgb, " rgb(100% 0% 100% / 80%) ", { 255, 0, 255 }, 0.8)
    end)
    it("Modern, rgba()", function()
      test(css_rgb, " rgba(255 0 255) ", { 255, 0, 255 }, nil)
      test(css_rgb, " rgba(255 0 255 / 0.8) ", { 255, 0, 255 }, 0.8)
      test(css_rgb, " rgba(100% 0% 100%) ", { 255, 0, 255 }, nil)
      test(css_rgb, " rgba(100% 0% 100% / 80%) ", { 255, 0, 255 }, 0.8)
    end)
    it("Legacy, rgb()", function()
      test(css_rgb, " rgb(255, 0, 255) ", { 255, 0, 255 }, nil)
      test(css_rgb, " rgb(255, 0, 255, 0.8) ", { 255, 0, 255 }, 0.8)
      test(css_rgb, " rgb(100%, 0%, 100%) ", { 255, 0, 255 }, nil)
      test(css_rgb, " rgb(100%, 0%, 100%, 80%) ", { 255, 0, 255 }, 0.8)
    end)
    it("Legacy, rgba()", function()
      test(css_rgb, " rgba(255, 0, 255) ", { 255, 0, 255 }, nil)
      test(css_rgb, " rgba(255, 0, 255, 0.8) ", { 255, 0, 255 }, 0.8)
      test(css_rgb, " rgba(100%, 0%, 100%) ", { 255, 0, 255 }, nil)
      test(css_rgb, " rgba(100%, 0%, 100%, 80%) ", { 255, 0, 255 }, 0.8)
    end)
  end)

  describe("HSL Colors: hsl() and hsla() functions", function()
    it("Modern, hsl()", function()
      test(css_hsl, " hsl(180 50% 50%) ", { 63, 191, 191 }, nil)
      test(css_hsl, " hsl(180deg 50% 50% / 80%) ", { 63, 191, 191 }, 0.8)
      test(css_hsl, " hsl(200grad 50% 50% / 0.8) ", { 63, 191, 191 }, 0.8)
      test(css_hsl, " hsl(3.14rad 50% 50%) ", { 63, 191, 191 }, nil)
      test(css_hsl, " hsl(0.5turn 50% 50%) ", { 63, 191, 191 }, nil)
    end)
    it("Modern, hsla()", function()
      test(css_hsl, " hsla(180 50% 50%) ", { 63, 191, 191 }, nil)
      test(css_hsl, " hsla(180deg 50% 50% / 80%) ", { 63, 191, 191 }, 0.8)
      test(css_hsl, " hsla(200grad 50% 50% / 0.8) ", { 63, 191, 191 }, 0.8)
      test(css_hsl, " hsla(3.14rad 50% 50%) ", { 63, 191, 191 }, nil)
      test(css_hsl, " hsla(0.5turn 50% 50%) ", { 63, 191, 191 }, nil)
    end)
    it("Legacy, hsl()", function()
      test(css_hsl, " hsl(180, 50%, 50%) ", { 63, 191, 191 }, nil)
      test(css_hsl, " hsl(180deg, 50%, 50%, 80%) ", { 63, 191, 191 }, 0.8)
      test(css_hsl, " hsl(200grad, 50%, 50%, 0.8) ", { 63, 191, 191 }, 0.8)
      test(css_hsl, " hsl(3.14rad, 50%, 50%) ", { 63, 191, 191 }, nil)
      test(css_hsl, " hsl(0.5turn, 50%, 50%) ", { 63, 191, 191 }, nil)
    end)
    it("Legacy, hsla()", function()
      test(css_hsl, " hsla(180, 50%, 50%) ", { 63, 191, 191 }, nil)
      test(css_hsl, " hsla(180deg, 50%, 50%, 80%) ", { 63, 191, 191 }, 0.8)
      test(css_hsl, " hsla(200grad, 50%, 50%, 0.8) ", { 63, 191, 191 }, 0.8)
      test(css_hsl, " hsla(3.14rad, 50%, 50%) ", { 63, 191, 191 }, nil)
      test(css_hsl, " hsla(0.5turn, 50%, 50%) ", { 63, 191, 191 }, nil)
    end)
  end)

  describe("HWB Colors: hwb() function", function()
    it("hwb() without alpha", function()
      test(css_hwb, " hwb(180 30% 30%) ", { 77, 179, 179 }, nil)
      test(css_hwb, " hwb(180deg 30% 30%) ", { 77, 179, 179 }, nil)
      test(css_hwb, " hwb(200grad 30% 30%) ", { 77, 179, 179 }, nil)
      test(css_hwb, " hwb(3.14rad 30% 30%) ", { 77, 179, 179 }, nil)
      test(css_hwb, " hwb(0.5turn 30% 30%) ", { 77, 179, 179 }, nil)
    end)
    it("hwb() with alpha", function()
      test(css_hwb, " hwb(180 30% 30% / 0.8) ", { 77, 179, 179 }, 0.8)
      test(css_hwb, " hwb(180deg 30% 30% / 0.8) ", { 77, 179, 179 }, 0.8)
      test(css_hwb, " hwb(200grad 30% 30% / 0.8) ", { 77, 179, 179 }, 0.8)
      test(css_hwb, " hwb(3.14rad 30% 30% / 80%) ", { 77, 179, 179 }, 0.8)
      test(css_hwb, " hwb(0.5turn 30% 30% / 80%) ", { 77, 179, 179 }, 0.8)
    end)
  end)

  describe("Lab Color: lab() function", function()
    it("lab() without alpha", function()
      test(css_lab, " lab(60% 40% -20%) ", { 209, 109, 190 }, nil)
      test(css_lab, " lab(60 50 -25) ", { 209, 109, 190 }, nil)
    end)
    it("lab() with alpha", function()
      test(css_lab, " lab(60% 40% -20% / 80%) ", { 209, 109, 190 }, 0.8)
      test(css_lab, " lab(60 50 -25 / 0.8) ", { 209, 109, 190 }, 0.8)
    end)
  end)

  describe("LCH Color: lch() function", function()
    it("lch() without alpha", function()
      test(css_lch, " lch(60% 20% 270) ", { 108, 147, 197 }, nil)
      test(css_lch, " lch(60 30 270deg) ", { 108, 147, 197 }, nil)
      test(css_lch, " lch(60 30 300grad) ", { 108, 147, 197 }, nil)
      test(css_lch, " lch(60 30 4.71rad) ", { 108, 147, 197 }, nil)
      test(css_lch, " lch(60 30 0.75turn) ", { 108, 147, 197 }, nil)
    end)
    it("lch() with alpha", function()
      test(css_lch, " lch(60% 20% 270 / 80%) ", { 108, 147, 197 }, 0.8)
      test(css_lch, " lch(60 30 270deg / 0.8) ", { 108, 147, 197 }, 0.8)
      test(css_lch, " lch(60 30 300grad / 0.8) ", { 108, 147, 197 }, 0.8)
      test(css_lch, " lch(60 30 4.71rad / 0.8) ", { 108, 147, 197 }, 0.8)
      test(css_lch, " lch(60 30 0.75turn / 0.8) ", { 108, 147, 197 }, 0.8)
    end)
  end)

  describe("OKLab Color: oklab() function", function()
    it("oklab() without alpha", function()
      test(css_oklab, " oklab(50% 40% -40%) ", { 145, 29, 184 }, nil)
      test(css_oklab, " oklab(0.5 0.16 -0.16) ", { 145, 29, 184 }, nil)
    end)
    it("oklab() with alpha", function()
      test(css_oklab, " oklab(50% 40% -40% / 80%) ", { 145, 29, 184 }, 0.8)
      test(css_oklab, " oklab(0.5 0.16 -0.16 / 0.8) ", { 145, 29, 184 }, 0.8)
    end)
  end)

  describe("OKLCH Color: oklch() function", function()
    it("lch() without alpha", function()
      test(css_oklch, " oklch(60% 20% 270) ", { 109, 126, 177 }, nil)
      test(css_oklch, " oklch(0.6 0.08 270deg) ", { 109, 126, 177 }, nil)
      test(css_oklch, " oklch(0.6 0.08 300grad) ", { 109, 126, 177 }, nil)
      test(css_oklch, " oklch(0.6 0.08 4.71rad) ", { 109, 126, 177 }, nil)
      test(css_oklch, " oklch(0.6 0.08 0.75turn) ", { 109, 126, 177 }, nil)
    end)
    it("lch() with alpha", function()
      test(css_oklch, " oklch(60% 20% 270 / 80%) ", { 109, 126, 177 }, 0.8)
      test(css_oklch, " oklch(0.6 0.08 270deg / 0.8) ", { 109, 126, 177 }, 0.8)
      test(css_oklch, " oklch(0.6 0.08 300grad / 0.8) ", { 109, 126, 177 }, 0.8)
      test(css_oklch, " oklch(0.6 0.08 4.71rad / 0.8) ", { 109, 126, 177 }, 0.8)
      test(css_oklch, " oklch(0.6 0.08 0.75turn / 0.8) ", { 109, 126, 177 }, 0.8)
    end)
  end)

  it("Named Colors", function()
    test(css_name, " yellow ", { 255, 255, 0 }, nil)
    test(css_name, " yellowgreen ", { 154, 205, 50 }, nil)
  end)
end)
