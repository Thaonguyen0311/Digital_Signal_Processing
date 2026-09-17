
# Lecture 01 – Signal Visualization

## Overview

This assignment demonstrates how to generate, visualize, and interpret simple signals using MATLAB.

The following topics were investigated:

* Sine wave generation
* Frequency comparison
* Amplitude comparison
* Signal noise
* Saving MATLAB figures as PNG files

## Task 1 – Create a Sine Wave

A sine wave with the following parameters was generated:

* Amplitude: 1
* Frequency: 5 Hz
* Duration: 1 second

The signal was plotted in the time domain with a title, axis labels, and grid.

The sine wave was generated using:

```matlab
signal = A * sin(2*pi*f*t);
```

## Task 2 – Compare Different Frequencies

Three sine waves were generated with frequencies of:

* 2 Hz
* 5 Hz
* 10 Hz
<img width="722" height="477" alt="frequency_comparison" src="https://github.com/user-attachments/assets/95ab56eb-e798-43b2-81d7-14d75024c815" />

### Questions

**1. Which signal changes fastest?**

The 10 Hz signal changes fastest because it has the highest frequency.

**2. Which signal has the lowest frequency?**

The 2 Hz signal has the lowest frequency.

**3. How can you see the difference in the plots?**

The frequency can be seen by counting how many complete cycles occur during the same time interval. The 10 Hz signal has more cycles than the 5 Hz and 2 Hz signals.

## Task 3 – Compare Different Amplitudes

Three sine waves were generated with amplitudes of:

* 0.5
* 1
* 2
<img width="722" height="477" alt="amplitude_comparison" src="https://github.com/user-attachments/assets/63caa61a-72a7-41a9-92a0-79c2ee12613b" />

The same frequency of 5 Hz was used for all signals.

### Questions

**1. Which signal has the largest amplitude?**

The signal with amplitude 2 has the largest amplitude.

**2. Does changing amplitude change frequency?**

No. Changing the amplitude changes the vertical size of the signal but does not change how quickly the signal oscillates.

**3. Give one real-world example where amplitude is important.**

In audio signals, amplitude is related to the strength or loudness of the sound. A larger amplitude represents a stronger signal.

## Task 4 – Add Noise

Random noise was added to a clean 5 Hz sine wave.
<img width="722" height="477" alt="clean_vs_noisy_signal" src="https://github.com/user-attachments/assets/80b1bfdd-d6af-4411-963c-5930135f951e" />


### Questions

After adding noise, the signal became more irregular because random variations were added to the original sine wave. 
However, the original 5 Hz sine-wave pattern can still be recognized even though the signal is less smooth. 
A real-world source of signal noise is electrical interference from other electronic devices, which can introduce unwanted variations into sensor signals.


**AI Tool Used:** ChatGPT

Things that I verified:

1. The 5 Hz sine wave was displayed correctly.
2. The frequency comparison contained 2 Hz, 5 Hz, and 10 Hz signals.
3. The amplitude comparison contained amplitudes 0.5, 1, and 2.
4. The noisy signal still showed the original sine-wave pattern.
5. The three required PNG files were created successfully.

## Conclusion

This assignment demonstrated how frequency affects the speed of oscillation, how amplitude affects the size of a signal, and how noise changes a signal in the time domain. MATLAB provides simple functions for generating, visualizing, and saving signals.
