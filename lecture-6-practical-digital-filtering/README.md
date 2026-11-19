# Lecture 6 Practical Digital Filtering

This folder contains a reproducible MATLAB script for both parts of the assignment and a report draft. The script uses the prescribed synthetic sensor signal and MATLAB's built-in `handel` sample. It creates six figures in `figures/`, prints RMSE and filter-response measurements, and includes an optional same-gain audio playback section.

## Run

Open MATLAB with Signal Processing Toolbox available, set the current folder to this directory, and run:

```matlab
lecture6_filtering
```

The script records the MATLAB version and toolbox availability. It saves figures as PNG files under `figures/`.

## Before submitting

- Run the script in MATLAB and confirm the six figures are created.
- Copy the RMSE values and 50 Hz attenuation into `report.docx`.
- Set `playAudio = true` and listen to the hum-added and filtered clips at the same gain; write your own listening observation in the report.
- Review the report in your own words and identify the AI assistance as described there.

MATLAB execution was unavailable in the preparation environment, so no numerical output or subjective listening result is claimed in the report draft.
