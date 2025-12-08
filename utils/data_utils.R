source("config.R")
source("utils/audio_utils.R")

load_metadata <- function(metadata_path) {
  if(!file.exists(metadata_path)) {
    stop("Plik metadanych nie istnieje: ", metadata_path)
  }
  metadata <- read.csv(metadata_path, stringsAsFactors = FALSE)
  cat("Wczytano:", nrow(metadata), "próbek\n")
  return(metadata)
}

load_audio_files <- function() {
  metadata <- load_metadata(paste0(getwd(), "/", PATHS$dataset, PATHS$metadata))
  audio_files <- c()
  for(i in 1:nrow(metadata))
  {
    audio_sample_data <- process_single_audio_sample(metadata[i,])
    audio_files <- append(audio_files, audio_sample_data)
  }
  return(audio_files)
}

process_single_audio_sample <- function(row){
  fold <- row$fold
  filename <- row$slice_file_name 
  classID <- row$classID
  audio_sample_path <- paste0(PATHS$dataset, PATHS$audio, "fold", fold, "/", filename)
  wav <- load_and_resample_audio_sample(audio_sample_path)
  show_mel_spectogram(wav)
  mel_spec <- create_tensorized_mel_spectrogram(wav)
    return(list(
      mel_spec = mel_spec,
      classID = classID
    ))
}