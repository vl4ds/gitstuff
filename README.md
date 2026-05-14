# U.S.S. Enterprise NCC-1701-D — H2D Print Build Log

Build log for a large-scale **Star Trek Galaxy-class U.S.S. Enterprise
NCC-1701-D** model, printed on a **Bambu Lab H2D** using **dual 0.6 mm
high-flow nozzles** and four colors of **PLA+** filament.

The H2D's IDEX dual-toolhead with high-flow hotends makes this print
fast (large nozzle, high volumetric flow) while still letting the
nacelle Bussard collectors, deflector dish, and registry typography be
called out in their own filaments without color-change purge towers
eating the whole spool.

---

## 1. Project overview

| | |
|---|---|
| Subject | U.S.S. Enterprise NCC-1701-D (Galaxy-class) |
| Target overall length | ~340 mm (assembled, fills the H2D plate) |
| Printer | Bambu Lab H2D, dual hotends |
| Nozzles | 2 × 0.6 mm high-flow (hardened steel recommended for PLA+) |
| Material | PLA+ (silver, red, blue, black) |
| Multi-color strategy | Two filaments per head via AMS; group parts by plate to minimize swaps |
| Total filament estimate | ~450–550 g across all plates (cosmetic infill) |

## 2. Source model

This repo ships `starship.scad` — a **parametric OpenSCAD** model of a
stylized explorer-class starship (original geometry, CC0). Classic
silhouette: saucer + secondary hull + twin nacelles on swept pylons,
with deflector dish, bridge dome, and impulse engines.

It is **not** a Galaxy-class replica — for an accurate NCC-1701-D mesh,
grab a fan model from Printables/Thingiverse/Cults3D under that
creator's license and update this section with the link.

### Generating the STLs

1. Install [OpenSCAD](https://openscad.org/) (or use the Bambu Studio
   OpenSCAD import).
2. Open `starship.scad` and set `length` for the assembled size
   (default `340` mm, fits the H2D plate with margin).
3. Set `part` to each piece in turn, Render (F6), and export STL:
   - `saucer`, `hull`, `neck`, `deflector`
   - `pylon_l`, `pylon_r`, `nacelle_l`, `nacelle_r`
   - `bussard_l`, `bussard_r`, `bridge`, `impulse`
4. Drop the STLs onto the plates per §6.

Or render the preview with `part = "assembled"` to sanity-check
proportions before slicing.

Headless export example (one STL per part):

```bash
for p in saucer hull neck deflector pylon_l pylon_r \
         nacelle_l nacelle_r bussard_l bussard_r bridge impulse; do
  openscad -o "stl/${p}.stl" -D "part=\"${p}\"" starship.scad
done
```

## 3. Hardware

- **Printer:** Bambu Lab H2D
- **Build volume:** 350 × 320 × 325 mm — drives the ~340 mm length target
- **Hotends:** dual 0.6 mm high-flow
- **Bed:** textured PEI (smooth PEI is fine but textured hides first-layer scars on the saucer underside)
- **AMS:** 1× AMS minimum; 2× AMS preferred so each head sees two colors without manual swaps

Head loadout recommendation:

| Head | Filament A | Filament B |
|---|---|---|
| Left | Silver (hull) | Black (typography) |
| Right | Blue (nacelles/deflector) | Red (accents) |

## 4. Materials — PLA+ filaments

| Color | Role |
|---|---|
| **Silver** | Saucer top & bottom, engineering hull, pylons, shuttlebay structure |
| **Red** | Impulse engines, phaser strips, registry trim, lifeboat hatch details |
| **Blue** | Warp nacelle Bussard collectors, warp grilles, main deflector dish |
| **Black** | Hull pennants, typography ("U.S.S. ENTERPRISE", "NCC-1701-D"), window strips |

Drying: PLA+ is less hygroscopic than nylon/PETG, but if a spool has
been open for weeks dry at **45 °C for 6 h** before printing — wet PLA+
shows up as stringing on the blue grille and matte specks on the
silver hull.

## 5. Slicer settings (Bambu Studio / Orca — 0.6 mm HF, PLA+)

