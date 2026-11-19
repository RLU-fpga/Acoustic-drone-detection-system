import numpy as np

f_pdm = 100e6 / 36.0 # 2.7777Mhz PDM daznis
n_samples = 40000 # 39 CIC isejimo taskai kai R 1024

t = np.arange(n_samples) / f_pdm


# 300 Hz + 600 Hz drono garsas ir triuksmas

pirmaharmonika = 0.5 * np.sin(2 * np.pi * 300 * t)
antraharmonika = 0.2 * np.sin(2 * np.pi * 600 * t)
triuksmas = np.random.normal(0, 0.05, n_samples)

signal = (pirmaharmonika + antraharmonika + triuksmas)


# Delta sigma moduliatorius
pdm_bits = np.zeros(n_samples, dtype=int)
acc = 0.0
for i, s in enumerate(signal):
    acc += s
    if acc >= 0:
        pdm_bits[i] = 1
        acc -= 1.0
    else:
        pdm_bits[i] = 0
        acc += 1.0

np.savetxt("pdm_input.txt", pdm_bits, fmt="%d")