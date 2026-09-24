# Lecture 02 – Sampling and Aliasing

## Objective

This investigation samples a 10 Hz sinusoidal signal at five sampling rates and compares each set of discrete samples with a fine-step reference waveform. It demonstrates how the sampling rate affects the ability to represent an analog vibration signal.

## Nyquist Analysis

The highest frequency component of the signal is

$$
f_{\max}=10\text{ Hz}.
$$

According to the Nyquist sampling theorem, the sampling frequency must satisfy

$$
f_s \geq 2f_{\max}.
$$

Therefore,

$$
f_s \geq 2(10)=20\text{ Hz}.
$$

Thus, the theoretical Nyquist rate for this signal is **20 Hz**.

Among the tested sampling rates:

| Sampling rate | Samples per 10 Hz cycle | Nyquist criterion     |
| ------------: | ----------------------: | --------------------- |
|         15 Hz |                     1.5 | ❌ Below Nyquist       |
|         20 Hz |                       2 | ⚠️ Exactly at Nyquist |
|         25 Hz |                     2.5 | ✅ Above Nyquist       |
|         50 Hz |                       5 | ✅ Above Nyquist       |
|        100 Hz |                      10 | ✅ Above Nyquist       |

Although 20 Hz satisfies the theoretical Nyquist condition, sampling exactly at the Nyquist rate is not generally recommended in a practical system. There is no margin for filter roll-off, noise, frequency variation, or sampling-time errors.

Furthermore, for the particular signal used here,

$$
x(t)=\sin(2\pi 10t),
$$

sampling at 20 Hz gives

$$
x[n]=\sin\left(2\pi 10\frac{n}{20}\right)
=\sin(\pi n)=0.
$$

Therefore, every sample is theoretically zero. This is caused by the particular phase of the sinusoid and the sampling instants coinciding with its zero crossings. Consequently, this particular sampled record does not reveal the amplitude of the original sinusoid.

## Results

### 15 Hz

The sampling frequency is below the Nyquist rate:

$$
15 < 20\text{ Hz}.
$$

Therefore, aliasing occurs.

For a 10 Hz signal sampled at 15 Hz, the aliased frequency can be calculated as

$$
f_{\text{alias}}=|f-f_s|
=|10-15|
=5\text{ Hz}.
$$

Thus, the 10 Hz sinusoid appears as a lower-frequency 5 Hz component in the sampled data.

### 20 Hz

The sampling frequency is exactly the Nyquist rate:

$$
20=2(10)\text{ Hz}.
$$

There are exactly two samples per cycle. For the zero-phase sine wave,

$$
x[n]=\sin(\pi n)=0,
$$

so all theoretical samples are zero.

This demonstrates an important limitation of sampling exactly at the Nyquist rate: although the mathematical Nyquist condition is satisfied, the particular sampling phase can make the sampled data unsuitable for recovering the waveform amplitude.

### 25 Hz

The sampling frequency is above the Nyquist rate:

$$
25>20\text{ Hz}.
$$

There are

$$
\frac{25}{10}=2.5
$$

samples per cycle.

The theoretical Nyquist condition is therefore satisfied, and the signal can be represented without aliasing under ideal conditions. However, 2.5 samples per cycle provides relatively sparse waveform representation and only a small practical margin above the minimum.

### 50 Hz

The sampling frequency is

$$
50>20\text{ Hz},
$$

giving

$$
\frac{50}{10}=5
$$

samples per cycle.

The sampled waveform is represented much more clearly than at 25 Hz, while requiring a moderate amount of data.

### 100 Hz

The sampling frequency is

$$
100>20\text{ Hz},
$$

giving

$$
\frac{100}{10}=10
$$

samples per cycle.

Among the tested rates, 100 Hz provides the densest and clearest representation of the 10 Hz waveform. It also provides substantially more margin above the Nyquist rate, although it produces more samples and therefore increases data-processing and storage requirements.

## Aliasing Discussion

Aliasing occurs when the sampling frequency is insufficient to distinguish the original signal frequency from another frequency that produces the same sampled sequence.

For the 15 Hz sampling rate,

