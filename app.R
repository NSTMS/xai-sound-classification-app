source("config.R")
source("utils/audio_utils.R")
source("utils/data_utils.R")
source("utils/cnn_utils.R")
data <- load_audio_files()
# Autor biblioteki torchaudio nie zaimplementował jeszcze funckjonalości potrzebnych do realizacji augmentacji, funkcja augment_audio_files będzie zwracała błąd: not_implemented_error()
# diversed_data <- augment_audio_files(data)
train_model(data)

