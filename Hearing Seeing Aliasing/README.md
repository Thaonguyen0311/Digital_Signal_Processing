# Lecture 02 In-Class Assignment: Hearing and Seeing Aliasing

## Results

| Sampling frequency | Nyquist frequency | Observed peak | Aliasing? |
|---:|---:|---:|:---|
| 24 kHz | 12 kHz | 7 kHz | No |
| 16 kHz | 8 kHz | 7 kHz | No |
| 12 kHz | 6 kHz | 5 kHz | Yes |
| 8 kHz | 4 kHz | 1 kHz | Yes |

The alias frequency below Nyquist is found by folding the input frequency into the range from 0 to \(f_s/2\). For these cases it is \(|f_{signal}-f_s|\) when that value is below Nyquist: 7 kHz folds to 5 kHz at 12 kHz sampling, and to 1 kHz at 8 kHz sampling.

## Short Answers

1. **Which rates represented the 7 kHz signal correctly?** 24 kHz and 16 kHz, since their Nyquist frequencies (12 kHz and 8 kHz) are above 7 kHz.
2. **When did it appear as another frequency?** At 12 kHz sampling it appeared at 5 kHz; at 8 kHz sampling it appeared at 1 kHz.
3. **What happened when Nyquist fell below 7 kHz?** The sampled data could no longer distinguish the 7 kHz tone from a lower-frequency tone. Its spectral energy folded into the lower-frequency range.
4. **Did the aliased signal sound different?** It should: 5 kHz and 1 kHz tones sound lower than the original 7 kHz tone. The exact listening experience depends on speakers/headphones and hearing; use low volume.
5. **Why can MATLAB not recover the original after aliasing?** Downsampling discarded information without filtering. Different analog frequencies can produce the same discrete samples, so the original 7 kHz frequency is no longer uniquely identifiable from those samples alone.

## Verification

The Nyquist threshold is \(2(7\,\text{kHz})=14\,\text{kHz}\). The script downsamples by integer factors from 48 kHz and computes a periodogram using the new sampling rate. The frequency axes are explicitly converted to kHz, avoiding the Hz/kHz mismatch in the supplied starter's `xlim` usage.

Run `Lecture02_hearing_seeing_aliasing.m` in MATLAB to regenerate the four figures. Audio playback lines are commented out so they do not unexpectedly play at high volume; enable them only after setting a comfortable, low volume.