$$
f_s=15\text{ Hz}<20\text{ Hz},
$$

so the 10 Hz signal is undersampled. Its alias frequency is

$$
f_{\text{alias}}=|10-15|=5\text{ Hz}.
$$

Consequently, the sampled data can appear as a 5 Hz signal even though the original signal is 10 Hz.

At 20 Hz, the sampling rate is exactly equal to twice the signal frequency:

$$
f_s=2f.
$$

This is the theoretical Nyquist boundary. For the particular zero-phase sine wave,

$$
\sin(2\pi 10n/20)=\sin(\pi n)=0,
$$

so all samples occur at zero crossings. This does not mean that every signal sampled at 20 Hz will produce zero samples; it is a consequence of the specific phase and sampling alignment used in this experiment.

At 25, 50, and 100 Hz, the sampling frequencies are above the Nyquist rate, so the 10 Hz signal is not theoretically aliased, assuming ideal sampling and adequate anti-aliasing filtering.

## Engineering Recommendation

Among the tested sampling rates, **100 Hz** provides a practical choice for this 10 Hz signal.

The ratio between the sampling frequency and the signal frequency is

$$
\frac{100}{10}=10
$$

samples per cycle.

Relative to the theoretical Nyquist rate,

$$
\frac{100}{20}=5.
$$

Therefore, 100 Hz is **five times the Nyquist rate**, not merely the minimum required rate. This provides additional practical margin for filter roll-off, timing variation, noise, and small changes in the vibration frequency.

If data storage and processing resources are more constrained, **50 Hz** provides

$$
\frac{50}{10}=5
$$

samples per cycle and is also comfortably above the theoretical Nyquist rate.

The appropriate production sampling rate should ultimately be determined from the **highest vibration frequency that needs to be measured**, rather than only from the 10 Hz component considered in this experiment. The sampling frequency and the analog anti-aliasing filter should be designed together.

## Sampling Interval and Number of Samples

The sampling period is

$$
T_s=\frac{1}{f_s}.
$$

Therefore:

| \(f_s\) | Sampling period \(T_s\) |
| ------: | ----------------------: |
|   15 Hz |           \(0.06667\) s |
|   20 Hz |           \(0.05000\) s |
|   25 Hz |           \(0.04000\) s |
|   50 Hz |           \(0.02000\) s |
|  100 Hz |           \(0.01000\) s |

For a one-second interval from \(t=0\) to \(t=1\) **including both endpoints**, the number of sampling points is

$$
N=f_s+1,
$$

because there are \(f_s\) sampling intervals.

For example, at 100 Hz:

$$
N=100+1=101
$$

sample points, but there are exactly **100 sampling intervals** between \(t=0\) and \(t=1\).

## AI Usage

* **AI Tool Used:** ChatGPT (OpenAI)
* **Prompt:** “Explain aliasing for a 10 Hz sine sampled at 15, 20, 25, 50, and 100 Hz; determine the Nyquist minimum and suggest an engineering sampling rate.”
* **Summary of AI Response:** The Nyquist rate for a 10 Hz signal is 20 Hz. Sampling at 15 Hz causes aliasing, while 20 Hz is the theoretical boundary and 25, 50, and 100 Hz exceed the Nyquist rate.
* **What I Modified:** I checked the calculations for each sampling rate, explicitly calculated the alias frequency at 15 Hz, verified the zero-crossing behavior at 20 Hz, calculated the samples-per-cycle values, and clarified the difference between sampling points and sampling intervals.
* **How I Verified the Results:** The Nyquist condition was checked using

$$
f_s\geq2f_{\max}=20\text{ Hz}.
$$

The sampled signal was evaluated using

$$
x[n]=\sin\left(2\pi f\frac{n}{f_s}\right).
$$

For 15 Hz,

$$
f_{\text{alias}}=|10-15|=5\text{ Hz}.
$$

For 20 Hz,

$$
x[n]=\sin(\pi n)=0.
$$

For 25, 50, and 100 Hz, the sampling frequencies are above 20 Hz and therefore satisfy the ideal Nyquist criterion.
