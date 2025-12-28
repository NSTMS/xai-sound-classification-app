AUDIO_CONFIG <- list(
  sample_rate = 44100, 
  duration = 4, # Czas trwania ścieżki w jednostkach
  units = "seconds",
  n_mels = 128, # Liczba mel-filtrów
  n_fft = 2048, # Rozmiar okna FFT
  hop_length = 512, # Krok przesunięcia okna
  fmin = 0,
  fmax = 22050, # sample_rate / 2
  freq_mask_length = 80, # maksymalna długość maski dla augmentacji spektrogramu
  time_mask_param = 80 # współczynnik przyspieszenia/zwolnienia dla augmentacji spektrogramu
)

MODEL_CONFIG <- list(
  img_height = 128,           # Wysokość obrazu mel-spektrogramu
  img_width = 169,            # Szerokość (4s * 22050 / 512 ≈ 172) , zaokrąglone do 169
  num_classes = 10,           # Liczba klas dźwięków
  batch_size = 32,
  epochs = 75,
  validation_split = 0.2,
  learning_rate = 0.001
)

PATHS <- list(
  dataset = "dataset/",
  audio = "audio/",
  metadata = "metadata.csv"
)