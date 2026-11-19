# Lecture 6 Practical Digital Filtering

This folder contains a reproducible MATLAB script for both parts of the assignment and a report draft. The script uses the prescribed synthetic sensor signal and MATLAB's built-in `handel` sample. It creates six figures in `figures/`, prints RMSE and filter-response measurements, and includes an optional same-gain audio playback section.

## Run

Set the current folder to this directory and run in MATLAB:

```matlab
lecture6_filtering
```

The script records the MATLAB version and whether the required toolbox functions are available. With Signal Processing Toolbox it uses `fir1`, `butter`, `filtfilt`, and `freqz`. Without the toolbox it uses base-MATLAB equivalents for the Hamming-window FIR, bilinear Butterworth designs, frequency responses, and approximate forward-backward filtering. It saves figures as PNG files under `figures/`.

## Before submitting

- Run the script in MATLAB and confirm the six figures are created. If the instructor requires the toolbox functions specifically, run it on a MATLAB installation with Signal Processing Toolbox; the fallback forward-backward filter has approximate edge handling.
- Copy the RMSE values and 50 Hz attenuation into `report.docx`.
- Set `playAudio = true` and listen to the hum-added and filtered clips at the same gain; write your own listening observation in the report.
- Review the report in your own words and identify the AI assistance as described there.

MATLAB execution was unavailable in the preparation environment, so no numerical output or subjective listening result is claimed in the report draft.
