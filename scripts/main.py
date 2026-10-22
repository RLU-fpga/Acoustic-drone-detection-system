import numpy as np

F_pdm = 2822400 # Pdm mikrafo daznis
dec = 512 #Decimacijos koeficientas
Fcic = F_pdm / dec #Daznis po decimacijos
laikas = 0.5 #Signalo laikas

t_pdm = np.arange(0, laikas, 1/F_pdm)
f0 = 175

#PDM signalas
def gen_drone(t_axis):
    return (1.00 * np.sin(2 * np.pi * f0 * t_axis)+
            0.50 * np.cos(2 * np.pi * (2*f0) * t_axis) +
            0.25 * np.cos(2 * np.pi * (3*f0) * t_axis) +
            0.12 * np.cos(2 * np.pi * (4*f0) * t_axis) +
            0.05 * np.cos(2 * np.pi * (5*f0) * t_axis))

drono_pdm_rate = gen_drone(t_pdm)

#Triuksmo generavimas :D

SNR_dB = 0
triuksmas = np.random.randn(len(t_pdm))
galia_sig = np.mean(drono_pdm_rate**2)
galia_tr = galia_sig / (10**(SNR_dB / 10))
triuksmas_sig = drono_pdm_rate + triuksmas * np.sqrt(galia_tr)
norm_input = triuksmas_sig / np.max(np.abs(triuksmas_sig))

# Delta Sigma moduliacija PDM
pdm_stream = np.zeros(len(norm_input), dtype=np.uint8)
integrator = 0.0
for n in range(len(norm_input)):
    integrator += norm_input[n]
    if integrator >= 0:
        pdm_stream[n] = 1
        integrator -= 1.0
    else:
        pdm_stream[n] = 0
        integrator += 1.0
np.savetxt('pdm_stream.data', pdm_stream, fmt='%d')

# Drono Garso sabloniukas kazkas kazkaip cia kazka
L_template = 256
t_template = np.arange(0, laikas, 1/Fcic)
template_float = gen_drone(t_template)

template_int16 = np.round((template_float / np.max(np.abs(template_float))) * 32767)

with open('drone_template.mem', 'w') as f:
    for val in template_int16.astype(int):
        f.write(f"{val & 0xFFFF:04X}\n")

print("Viskas paruosta ")
