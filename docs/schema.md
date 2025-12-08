# Schemat działania aplikacji

## Przygotowanie etykiet do klasyfikacji ścieżek

-   Wczytanie pliku CSV z etykietami
-   Przygotowanie wektora etykiet (x=ścieżka do pliku audio, y=etykieta klasy)

## Przygotowanie ścieżek audio

-   Wczytanie plików audio z katalogu
-   Konwersja stereo(jeśli ścieżka ma dwa kanały) do `mono`
-   Normalizacja długości ścieżek audio (do `4s`)
-   Resampling domyślnej częstotoliwości ścieżki do `41kHz`
-   Przekształcenie ścieżek audio do `spektrogramów melowych` (skala decybelowa zamiast amplitud, użycie STFT)

#### Uwagi:
- używamy `STFT`(w funkcji `transform_mel_spectrogram` z biblioteki `torchaudio` ) do uzyskania spektrogramów, ponieważ wykonuje ona `FFT` na krótkich, nakładających się fragmentach sygnału audio, co pozwala na analizę zmian częstotliwości w czasie. Nie używamy DFT bezpośrednio, ponieważ jest ona mniej efektywna obliczeniowo i nie dostarcza informacji o czasie. 

## Budowa modelu CNN

-   Definicja architektury modelu `CNN` *(konwolucyjna sieć neuronowa)*
-   Kompilacja modelu

## Trenowanie modelu

-   Podział danych na zbiór treningowy i walidacyjny
-   Trenowanie modelu na danych treningowych
-   Monitorowanie wydajności na zbiorze walidacyjnym

## Ewaluacja modelu

-   Ocena modelu na zbiorze testowym
