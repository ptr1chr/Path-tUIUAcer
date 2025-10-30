┌─╴vec₃
  # vector operations
  Cross         ← ˜-˜∩×⟜⊸∩↻₁∩↻₁
  Dot           ← /+×
  LengthSquared ← /+˙×
  Length        ← √LengthSquared
  UnitVector    ← ˜÷⟜Length
└─╴
# init grid
AspectRatio ← ÷16 9                      # aspect ratio
ImageWidth  ← 128                        # width number
Width       ← ÷⟜⇡ ImageWidth             # screen uv width
ImageHeight ← ↥1⁅÷AspectRatio ImageWidth # screen uv height 
Height      ← ÷⟜⇡ ImageHeight            # height number
Width Height
⊞(˜⊂0↻1⊂)

# init viewport values
ViewHeight ← 2
ViewWidth  ← × ViewHeight (÷ ImageWidth ImageHeight)

# Camera

&ims # render image to term
# &fwa "out/out.png" img"png" # image to screen
