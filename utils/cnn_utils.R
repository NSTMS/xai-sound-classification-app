library(torch)
source("config.R")

cnn_network <- nn_module(
  "CNNNetwork",
  
  initialize = function() {
    self$conv1 <- nn_sequential(
      nn_conv2d(
        in_channels = 1,
        out_channels = 16,
        kernel_size = 3,
        stride = 1,
        padding = 2
      ),
      nn_relu(),
      nn_max_pool2d(kernel_size = 2)
    )
    
    self$conv2 <- nn_sequential(
      nn_conv2d(
        in_channels = 16, # 16 wyjściowych warstw z poprzedniej konwolucji
        out_channels = 32,
        kernel_size = 3,
        stride = 1,
        padding = 2
      ),
      nn_relu(),
      nn_max_pool2d(kernel_size = 2)
    )
    
    self$conv3 <- nn_sequential(
      nn_conv2d(
        in_channels = 32, # 32 wyjściowych warstw z poprzedniej konwolucji
        out_channels = 64,
        kernel_size = 3,
        stride = 1,
        padding = 2
      ),
      nn_relu(),
      nn_max_pool2d(kernel_size = 2)
    )
    
    self$conv4 <- nn_sequential(
      nn_conv2d(
        in_channels = 64, # 64 wyjściowych warstw z poprzedniej konwolucji
        out_channels = 128,
        kernel_size = 3,
        stride = 1,
        padding = 2
      ),
      nn_relu(),
      nn_max_pool2d(kernel_size = 2)
    )
    
    self$flatten <- nn_flatten()
    self$linear <- nn_linear(128 * 5 * 4, 10) # 10 - liczba klas do klasyfikacji
    self$softmax <- nn_softmax(dim = 2)
  },
  
  forward = function(input_data) {
    x <- self$conv1(input_data)
    x <- self$conv2(x)
    x <- self$conv3(x)
    x <- self$conv4(x)
    x <- self$flatten(x)
    logits <- self$linear(x)
    predictions <- self$softmax(logits)
    return(predictions)
  }
)



# [TO:DO] zaimplementowanie trenowania i ewaluacj modelu CNN
train_model <- function(audio_files) {
  device <- if (cuda_is_available()) "cuda" else "cpu"
  cat(sprintf("Using device: %s\n", device))
  
  dataset <- audio_files
  
  train_size <- floor(0.8 * dataset$.length())
  val_size <- dataset$.length() - train_size
  
  indices <- sample(1:dataset$.length())
  train_indices <- indices[1:train_size]
  val_indices <- indices[(train_size + 1):dataset$.length()]
  
  train_dataset <- dataset_subset(dataset, train_indices)
  val_dataset <- dataset_subset(dataset, val_indices)
  
  train_loader <- dataloader(train_dataset, batch_size = batch_size, shuffle = TRUE)
  val_loader <- dataloader(val_dataset, batch_size = batch_size, shuffle = FALSE)
  
  model <- cnn_network()
  model$to(device = device)
  
  loss_fn <- nn_cross_entropy_loss()
  optimiser <- optim_adam(model$parameters, lr = learning_rate)
  
  best_accuracy <- 0
  # [TO:DO] Training loop


  
  cat(sprintf("\nTraining completed! Best accuracy: %.2f%%\n", best_accuracy))
  return(model)
}