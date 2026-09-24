# Lecture 02 – Sampling and Aliasing

## Objective

This investigation samples a 10 Hz sinusoid at five rates and compares each set of discrete samples with a fine-step reference waveform. It demonstrates how sampling rate affects the information available to represent an analog vibration signal.

## Nyquist Analysis

The highest signal frequency is \(f_{max}=10\,\text{Hz}\). The Nyquist minimum is:

\[
f_s \ge 2f_{max}=2(10)=20\,\text{Hz}.
\]

Thus, 20 Hz is the ideal boundary; rates above 20 Hz satisfy the criterion with margin. Among the tested values, 20, 25, 50, and 100 Hz meet the inequality, while 15 Hz does not. In practice, sampling exactly at the boundary is not recommended: it leaves no transition band for an anti-aliasing filter and is sensitive to noise, frequency variation, and timing errors. For this zero-phase sine, sampling at 20 Hz also lands on zero crossings, producing all-zero samples and failing to show the waveform's amplitude.

## Results

- **15 Hz:** Below the Nyquist minimum. The samples cannot uniquely represent the 10 Hz input; the apparent lower-frequency pattern is aliasing.
- **20 Hz:** Exactly at Nyquist. This phase alignment yields samples at zero crossings, so the amplitude and waveform are not recoverable from this record.
- **25 Hz:** Above Nyquist, so the ideal criterion is met. There are only 2.5 samples per cycle, giving a sparse representation and limited practical margin.
- **50 Hz:** Five samples per cycle. The waveform is represented more clearly and has more margin than 25 Hz.
- **100 Hz:** Ten samples per cycle. This gives the clearest plotted representation of the tested choices, at a higher data and processing cost.

The figures use a fine-step curve as a visual approximation to the continuous signal and stem markers for actual samples. The one-second endpoint is included in each plot; the number of unique sampling intervals in a one-second record is \(f_s\).

## Aliasing Discussion

Aliasing occurs at 15 Hz because it is below \(2f_{max}=20\) Hz. Sampling then cannot distinguish the 10 Hz input from a lower-frequency alias; for this setup, the alias frequency is \(|10-15|=5\) Hz. At 20 Hz, the Nyquist equality holds mathematically, so this is the limiting boundary rather than below-Nyquist undersampling. However, the zero-phase samples all fall on zero crossings, making this specific finite set insufficient to recover the signal. Rates above 20 Hz avoid this ideal single-tone ambiguity, assuming suitable anti-alias filtering. For a practical system, 100 Hz is recommended among the tested rates: it gives ten samples per cycle and useful margin for imperfect sensors, filter roll-off, timing variation, and signal changes, while remaining a moderate data rate for a single monitored channel. The right production rate should also account for all vibration frequencies of interest and available anti-alias filtering.

## Engineering Recommendation

Use **100 Hz** among the tested choices for this 10 Hz signal. It provides ten samples per cycle and a fivefold margin over the Nyquist minimum, improving waveform detail and robustness without the data volume of much higher rates. A real condition-monitoring design must first define the full vibration bandwidth, then choose the sampling rate and analog anti-alias filter together. If processing or storage is especially constrained, 50 Hz is a reasonable lower-cost option for this known 10 Hz signal, provided filtering and timing are controlled.

## AI Usage

- **AI Tool Used:** ChatGPT (OpenAI)
- **Prompt(s):** “Explain aliasing for a 10 Hz sine sampled at 15, 20, 25, 50, and 100 Hz; determine the Nyquist minimum and suggest an engineering sampling rate.”
- **Summary of AI Response:** The Nyquist minimum is 20 Hz. 15 Hz is below the criterion and aliases; 20 Hz is the limiting case; higher tested rates exceed the minimum. The response recommended allowing practical margin above Nyquist.
- **What I Modified:** I considered the specified zero-phase sine and checked that its 20 Hz samples occur at integer half-cycle times, all zero crossings. I qualified the ideal Nyquist conclusion accordingly, selected 100 Hz from the provided options, and organized the MATLAB code to generate the requested plots.
- **How I Verified the Results:** I checked the inequality \(f_s\ge20\) Hz and evaluated \(\sin(2\pi(10)n/f_s)\) at the sample times. At 15 Hz, the alias is 5 Hz. At 20 Hz, the sample values are zero (up to floating-point rounding); 25, 50, and 100 Hz exceed Nyquist. Run `Lecture02_sampling_aliasing.m` in MATLAB to regenerate all plots.

## Files

The script writes `original_signal.png`, `sampling_15Hz.png`, `sampling_20Hz.png`, `sampling_25Hz.png`, `sampling_50Hz.png`, and `sampling_100Hz.png` in its current working directory. It also writes `sampling_comparison.png` with all five comparisons in one figure.
