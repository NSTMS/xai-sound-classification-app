AUDIO_CONFIG <- list(
  sample_rate = 44100, 
  duration = 4, # Czas trwania ścieżki w jednostkach
  units = "seconds",
  n_mels = 128, # Liczba mel-filtrów
  n_fft = 2048, # Rozmiar okna FFT
  hop_length = 512, # Krok przesunięcia okna
  fmin = 0,
  fmax = 22050 # sample_rate/2
)

PATHS <- list(
  dataset = "dataset/",
  audio = "audio/",
  metadata = "metadata.csv"
)