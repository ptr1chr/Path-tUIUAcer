# Experimental!
┌─╴vec₃
  # vector operations
  Cross         ← ˜-˜∩×⟜⊸∩↻₁∩↻₁
  Dot           ← ≡₁/+×
  LengthSquared ← ≡₁/+˙×
  Length        ← √LengthSquared
  UnitVector    ← ÷⊸(Length)
  RandUnitVec   ← (÷ ⊸Length ⍢⋅(-⊸¬⍥(⚂)3)(×⊃(>1)(>1e-160) LengthSquared) ∞)
  SampleSquare  ← ([-0.5 ⚂ -0.5 ⚂ 0])
└─╴
# init grid
AspectRatio ← ÷9 16                      # aspect ratio
ImageWidth  ← 400                        # width number
ImageHeight ← ↥1⁅÷AspectRatio ImageWidth # screen uv height

# Camera
┌─╴Cam
  Samples      ← 100
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
    ≡× ¤ Cam~PixelDeltaV ⇡ ImageHeight ≡× ¤ Cam~PixelDeltaU⊸⇡ ImageWidth
    +¤¤×[÷ ImageWidth ViewWidth÷ ImageHeight ¯ViewHeight 0]vec₃~SampleSquare + ¤¤ Cam~TopLeftPixelLoc⊞+ # pixel centre
    ⍉ - Cam~CameraCentre°⍉                                                                              # ray direction
  )
└─╴

┌─╴ray
  ~R {Origin Dir}
  SkyColour ← (
    ×0.5 +1 ≡≡(⊡1 vec₃~UnitVector)
    +≡≡⊃(×1_1_1¬)(×0.5_0.7_1)
  )
  At   ← + × # requires T, ray dir, ray origin
  TMin ← 0.00000001
  TMax ← ∞
└─╴
┌─╴Sphere
  Oc ← ≡₁-                             # centre - ray origin (pass ray origin then centre)
  A  ← ≡₁vec₃~LengthSquared            # takes ray direction
  H  ← vec₃~Dot Oc                     # takes ray origin, centre, ray direction
  C  ← ˜- ⊓(vec₃~LengthSquared Oc)(˙×) # self dot oc - radius^2
  ~HitResult {T P Normal M}
  Discriminant ← (
    ◡(˙×H)

    ◡⋅⊙⊙⋅∘   # reorders so its 1 2 4 0 1 2 3 4
    ⊙⊙⊙⊙⋅⋅⊙◌ # should remove excess values
    ⊙⊙⊙˜⟜₂⋅◌
    × ⊙A C
    -
  ) # takes ray origin, centre, ray dir, sphere radius

  HitSphere ← (
    ◡(
      ⊃(
      | (≥0 Discriminant) # mask if hit occurred
      | (⊃(
          | $root (˜÷ ˜- ⊃⊃(⊙◌ H)(√ Discriminant)(A⋅⋅⊙◌))   # close "root", or rec.t
          | $roottwo (˜÷ + ⊃⊃(⊙◌ H)(√ Discriminant)(A⋅⋅⊙◌)) # far "root", or rec.t
          )
         ◡⊃(
          | (>ray~TMin)
          | (𝄐˜<)
          ))
        ×

        ⨬(⋅∘)(⊙◌)
      )

      ⨬(¯ 100000)(∘)
    )

    ⊃((⊙⋅⋅⋅⊙◌)|(⋅⋅⊙⋅⋅⋅∘)|(⋅⋅⋅⊙⋅∘))

    ⊃(
    | ∘
    | ray~At
    | (
        ⊃(
        | (⋅∘)
        | (˜÷ ≡₁- ⊃((⋅⋅⋅⋅∘)|(ray~At)|(⋅⋅⋅⋅⋅∘)))
        )
        ◡(>0 vec₃~Dot)
        × ⊙⋅∘ ¬
      )
    | (>ray~TMin)
    | < ⊃(⋅⋅⋅∘)(∘)
    )

    ⊙⊙⊙×

    HitResult
  )
└─╴
┌─╴thing
  HitAllSpheres ← |3 (
    [
      ⊃(
      | Sphere~HitSphere ⊙([0 0 ¯ 1] ⊙0.5 ray~R~Dir) ⊸ray~R~Origin
      | Sphere~HitSphere ⊙([0.5 ¯ 0.4 ¯ 1.3] ⊙0.4 ray~R~Dir) ⊸ray~R~Origin
      | Sphere~HitSphere ⊙([0 ¯ 100.5 ¯ 1] ⊙100 ray~R~Dir) ⊸ray~R~Origin
      )
    ]
    /(
      ⊃(
        < ⨬(100000)(∘) ⊃(Sphere~HitResult~M)(∩(⌵ Sphere~HitResult~T))
      )(∩(°□₄))
      □₄ ⨬(⊙⊙⊙⊙⋅⋅⋅◌)(⋅⋅⋅⋅⊙⊙⊙∘)
    )
    °□₄

    ⊃(¬↥ ⊙(>100) ⋅⋅⋅⊙∘)(⊙⊙⊙⊙∘)

    ⨬(⊃(
      | □₂⊃(⋅∘)(× -⊸¬ >0 ⤚vec₃~Dot vec₃~RandUnitVec ⋅⋅∘)
      | ∘
      | +1 ⋅⋅⋅⋅∘
      ) # recursion values, should be the hit location, a random vector that is facing the same hemisphere as the normal and the T value of the hit
      HitAllSpheres
    )(⋅⋅⋅⋅∘)
  )

  Render ← (
    ⊃(
    | (HitAllSpheres⊙⊙0)
    | (ray~SkyColour ray~R~Dir))

    ⊸(=0)
    ⊙(≡₀˙(⊂⊂)˜ⁿ0.5)

    ⨬(×0.5 +1 ⊙◌)(⋅∘)
    ⊸(=0)
    ⨬(√)(∘)
    &p"rendered frame"
  )

└─╴

⍥(ray~R (⬚0_0_0↯ [ImageHeight ImageWidth 3] 0) Cam~GetRayDir # init array, includes origin & dir
  ⊙ray~TMax                                                  # max interval for ray hit

  thing~Render
)Cam~Samples
÷ Cam~Samples /+
┌─╴save
  Show ← (
    &fwa "out/out.png" img"png"
    ⋅&ims °img &frab "out/out.png"
  ) # image to file
└─╴
save~Show
