import numpy as np

f_pdm = 100e6 / 36.0
f_pcm = f_pdm / 1024.0
n_samples = 6000000

t = np.arange(n_samples) / f_pdm

t_delayed1 = t - (2 / f_pcm)
t_delayed2 = t - (1 / f_pcm)
t_delayed3 = t - (-3 / f_pcm)
t_delayed4 = t - (-1 / f_pcm)



# mic0 signal

noise0 = np.random.normal(0, 0.1, n_samples)
mic01 = 0.3 * np.sin(2 * np.pi * 300 * t)
mic02 = 0.15 * np.sin(2 * np.pi * 600 * t)
signal0 = mic01 + mic02 + noise0

pdm_bits0 = np.zeros (n_samples, dtype=int)
acc = 0.0

for i, s in enumerate(signal0):
    acc += s
    if acc >= 0:
        pdm_bits0[i] = 1
        acc -= 1.0
    else:
        pdm_bits0[i] = 0
        acc += 1.0

np.savetxt("PL_connector_bits0.txt", pdm_bits0, fmt="%d")

# mic1 signal

noise1 = np.random.normal(0, 0.1, n_samples)
mic11 = 0.3 * np.sin(2 * np.pi * 300 * t_delayed1)
mic12 = 0.15 * np.sin(2 * np.pi * 600 * t_delayed1)
signal1 = mic11 + mic12 + noise1

pdm_bits1 = np.zeros (n_samples, dtype=int)
acc = 0.0

for i, s in enumerate(signal1):
    acc += s
    if acc >= 0:
        pdm_bits1[i] = 1
        acc -= 1.0
    else:
        pdm_bits1[i] = 0
        acc += 1.0

np.savetxt("PL_connector_bits1.txt", pdm_bits1, fmt="%d")

# mic2 signal

noise2 = np.random.normal(0, 0.1, n_samples)
mic21 = 0.3 * np.sin(2 * np.pi * 300 * t_delayed2)
mic22 = 0.15 * np.sin(2 * np.pi * 600 * t_delayed2)
signal2 = mic21 + mic22 + noise2

pdm_bits2 = np.zeros (n_samples, dtype=int)
acc = 0.0

for i, s in enumerate(signal2):
    acc += s
    if acc >= 0:
        pdm_bits2[i] = 1
        acc -= 1.0
    else:
        pdm_bits2[i] = 0
        acc += 1.0

np.savetxt("PL_connector_bits2.txt", pdm_bits2, fmt="%d")

# mic3 signal

noise3 = np.random.normal(0, 0.1, n_samples)
mic31 = 0.3 * np.sin(2 * np.pi * 300 * t_delayed3)
mic32 = 0.15 * np.sin(2 * np.pi * 600 * t_delayed3)
signal3 = mic31 + mic32 + noise3

pdm_bits3 = np.zeros (n_samples, dtype=int)
acc = 0.0

for i, s in enumerate(signal3):
    acc += s
    if acc >= 0:
        pdm_bits3[i] = 1
        acc -= 1.0
    else:
        pdm_bits3[i] = 0
        acc += 1.0

np.savetxt("PL_connector_bits3.txt", pdm_bits3, fmt="%d")

# mic4 signal

noise4 = np.random.normal(0, 0.1, n_samples)
mic41 = 0.3 * np.sin(2 * np.pi * 300 * t_delayed4)
mic42 = 0.15 * np.sin(2 * np.pi * 600 * t_delayed4)
signal4 = mic41 + mic42 + noise4

pdm_bits4 = np.zeros (n_samples, dtype=int)
acc = 0.0

for i, s in enumerate(signal4):
    acc += s
    if acc >= 0:
        pdm_bits4[i] = 1
        acc -= 1.0
    else:
        pdm_bits4[i] = 0
        acc += 1.0

np.savetxt("PL_connector_bits4.txt", pdm_bits4, fmt="%d")
