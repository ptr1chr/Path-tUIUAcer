┌─╴vec₃
  # vector operations
  Cross         ← ˜-˜∩×⟜⊸∩↻₁∩↻₁
  Dot           ← ≡₁/+×
  LengthSquared ← ≡₁/+˙×
  Length        ← √LengthSquared
  UnitVector    ← ˜÷⟜(Length)
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
  GetRayDir ← (
    ≡× ¤ Cam~PixelDeltaV⇡ ImageHeight ≡× ¤ Cam~PixelDeltaU⇡ ImageWidth
    + ¤¤ Cam~TopLeftPixelLoc⊞+ # pixel centre
    ⍉ - Cam~CameraCentre°⍉     # ray direction
  )
└─╴

┌─╴Sphere
  Oc ← ≡₁-                             # centre - ray origin (pass ray origin then centre)
  A  ← ≡₁vec₃~LengthSquared            # takes ray direction
  H  ← vec₃~Dot Oc                     # takes ray origin, centre, ray direction
  C  ← ˜- ⊓(vec₃~LengthSquared Oc)(˙×) # self dot oc - radius^2
  Discriminant ← (
    ◡(˙×H)

    ◡⋅⊙⊙⋅∘   # reorders so its 1 2 4 0 1 2 3 4
    ⊙⊙⊙⊙⋅⋅⊙◌ # should remove excess values
    ⊙⊙⊙˜⟜₂⋅◌
    × ⊙A C
    -
  ) # takes ray origin, centre, ray dir, sphere radius, ray origin, centre, ray dir
  HitSphere ← (
    # ⍣(˜÷ ˜- ⊃⊃(⊙◌ H)(√ Discriminant)(A⋅⋅⊙◌) ◡(≥0 Discriminant))(¯1)

    ◡(≥0 Discriminant)
    ⊙(˜÷ ˜- ⊃⊃(⊙◌ H)(√ Discriminant)(A⋅⋅⊙◌))
    ⨬(¯1)(∘)
  )
└─╴
┌─╴ray
  ~R {Origin Dir}
  SkyColour ← (
    ×0.5 +1 ≡≡(⊡1 vec₃~UnitVector)
    +≡≡⊃(×1_1_1¬)(×0.5_0.7_1)
  )
  At ← + × # requires T, ray dir, ray origin

  Render ← (
    ⟜(SkyColour ray~R~Dir)
    ⊙([0 0 ¯ 1] ⊙0.5 ray~R~Dir) ⊸ray~R~Origin
    ◡Sphere~HitSphere
    ⊃(⊙⋅⋅⊙◌)(⋅⊙⋅⋅◌)
    ⊃(>0)(
      ÷ 0.5 ≡₁-[0 0 ¯ 1] At
      ×0.5 +1
    )
    ×
    ⊸(=0)
    ⨬(⊙◌)(+)
  )

└─╴

ray~R (⬚0_0_0↯ [ImageHeight ImageWidth 3] 0) Cam~GetRayDir # init array, includes origin & dir

ray~Render

┌─╴save
  Show ← (
    &fwa "out/out.png" img"png"
    ⋅&ims °img &frab "out/out.png"
  ) # image to file
└─╴
save~Show
