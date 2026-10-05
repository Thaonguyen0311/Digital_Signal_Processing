# MATLAB Assignment: Z-Transform and Sample Delays

## Files

- `z_transform_assignment.m` — complete MATLAB script for both parts and both filter settings.
  <img width="1080" height="940" alt="image" src="https://github.com/user-attachments/assets/c1300503-8fc5-4a16-b7ca-21f3841671da" />

- `original_and_delayed.png`
<img width="1020" height="946" alt="image" src="https://github.com/user-attachments/assets/c817161b-a79c-4124-9845-6f334b1ccb1f" />

- `output_original_filter.png`

<img width="1036" height="924" alt="image" src="https://github.com/user-attachments/assets/5fe95239-a276-40a6-9f49-70e160d8a78e" />

- `output_changed_filter.png` 

## Answers

### 1. Which sample does each term in `X(z)` represent?

For `X(z) = 1 + 2z^(-1) + z^(-2)`, each coefficient is the sample value and each power of `z^(-1)` records its time index:

- `1` is `x[0] = 1`.
- `2z^(-1)` is `x[1] = 2`.
- `z^(-2)` is `x[2] = 1`.

### 2. Z-transform of the delayed signal

The delayed sequence is `x[n-1] = [0, 1, 2, 1]` at indices `n = 0, 1, 2, 3`. Its transform is

`X_delayed(z) = z^(-1)X(z) = z^(-1) + 2z^(-2) + z^(-3)`.

### 3. Why does a one-sample delay multiply `X(z)` by `z^(-1)`?

The Z-transform is a sum of each sample multiplied by `z^(-n)`. Moving every sample one index later changes its weight from `z^(-n)` to `z^(-(n+1)) = z^(-1)z^(-n)`. The common factor `z^(-1)` therefore multiplies the whole transform.

### 4. Hand calculation of `y[0]` through `y[3]`

Use `y[n] = 0.5x[n] + 0.5x[n-1]`, with the input zero before `n = 0`. The script appends `x[3] = 0` so the final delayed contribution is included.

- `y[0] = 0.5(1) + 0.5(0) = 0.5`
- `y[1] = 0.5(2) + 0.5(1) = 1.5`
- `y[2] = 0.5(1) + 0.5(2) = 1.5`
- `y[3] = 0.5(0) + 0.5(1) = 0.5`

So MATLAB should display `[0.5 1.5 1.5 0.5]`.

### 5. How does `b = [0.5 0.5]` represent `H(z)`?

In MATLAB's `filter`, the entries of `b` are numerator coefficients in order of increasing delay. The first entry multiplies the current input, and the second multiplies the input delayed by one sample. Thus `b = [0.5 0.5]` implements `0.5x[n] + 0.5x[n-1]`, whose transfer function is `0.5 + 0.5z^(-1)`.

### 6. Effect of changing to `H(z) = 0.8 + 0.2z^(-1)`

Set `b = [0.8 0.2]`. The current sample now has the larger weight (0.8 versus 0.2), so it has more influence on each output sample than the previous input sample. For the provided input, MATLAB should produce `[0.8 1.8 1.4 0.2]`.

