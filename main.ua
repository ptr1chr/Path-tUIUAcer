┌─╴vec₃
  # vector operations
  Cross         ← ˜-˜∩×⟜⊸∩↻₁∩↻₁
  Dot           ← /+×
  LengthSquared ← /+˙×
  Length        ← √LengthSquared
  UnitVector    ← ˜÷⟜Length
└─╴
┌─╴ray
  PixelCentre ←
└─╴
# init grid
AspectRatio ← ÷16 9                      # aspect ratio
ImageWidth  ← 128                        # width number
Width       ← ÷⟜⇡ ImageWidth             # screen uv width
ImageHeight ← ↥1⁅÷AspectRatio ImageWidth # screen uv height
Height      ← ÷⟜⇡ ImageHeight            # height number
# Width Height
# ⊞(˜⊂0↻1⊂)

# Camera
┌─╴Cam
  FocalLength  ← 1
  ViewHeight   ← 2
  ViewWidth    ← × ViewHeight (÷ ImageWidth ImageHeight)
  CameraCentre ← 0_0_0
  # vectors across the viewport edges
  ViewPortU ← [ViewWidth 0 0]
  ViewPortV ← [0 ¯ViewHeight 0]
  # delta vectors between each pixel
  PixelDeltaU ← ÷ ViewPortU ImageWidth
  PixelDeltaV ← ÷ ViewPortV ImageHeight
  # location of top left pixel
  ViewPortUpperLeft ← - CameraCentre -[0 0 FocalLength] - (÷ ViewPortU 2) (÷ ViewPortV 2)
  TopLeftPixelLoc   ← ViewPortUpperLeft + ×0.5 (+ PixelDeltaU PixelDeltaV)
  # topleftpixelloc should be same as pixel00 loc in raytracing in one weekend
└─╴

┌─╴draw
  # create grid
  ⬚0↯ ⊂△Width△Height []
  # &ims # render image to term
  # &fwa "out/out.png" img"png" # image to file
└─╴
# 
