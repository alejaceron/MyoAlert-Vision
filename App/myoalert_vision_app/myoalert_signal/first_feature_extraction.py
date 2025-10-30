import numpy as np
import pandas as pd
from scipy.signal import welch, hilbert
from scipy.stats import kurtosis
import EntropyHub as EH
import pywt


# Funciones 

def get_psd(sig, fs=500, nperseg=512):
    f, p = welch(sig, fs=fs, nperseg=nperseg)
    return f, p

def frequency_calculation(sig, fs=500):
    freqs = np.fft.rfftfreq(len(sig), 1/fs)
    fft_vals = np.abs(np.fft.rfft(sig))**2
    return freqs[np.argmax(fft_vals)]

def complexity_measure(sig):
    diffs = np.diff(sig)
    return np.sum(np.abs(diffs)) / len(sig)

def energy(sig):
    return np.sum(sig**2)

def renyi_entropy(sig, alpha=2, bins=100):
    sig = np.asarray(sig)
    sig = sig[np.isfinite(sig)]
    if sig.size == 0:
        return np.nan
    counts, _ = np.histogram(sig, bins=bins)
    p = counts.astype(float) / counts.sum()
    p = p[p > 0]
    if p.size == 0:
        return np.nan
    return (1.0 / (1.0 - alpha)) * np.log2(np.sum(p**alpha))

def wavelet_entropy(sig, wavelet='db4', level=4):
    coeffs = pywt.wavedec(sig, wavelet, level=level)
    energies = np.array([np.sum(c**2) for c in coeffs])
    ps = energies / np.sum(energies)
    return -np.sum(ps * np.log2(ps + 1e-12))


# Diccionarios de características

caracteristicas_temporales = {
    "MAva": lambda sig: np.mean(np.abs(sig)),
    "bCP": lambda sig: np.count_nonzero(np.diff((np.abs(sig) < 0.1).astype(int))),
    "TCSC": lambda sig: np.sum(np.diff(np.sign(sig - 0.1)) != 0) + np.sum(np.diff(np.sign(sig + 0.1)) != 0),
    "TCin": lambda sig: (np.mean(np.diff(np.where(np.diff(np.sign(sig - 0.1)) != 0)[0]))
                        if len(np.where(np.diff(np.sign(sig - 0.1)) != 0)[0]) > 1 else 0),
    "SEal": lambda sig: np.mean(np.exp(-np.abs(sig))),
    "MEal": lambda sig: np.mean(np.exp(-np.square(sig))),
    "Count1": lambda sig: np.sum((sig >= -0.1) & (sig <= 0.1)),
    "Count2": lambda sig: np.sum((sig >= -0.2) & (sig <= 0.2)),
    "Count3": lambda sig: np.sum((sig >= -0.3) & (sig <= 0.3)),
}

caracteristicas_espectrales = {
    "CFre": lambda f, p: np.sum(f * p) / np.sum(p),
    "A1": lambda f, p: np.trapz(p[(f >= 0) & (f <= 125)], f[(f >= 0) & (f <= 125)]),
    "A2": lambda f, p: np.trapz(p[(f > 125) & (f <= 250)], f[(f > 125) & (f <= 250)]),
    "PSan": lambda f, p: np.mean(p),
    "CPow": lambda f, p: p[np.abs(f - (np.sum(f * p) / np.sum(p))).argmin()],
    "Y_Li": lambda f, p: (np.sum(p[(f >= 0.5) & (f <= 40)]) / np.sum(p)) if np.sum(p) > 0 else 0,
    "bW": lambda f, p: np.sqrt(np.sum(((f - (np.sum(f * p)/np.sum(p)))**2) * (p/np.sum(p)))),
    "VFLM": lambda f, p: (np.sum(p[(f >= 4) & (f <= 8)]) / np.sum(p)) if np.sum(p) > 0 else 0,
}

caracteristicas_complejas = {
    "HTra": lambda sig: np.mean(np.abs(hilbert(sig))),
    "CCal": lambda sig: np.var(sig),
    "ACal": lambda sig: np.trapz(np.abs(sig)),
    "FCal": lambda sig: frequency_calculation(sig, fs=500),
    "Kurt": lambda sig: kurtosis(sig),
    "CMea": lambda sig: complexity_measure(sig),
    "DEnt": lambda sig: EH.DispEn(sig, m=3, c=6, tau=1)[0],
    "Ener": lambda sig: energy(sig),
    "REnt": lambda sig: renyi_entropy(sig),
    "WEnt": lambda sig: wavelet_entropy(sig),
    "bWT": lambda sig: sum(np.sum(c**2) for c in pywt.wavedec(sig, 'db4', level=4)),
}

# Extracción de características

def extract_features_all(filtered_signals, signal_names):
    
    all_features = {}
    for i, lead in enumerate(signal_names):
        sig = filtered_signals[:, i]
        f, p = get_psd(sig)

        feats_temp = {f"{lead}_{nombre}": ftemp(sig) for nombre, ftemp in caracteristicas_temporales.items()}
        feats_spec = {f"{lead}_{nombre}": fesp(f, p) for nombre, fesp in caracteristicas_espectrales.items()}
        feats_comp = {f"{lead}_{nombre}": fcomp(sig) for nombre, fcomp in caracteristicas_complejas.items()}

        all_features.update(feats_temp)
        all_features.update(feats_spec)
        all_features.update(feats_comp)

    return pd.DataFrame([all_features])

