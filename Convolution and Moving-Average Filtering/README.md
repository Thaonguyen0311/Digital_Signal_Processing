# Lecture 03: Convolution and Moving-Average Filtering

## Files

- `Lecture03_convolution.m` creates the seeded test signal, applies scaling and delay, filters it with 5-point and 15-point moving averages, and saves the three required PNG figures.
- `signal_operations.png` compares the measured signal with its doubled version.
- `noise_filtering.png` compares the clean, noisy, and 5-point-filtered signals.
- `filter_comparison.png` compares the clean, noisy, 5-point, and 15-point-filtered signals.

## Observations

The amplitude-scaling operation changed the signal amplitude: multiplying each measured sample by 2 doubles both the clean component and the noise. The sample indices stay the same, and scaling does not change the sinusoid's frequency. In `signal_operations.png`, the scaled trace has twice the vertical excursion of the original.

The five-sample delay prepends five zero samples. This moves the measured waveform five sample positions to the right without changing the values or shape of its nonzero section. A real system can introduce delay through processing time, propagation through a medium, or storage and transmission buffers.

The impulse response `h[n]` is a filter's output when its input is a unit impulse. For these moving averages, it is a finite sequence of equal weights: each output is the average of nearby input samples. Convolution combines the input with those weights, so rapid sample-to-sample noise is reduced.

In `noise_filtering.png`, the 5-point result follows the clean sinusoid more smoothly than the noisy trace while retaining its oscillations. The 15-point average removes more of the rapid variation, as seen in `filter_comparison.png`, but it also smooths the sinusoid more strongly and can lower/round its peaks and troughs. This happens because each output averages over a wider span. Edge samples can also differ because `conv(...,'same')` uses the available zero-padded convolution context at the boundaries.

The 15-point filter removes more noise, but the 5-point filter is my recommendation for this signal: it reduces visible noise while preserving more of the sinusoid's amplitude and shape. The 15-point filter would be preferable if noise reduction mattered more than faithfully following the signal's variation.

A practical application is smoothing noisy sensor readings, such as averaging successive temperature or pressure measurements before displaying a stable trend.

## AI Usage

**Tool used:** OpenAI Codex.

**How I used it:** I used AI assistance to assemble the MATLAB script, generate the required plots, and draft explanations of the signal operations and filter comparison.

**What I verified or changed:** I used the fixed random seed and the specified signal and filter parameters. I checked the MATLAB code and generated labeled PNG previews using a local plotting fallback. MATLAB batch execution was blocked by a MathWorks service error in this environment, so I could not verify the MATLAB script by running it here. The previews use a deterministic noise approximation; running the MATLAB script will produce the exact seeded MATLAB figures. I adjusted the script to include the explicit five-sample zero-prefix delay.

