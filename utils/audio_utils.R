library(seewave)
library(tuneR)
library(torchaudio)
source("config.R")

load_and_resample_audio_sample <- function(audio_sample_path) {
  tryCatch(
    {
      wav <- readWave(
        audio_sample_path,
        from = 0,
        to = AUDIO_CONFIG$duration,
        units = AUDIO_CONFIG$units,
        header = FALSE,
        toWaveMC = NULL
      )

      if (isTRUE(wav@stereo)) {
        wav <- mono(wav, which = "both")
      } else {
        wav <- mono(wav, which = "left")
      }
      wav <- resample_audio_sample(wav)
      wav <- normalize_audio_sample_length(wav)
      return(wav)
    },
    error = function(e) {
      cat("Błąd przy wczytywaniu pliku:", e$message, "\n")
      return(NULL) # pominięcie pliku w przypadku błędu
    }
  )
}

normalize_audio_sample_length <- function(audio_sample) {
  tryCatch(
    {
      target_duration = AUDIO_CONFIG$duration
      target_length = AUDIO_CONFIG$sample_rate * target_duration
      current_data <- audio_sample@left
      current_length = length(current_data)
      diffrence = target_length - current_length
      if (diffrence > 0) {
        padding = rep(0, diffrence)
        audio_sample@left <- c(current_data, padding)
      } else if (diffrence < 0) {
        audio_sample@left <- current_data[1:target_length]
      }
      return(audio_sample)
    },
    error = function(e) {
      cat("Błąd przy normalizacji długości:", e$message, "\n")
      return(NULL) # pominięcie pliku w przypadku błędu
    }
  )
}

resample_audio_sample <- function(audio_sample) {
  resample_wav <- audio_sample
  tryCatch(
    {
      if (
        !is.na(audio_sample@samp.rate) &&
          audio_sample@samp.rate != AUDIO_CONFIG$sample_rate
      ) {
        resample_wav <- resamp(
          audio_sample,
          f = audio_sample@samp.rate,
          g = AUDIO_CONFIG$sample_rate,
          output = "Wave"
        )
      }
      return(resample_wav)
    },
    error = function(e) {
      cat("Błąd przy próbie resamplingu:", e$message, "\n")
      return(NULL) # pominięcie pliku w przypadku błędu
    }
  )
}

augment_spectrogram_with_time_mask <- function(mel_spec, time_mask_rate) {
  time_mask <- torchaudio::transform_timemasking(time_mask_param = time_mask_rate)
  time_masked_spectogram <- time_mask(mel_spec)
  return(time_masked_spectogram)
}


augment_spectrogram_with_frequency_mask <- function(mel_spec, mask_length) {
  freq_mask <- torchaudio::transform_frequencymasking(freq_mask_param = mask_length)
  frequency_masked_spectrogram <- freq_mask(mel_spec)
  return(frequency_masked_spectrogram)
}

mel_spectrogram_transformer <- torchaudio::transform_mel_spectrogram(
  sample_rate = AUDIO_CONFIG$sample_rate,
  n_mels = AUDIO_CONFIG$n_mels,
  n_fft = AUDIO_CONFIG$n_fft,
  hop_length = AUDIO_CONFIG$hop_length,
  f_min = AUDIO_CONFIG$fmin,
  f_max = AUDIO_CONFIG$fmax
)

create_tensorized_mel_spectrogram <- function(audio_sample) {
  waveform <- torch::torch_tensor(
    audio_sample@left,
    dtype = torch::torch_float()
  )
  mel_spectogram <- mel_spectrogram_transformer(waveform)
  return(mel_spectogram)
}

show_mel_spectogram <- function(wav) {
  spectro(
    wav,
    f = AUDIO_CONFIG$sample_rate,
    collevels = seq(-100, -15, 5),
    palette = get_random_seewave_color_pallette()
  )
}

get_random_seewave_color_pallette <- function() {
  return(sample(
    list(
      temp.colors,
      reverse.gray.colors.1,
      reverse.gray.colors.2,
      reverse.heat.colors,
      reverse.terrain.colors,
      reverse.topo.colors,
      reverse.cm.colors,
      heat.colors,
      terrain.colors,
      topo.colors,
      cm.colors
    ),1)[[1]])
}
