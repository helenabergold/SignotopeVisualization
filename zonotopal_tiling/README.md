# Zonotopal Tiling

Visualizes a **rank-3 signotope** as a rhombic (zonotopal) tiling. The tiling is derived from the flip sequence of the signotope and lives in a centrally symmetric polygon (zonotope). Two output PDFs are produced per run:

- `tiling<n>.pdf` — the rhombic tiling of the zonotope
- `pslines<n>.pdf` — the dual pseudoline arrangement

This folder also contains `zonotopal_tiling_anydim.sage`, a more general script that works for any rank (via Jupyter notebook or interactive Sage session), and the notebook `load_rhombic_tiling_dim3.ipynb` which demonstrates the rank-4 / 3D case.

## Scripts

| Script | Rank | Usage |
|--------|------|-------|
| `rhombic_tiling_r3.sage` | 3 (2D) | command-line |
| `zonotopal_tiling_anydim.sage` | any | via notebook / `load()` in Sage |
| `load_rhombic_tiling_dim3.ipynb` | 4 (3D) | Jupyter notebook |

## Running `rhombic_tiling_r3.sage`

```bash
sage rhombic_tiling_r3.sage <rank> <n> <input_file>
```

**Arguments:**
- `<rank>` — must be `3`
- `<n>` — number of elements
- `<input_file>` — path to a signotope data file

The script must be run from the `zonotopal_tiling/` directory (it imports from `../`).

### Examples

**All-plus signotope, n=6** (uniform pseudoline arrangement):

```bash
cd zonotopal_tiling
sage rhombic_tiling_r3.sage 3 6 ../examples/rank3/r3_n6_allplus.txt
# Output: tiling6.pdf, pslines6.pdf
```

**Non-Pappus configuration, n=9:**

```bash
cd zonotopal_tiling
sage rhombic_tiling_r3.sage 3 9 ../examples/rank3/r3_n9_nonpappus.txt
# Output: tiling9.pdf, pslines9.pdf
```

## Running the Jupyter Notebook (`load_rhombic_tiling_dim3.ipynb`)

This notebook calls `zonotopal_tiling_anydim.sage` for the rank-4 (3D) case. Open it with:

```bash
sage -n jupyter
```

The first cell sets the arguments:

```python
argv = [None, 4, 6, '++++++---+---++']
# argv[1] = rank, argv[2] = n, argv[3] = signotope string
```

Then run the second cell which loads the script:

```python
load('zonotopal_tiling_anydim.sage')
```

The script produces a 3D interactive visualization and saves `wires_3_<n>.png`.

## Input Format

Each input file contains one line of `+`/`-` characters, one per `r`-subset of `{0,…,n-1}` in lexicographic order. For rank 3, n=6 there are C(6,3)=20 characters:

```
++++++++++++++++++++
```

For rank 3, n=9 (non-Pappus):

```
-----------------------------------------------++-+-++++++-+++++++++---+++----++++++
```
