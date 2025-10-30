import numpy as np
import wfdb
from scipy.signal import butter, filtfilt, convolve
from scipy.signal.windows import hann

# Variables globales
filtered_signals_global = None
signal_names_global = None

# FILTRADO

def butter_bandpass(lowcut, highcut, fs, order=4):

    nyquist = 0.5 * fs
    low = lowcut / nyquist
    high = highcut / nyquist
    b, a = butter(order, [low, high], btype="band")
    return b, a


def apply_filter(data, lowcut, highcut, fs):
    # Aplica filtrado paso banda Butterworth y suavizado Hanning
    # Pasa banda
    b, a = butter_bandpass(lowcut, highcut, fs)
    bandpass_filtered = filtfilt(b, a, data)

    # Suavizado con ventana Hanning
    window_size = int(fs / 30)
    if window_size % 2 == 0:
        window_size += 1
    hanning_kernel = hann(window_size) / np.sum(hann(window_size))
    smoothed_signal = convolve(bandpass_filtered, hanning_kernel, mode="same")

    return smoothed_signal


# PREPROCESAMIENTO

def preprocessing(hea_file, dat_file, lowcut=0.5, highcut=40, fs=500):
    
    
    global filtered_signals_global, signal_names_global

    # Leer registro WFDB 
    record_path = hea_file.replace(".hea", "")
    rd_record = wfdb.rdrecord(record_path)

    # Filtrar todas las señales
    filtered_signals = []
    for i in range(rd_record.p_signal.shape[1]):
        signal = rd_record.p_signal[:, i]
        filtered = apply_filter(signal, lowcut, highcut, fs)
        filtered_signals.append(filtered)

    filtered_signals = np.array(filtered_signals).T

    # Guardar en variables globales
    filtered_signals_global = filtered_signals
    signal_names_global = rd_record.sig_name

    return filtered_signals, signal_names_global
