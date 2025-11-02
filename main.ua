┌─╴vec₃
  # vector operations
  Cross         ← ˜-˜∩×⟜⊸∩↻₁∩↻₁
  Dot           ← /+×
  LengthSquared ← /+˙×
  Length        ← √LengthSquared
  UnitVector    ← ˜÷⟜(¤ Length)
└─╴
# init grid
AspectRatio ← ÷9 16                      # aspect ratio
ImageWidth  ← 400                        # width number
ImageHeight ← ↥1⁅÷AspectRatio ImageWidth # screen uv height

# Camera
┌─╴Cam
  FocalLength  ← 1
  ViewHeight   ← 2
  ViewWidth    ← × ViewHeight (÷ ImageHeight ImageWidth)
  CameraCentre ← 0_0_0
  # vectors across the viewport edges
  ViewPortU ← [ViewWidth 0 0]
  ViewPortV ← [0 ¯ViewHeight 0]
  # delta vectors between each pixel
  PixelDeltaU ← ÷ ImageWidth ViewPortU
  PixelDeltaV ← ÷ ImageHeight ViewPortV
  # location of top left pixel
  ViewPortUpperLeft ← ˜- ˜- - (÷ 2 ViewPortV) CameraCentre (÷ 2 ViewPortU) [0 0 FocalLength]
  TopLeftPixelLoc   ← + ViewPortUpperLeft ×0.5 (+ PixelDeltaU PixelDeltaV)
  # topleftpixelloc should be same as pixel00 loc in raytracing in one weekend
└─╴

≡× ¤ Cam~PixelDeltaV⇡ ImageHeight ≡× ¤ Cam~PixelDeltaU⇡ ImageWidth
+ ¤¤ Cam~TopLeftPixelLoc⊞+ # pixel centre
⍉ - Cam~CameraCentre°⍉     # ray direction

┌─╴Sphere
  Oc           ← -                     # centre - ray origin (pass ray origin then centre)
  A            ← ˙vec₃~Dot°⍉           # takes ray direction
  B            ← ×¯2 vec₃~Dot⊙°⍉ Oc    # takes ray origin, centre, ray direction
  C            ← - ⊓(˙×)(˙vec₃~Dot Oc) # self dot oc - radius^2
  Discriminant ← - ⊙(××4 ⊙A C) ˙×B     # takes ray origin, centre, ray dir, sphere radius, ray origin, centre, ray dir
  HitSphere    ← ≥0 Discriminant
└─╴
┌─╴ray
  SkyColour ← (
    ×0.5 +1 ≡≡(⊡1 vec₃~UnitVector)
    +≡≡⊃(×1_1_1¬)(×0.5_0.7_1)
  )
  Render ← (
    ⟜(SkyColour)
  
    0_0_0 [0 0 ¯ 1] ⟜(0.5 0_0_0 [0 0 ¯ 1] ∘)
    Sphere~HitSphere
    ⟜×
    ≡≡(×1_0_0) ¬
    +
  )
└─╴

ray~Render
# &ims # render image to term

# &fwa "out/out.png" img"png" # image to file
# 
