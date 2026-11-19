# Practical Digital Filtering Report

## Scope and main result

This exercise compares two 20 Hz low-pass filters on a synthetic sensor signal, then removes a known 50 Hz tone from MATLAB's built-in Handel example. The MATLAB script creates six figures and prints the numerical evidence. The intended result is to preserve useful low-frequency content while reducing the specified interference. The script has not yet been run in MATLAB in this environment, so measured values and the listening observation are deliberately left blank below.

## Part A: Sensor signal and filter design

The two-second record is sampled at 1,000 Hz. Its clean reference is

`clean(t) = sin(2π·5t) + 0.35 sin(2π·12t)`.

The experiment adds interference at 50 Hz and 137 Hz plus Gaussian noise. The random seed is fixed to 7 so each run uses a reproducible realization. Since the clean reference is known, RMSE can be calculated for the noisy input and for each filter output.

A 20 Hz low-pass cutoff is reasonable because the wanted tones at 5 Hz and 12 Hz lie below the cutoff, while the interference tones at 50 Hz and 137 Hz lie above it. This choice assumes that useful sensor information above 20 Hz can be discarded. If a real measurement contains meaningful content near or above 20 Hz, this filter can remove part of the measurement along with the noise.

The FIR design has order 60, or 61 taps. FIR filters can provide linear phase and are inherently stable, but this design uses many more coefficients than the 4th-order Butterworth IIR. The IIR can provide a useful transition with fewer coefficients, though its phase response is nonlinear. When Signal Processing Toolbox is available, the script uses `filtfilt` for both outputs. Otherwise, it uses a base-MATLAB reflected-padding forward-backward helper with similar zero-phase behavior and approximate edge handling. Forward-backward filtering doubles the effective attenuation in dB and is not a causal, low-latency streaming operation.

The script writes `sensor-time-comparison.png`, `sensor-filter-responses.png`, and `sensor-spectra-rmse.png`. Use the time plot to compare waveforms over the first 0.2 seconds, the response plot to inspect the 20 Hz cutoff, and the spectrum plot to check whether the 5 Hz and 12 Hz components remain while peaks near 50 Hz and 137 Hz fall.

| Signal | RMSE against clean reference |
| --- | ---: |
| Noisy input | Fill from MATLAB output |
| FIR output | Fill from MATLAB output |
| IIR output | Fill from MATLAB output |

RMSE summarizes overall sample-by-sample error, but does not identify which frequencies caused the error or describe phase, latency, edge effects, or performance on other recordings. The response and spectrum plots provide evidence that RMSE cannot.

## Part A: comparison and choice

After running the script, compare the passband and transition region in the frequency response with the residual 50 Hz and 137 Hz peaks in the spectrum. The 12 Hz component is below the 20 Hz cutoff but close enough that its measured amplitude should be checked. Choose a preferred design only after examining both the RMSE values and the plots.

The FIR filter is a reasonable choice when predictable phase and stability matter and the system can afford a longer filter. The Butterworth IIR is a reasonable choice when computation and coefficient count matter. In a live system, replace `filtfilt` with causal filtering and account for the IIR phase response or the FIR group delay. Inspect the beginning and end of the record because forward-backward filtering can create edge transients.

## Part B: 50 Hz hum in audio

The script loads MATLAB's Handel example, converts it to a column vector, and records its sample rate. It adds a sinusoid with amplitude 0.15 at 50 Hz, then designs second-order Butterworth stop-band filters for 49–51 Hz and 45–55 Hz. It uses `butter` when available and a bilinear-transform Butterworth implementation otherwise. The script checks that the sample rate can represent 50 Hz and that the normalized edges are valid.

The narrow 49–51 Hz stop band targets a steady mains tone while limiting changes to nearby audio frequencies. A wider stop band can tolerate greater hum drift but removes more nearby audio content. `filtfilt` is used in both cases to avoid an intentional phase delay. The script saves waveform, spectrum, and response plots so the tone reduction and the effect on nearby frequencies can be compared.

| Stop band | One-pass filter attenuation at 50 Hz |
| --- | ---: |
| 49–51 Hz | Fill from MATLAB output |
| 45–55 Hz | Fill from MATLAB output |

The response value is calculated with `freqz` when available and a direct polynomial response calculation otherwise. This is the one-pass filter response; the forward-backward output has approximately twice the attenuation in dB. The spectrum is a separate check on the actual filtered signal. The script includes an optional playback block that uses the same peak normalization for the hum-added and narrow-filtered audio. Set `playAudio = true` in MATLAB and listen at the same playback gain before completing the note below.

**Listening note:** Fill in your own observation after playback. State whether the steady hum is reduced and whether you hear a change in useful audio.

## Engineering questions

1. **Why is a 20 Hz low-pass reasonable?** The known useful sensor tones are 5 Hz and 12 Hz; the specified interference is at 50 Hz and 137 Hz. The design assumes useful sensor content above 20 Hz can be removed.
2. **Which sensor filter is better?** Decide from at least two types of evidence, such as RMSE plus retained 5 Hz and 12 Hz amplitudes, or the filter response plus residual interference peaks. Insert measured values before making a final choice.
3. **How would live filtering change?** Use a causal filter instead of `filtfilt`, preserve filter state between blocks, and assess the resulting phase or group delay against the application's latency limit.
4. **Why use a narrow stop band for steady hum?** It targets a stable 50 Hz tone while changing less nearby audio. If the frequency drifts, track its center frequency or widen the notch only as much as needed.
5. **What is one limitation and improvement?** These tests use one synthetic sensor record and one built-in audio example. A real system should test more recordings, quantify frequency drift and useful-band distortion, and evaluate latency and boundary behavior.

## Tools and AI use

The MATLAB script prints the MATLAB version and checks Signal Processing Toolbox availability. Record both from the MATLAB output before submitting. AI helped organize the script and draft this report. The script and audio playback were not run during preparation, so measured entries and the listening note remain for verification. Review and revise the explanations in your own words before submission.
