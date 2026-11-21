import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

data = np.loadtxt("pdm_to_pcm_output.txt")[3:]
f_out = (100e6 / 36.0) / 1024.0

N = len(data)

t = np.arange(N) / f_out

data_ac = data - np.mean(data)
freq = np.fft.rfftfreq(N, d=1.0 / f_out)
fft_mag = np.abs(np.fft.rfft(data_ac)) / (N / 2)

fig, (ax1, ax2) = plt.subplots(2, 1, figsize = (10, 6))

ax1.plot(t * 1000, data, "o-")
ax1.set_title("pdm_to_pcm_signal")
ax1.set_xlabel("Time(ms)")
ax1.set_ylabel("Amplitude")
ax1.grid(True)


ax2.plot(freq, fft_mag, "o-")
ax2.set_title("FFT")
ax2.set_xlabel("Frequency")
ax2.set_ylabel("Magnitude")
ax2.grid(True)
ax2.set_xlim(0, 1350)

plt.tight_layout()
plt.savefig("pdm_to_pcm_result.png")