Starting profile. Tune after the first calibration plate.

| Parameter | Value |
|---|---|
| Layer height | 0.32 mm (range 0.24–0.40) |
| Line width | 0.62 mm |
| Wall loops | 3 |
| Top / bottom layers | 5 / 4 |
| Infill | 12% gyroid |
| Outer wall speed | 200 mm/s |
| Inner wall / infill | 300 mm/s |
| Travel | 500 mm/s |
| Volumetric flow cap | ~24 mm³/s |
| Nozzle temp | 220 °C first layer, 215 °C after |
| Bed temp | 60 °C textured PEI |
| Part cooling fan | 100% from layer 3 |
| Aux fan | On (60–80%) |
| Supports | Tree (organic), only under nacelle pylons + deflector overhang |
| Seam position | Aligned, ventral centerline |
| Z-hop | 0.4 mm on retract over support interfaces |

Notes:
- 0.6 HF easily sustains 24 mm³/s of PLA+; keep the cap below the hotend's max so retractions stay clean during color changes.
- Outer wall is the speed that matters for visible detail — keep it down even if everything else is fast.

## 6. Plate layout & scaling

Split the model across four plates so each plate stays under the H2D
350 × 320 footprint and color changes are bounded.

| Plate | Parts | Colors loaded |
|---|---|---|
| 1 | Saucer top + saucer bottom (halved if needed) | Silver, Red, Black |
| 2 | Engineering hull (split fore/aft) | Silver, Red, Black |
| 3 | Both nacelles paired, Bussard caps separate | Silver, Blue, Red |
| 4 | Pylons + deflector dish + small detail parts | Silver, Blue, Red, Black |

Scaling: drop the source model into Bambu Studio, scale so the
assembled length is **340 mm** (or whatever fits with a 5 mm margin),
then split. Verify each plate's bounding box ≤ 340 × 310 mm before
slicing.

## 7. Color / part assignment summary

- Hull plating, pylons, shuttlebay: **silver**
- Impulse engines, phaser strips, registry/pennant fill, lifeboat strip: **red**
- Bussard collectors, warp grilles, main deflector: **blue**
- "U.S.S. ENTERPRISE" / "NCC-1701-D" lettering, window strips, dorsal pennants: **black**

If a part only needs one accent color, slice it as a single-color
object on a plate that's already loaded — don't add a filament you'll
purge once.

## 8. Assembly

Dry-fit order:

1. Engineering hull halves (CA glue + activator, clamp 30 s)
2. Pylons into engineering hull (check angle against reference photos before glue sets)
3. Nacelles onto pylons
4. Saucer halves
5. Saucer onto neck
6. Deflector dish into engineering hull recess

Pin recommendations: 2 mm carbon rod or brass pin at each pylon-to-hull
joint and at the saucer-to-neck interface. The pylon joints carry the
nacelle weight on a model this size — don't trust glue alone.

## 9. Post-processing

- Light sand at part seams with 400 → 800 grit
- Optional panel-line wash (thinned black enamel) — pulls out the
  aztec-style hull paneling
- Matte clear coat over the silver to kill the plastic sheen and
  unify the multi-part surface
- Decals vs printed typography: 0.6 nozzle prints letters down to
  ~3 mm tall cleanly; below that, use waterslide decals instead

## 10. Troubleshooting log

Fill this in as prints run:

- [ ] Stringing on blue (Bussard area) — lower temp by 5 °C or dry filament
- [ ] Bridging on warp grilles — add support blockers and rotate part
- [ ] First-layer adhesion on saucer underside — bump bed to 65 °C
- [ ] Color bleed at silver/red transitions — increase purge volume on that swap
- [ ] (add observations here)

## 11. Photos

Drop progress and finished shots in `images/` and link them here:

- `images/plate-1-saucer.jpg` — saucer fresh off the build plate
- `images/plate-3-nacelles.jpg` — Bussard caps in blue
- `images/assembly-dry-fit.jpg` — pre-glue dry assembly
- `images/final-front.jpg` — finished model, front three-quarter
- `images/final-top.jpg` — finished model, dorsal view
