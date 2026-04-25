# Pseudohyperplane Arrangements

Visualization of signotopes as **pseudohyperplane arrangements** via wiring diagrams and sweep sequences. This folder contains scripts for both rank 3 (planar pseudoline arrangements) and rank 4 (3D pseudoplane arrangements).

**Rank convention:** rank 3 ↔ 2D/planar, rank 4 ↔ 3D. The script names reflect the *dimension of the visualization*, not the rank.

## Scripts

| Script | Rank | Output | Usage |
|--------|------|--------|-------|
| `wiring.sage` | 3 | `wiring<n>.pdf` — wiring diagram (pseudoline arrangement) | command-line |
| `sweep_2d.sage` | 4 | `sweep<n>_4_<i>.pdf`, `multi<n>_4.pdf` — sweep steps as 2D diagrams | command-line |
| `sweep_dim3.sage` | 4 | interactive 3D sweep visualization | via Jupyter notebook |
| `visualization_dim3.ipynb` | 4 | Jupyter notebook calling `sweep_dim3.sage` | Jupyter |

## `wiring.sage` — Rank 3, Wiring Diagram

Computes the pseudoline arrangement (wiring diagram) corresponding to a rank-3 signotope. Outputs `wiring<n>.pdf`.

```bash
sage wiring.sage <rank> <n> <input_file>
```

**Arguments:**
- `<rank>` — must be `3`
- `<n>` — number of elements
- `<input_file>` — path to signotope data file

Run from the `Pseudohyperplanes/` directory.

### Examples

**All-plus signotope, n=6:**

```bash
cd Pseudohyperplanes
sage wiring.sage 3 6 ../examples/rank3/r3_n6_allplus.txt
# Output: wiring6.pdf
```

**Non-Pappus configuration, n=9:**

```bash
cd Pseudohyperplanes
sage wiring.sage 3 9 ../examples/rank3/r3_n9_nonpappus.txt
# Output: wiring9.pdf
```

## `sweep_2d.sage` — Rank 4, 2D Sweep Diagrams

Visualizes a rank-4 signotope via its sweep sequence: at each step of the sweep, the current rank-3 projection (wiring diagram) is drawn as a 2D plot. Produces one PDF per sweep step (`sweep<n>_4_<i>.pdf`) plus a combined multi-page overview (`multi<n>_4.pdf`).

```bash
sage sweep_2d.sage <rank> <n> <input_file>
```

**Arguments:**
- `<rank>` — must be `4`
- `<n>` — number of elements
- `<input_file>` — path to signotope data file

### Example

**Non-extendable rank-4 signotope, n=8:**

```bash
cd Pseudohyperplanes
sage sweep_2d.sage 4 8 ../examples/rank4/r4n8_nonextendable.txt
# Output: sweep8_4_0.pdf ... sweep8_4_26.pdf, multi8_4.pdf
```

## `sweep_dim3.sage` + `visualization_dim3.ipynb` — Rank 4, 3D Visualization

Visualizes a rank-4 signotope as a 3D sweep: each element traces a path through 3D space as the sweep progresses. The result is an interactive 3D graphics object shown in the notebook.

Open the notebook:

```bash
sage -n jupyter
# then open visualization_dim3.ipynb
```

The first cell sets the parameters:

```python
args = [None, 4, 8, '+++++-+-++++-++----+++-+++++-++-+++----------+++--+--+++++-++-+++--+++']
# args[1] = rank (must be 4), args[2] = n, args[3] = signotope string
```

Then run the next cell:

```python
load('sweep_dim3.sage')
```

The 3D plot is displayed interactively in the notebook output.

## Input Format

Input files contain one line of `+`/`-` characters — one per `r`-subset of `{0,…,n-1}` in lexicographic order.

| Rank | n | Number of signs |
|------|---|----------------|
| 3 | 6 | C(6,3) = 20 |
| 3 | 9 | C(9,3) = 84 |
| 4 | 8 | C(8,4) = 70 |
