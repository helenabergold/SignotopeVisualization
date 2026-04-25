# SignotopeVisualization

Visualization tools for **signotopes** — combinatorial objects that generalize oriented matroids and appear in the study of point configurations, hyperplane arrangements, and related structures.

## Repository Structure

The repository contains two components:

- **`examples/`** — signotope data files (rank 3 and rank 4) used as input for the visualization scripts
- **`zonotopal_tiling/`** — visualization via rhombic (zonotopal) tilings (rank 3 only)
- **`Pseudohyperplanes/`** — visualization via pseudohyperplane arrangements and sweep diagrams (rank 3 and rank 4)

The helper modules `basics.py`, `basics_poset.py`, and `basics_sweep.py` are shared utilities imported by both visualization folders.

## Input Format

Signotopes are stored as text files (or plain strings) containing a sequence of `+` and `-` characters. The signs correspond to all `r`-element subsets of `{0, …, n-1}` listed in lexicographic order, where `r` is the rank and `n` is the number of elements.

**Rank convention:** A rank-`r` signotope on `n` elements lives in `(r-1)`-dimensional space. So rank 3 ↔ 2D (planar), rank 4 ↔ 3D.

## Examples

The `examples/` folder contains:

| File | Rank | n | Description |
|------|------|---|-------------|
| `rank3/r3_n3_minus.txt` | 3 | 3 | all minus |
| `rank3/r3_n4_all-.txt` | 3 | 4 | all minus |
| `rank3/r3_n6_allplus.txt` | 3 | 6 | all plus (uniform) |
| `rank3/r3_n9_nonpappus.txt` | 3 | 9 | non-Pappus configuration |
| `rank3/r3_n9_ringel.txt` | 3 | 9 | Ringel arrangement |
| `rank4/r4n6_example_comparison.py` | 4 | 6 | rank-4 example |
| `rank4/r4n8_nonextendable.txt` | 4 | 8 | non-extendable rank-4 example |

## Visualization Tools

### Zonotopal Tiling (`zonotopal_tiling/`)

Visualizes a rank-3 signotope as a rhombic tiling of a centrally symmetric hexagon (zonotope). Produces two PDF files: the tiling itself and the dual pseudoline arrangement.

→ See [`zonotopal_tiling/README.md`](zonotopal_tiling/README.md)

### Pseudohyperplane Arrangements (`Pseudohyperplanes/`)

Visualizes signotopes as pseudohyperplane arrangements via wiring diagrams and sweep sequences. Works for both rank 3 (2D wiring diagrams) and rank 4 (2D and 3D sweep visualizations).

→ See [`Pseudohyperplanes/README.md`](Pseudohyperplanes/README.md)

## Requirements

- [SageMath](https://www.sagemath.org/) (tested with version 10.x)
- Run scripts with `sage <script>.sage <args>`

---

*README revised by Claude*
