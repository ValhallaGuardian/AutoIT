#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

; ==================================================================================================
; KROK 1 (Wersja poprawiona): FUNDAMENTY - GUI I KONFIGURACJA W JEDNYM PLIKU
; ==================================================================================================

; --- Konfiguracja "zaszyta" w kodzie ---
; Wszystkie ustawienia znajdują się tutaj. Jeśli chcesz coś zmienić (np. nazwę kamery),
; zrób to w tym miejscu. Ścieżki używają @ScriptDir, co oznacza, że programy
; (ffmpeg, Tesseract) muszą znajdować się w podfolderach względem pliku skryptu.
Global $g_sFFmpegPath = @ScriptDir & "\bin\ffmpeg.exe"
Global $g_sTesseractPath = @ScriptDir & "\bin\Tesseract-OCR\tesseract.exe"
Global $g_sCameraName = 'video="Microsoft LifeCam Studio"' ; <== WAŻNE! Zmień na dokładną nazwę swojej kamery!
Global $g_sCameraRes = "1920x1080"
Global $g_sTempDir = @ScriptDir & "\temp" ; Folder na tymczasowe zdjęcia

; --- Deklaracje zmiennych globalnych dla GUI ---
Global $g_hMainGUI, $g_hRadio_Typ1, $g_hRadio_Typ2, $g_hRadio_Typ3, $g_hRadio_Typ4
Global $g_hInputSN, $g_hButtonStart, $g_hLabelStatus

; --- Główna logika skryptu ---
_Main()

Func _Main()
    ; 1. Sprawdź, czy wymagane programy (ffmpeg, Tesseract) istnieją w skonfigurowanych ścieżkach.
    If Not _VerifyPrerequisites() Then
        MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Błąd Krytyczny", "Nie znaleziono wymaganego oprogramowania (ffmpeg lub Tesseract) w oczekiwanych folderach:" & @CRLF & _
            $g_sFFmpegPath & @CRLF & $g_sTesseractPath & @CRLF & "Aplikacja zostanie zamknięta.")
        Exit
    EndIf

    ; 2. Upewnij się, że folder na tymczasowe pliki istnieje.
    If Not FileExists($g_sTempDir) Then DirCreate($g_sTempDir)

    ; 3. Stwórz główny interfejs użytkownika (GUI)
    _CreateGUI()

    ; 4. Pętla utrzymująca działanie skryptu w trybie zdarzeniowym.
    While 1
        Sleep(100)
    WEnd
EndFunc

; --- Funkcje pomocnicze ---

; Funkcja weryfikująca, czy kluczowe programy istnieją.
Func _VerifyPrerequisites()
    If Not FileExists($g_sFFmpegPath) Or Not FileExists($g_sTesseractPath) Then
        Return False
    EndIf
    Return True
EndFunc

; Funkcja tworząca główny interfejs użytkownika
Func _CreateGUI()
    $g_hMainGUI = GUICreate("Aplikacja do Zdjęć Dysków", 400, 220)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_ExitApp")

    ; Etykieta i grupa dla wyboru typu urządzenia
    Local $hGroupDevice = GUICtrlCreateGroup("Wybierz typ urządzenia", 10, 10, 380, 80)
    $g_hRadio_Typ1 = GUICtrlCreateRadio("Typ 1 (4 dyski)", 20, 30, 150, 20)
    GUICtrlSetState($g_hRadio_Typ1, $GUI_CHECKED) ; Domyślnie zaznaczony
    $g_hRadio_Typ2 = GUICtrlCreateRadio("Typ 2 (12 dysków)", 20, 55, 150, 20)
    $g_hRadio_Typ3 = GUICtrlCreateRadio("Typ 3 (6 dysków)", 200, 30, 150, 20)
    $g_hRadio_Typ4 = GUICtrlCreateRadio("Typ 4 (2 dyski)", 200, 55, 150, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1) ; Zamknięcie grupy

    ; Pole do wpisania numeru seryjnego
    Local $hLabelSN = GUICtrlCreateLabel("Wprowadź numer seryjny do weryfikacji:", 10, 105, 250, 20)
    $g_hInputSN = GUICtrlCreateInput("", 10, 125, 380, 25)
    GUICtrlSetFont($g_hInputSN, 10, 700)

    ; Przycisk Start i etykieta statusu
    $g_hButtonStart = GUICtrlCreateButton("Start", 10, 160, 120, 40)
    GUISetOnEvent($g_hButtonStart, "_StartProcess")

    $g_hLabelStatus = GUICtrlCreateLabel("Status: Oczekuję na rozpoczęcie...", 140, 170, 250, 20)
    GUICtrlSetFont($g_hLabelStatus, 9)

    GUISetState(@SW_SHOW)
EndFunc

; --- Funkcje obsługi zdarzeń ---

; Funkcja, która uruchomi główny proces (będziemy ją rozwijać w kolejnych krokach)
Func _StartProcess()
    GUICtrlSetData($g_hLabelStatus, "Status: Proces rozpoczęty...")
    ; TODO: W kolejnych krokach dodamy tutaj logikę robienia zdjęć
EndFunc

; Funkcja do zamknięcia aplikacji
Func _ExitApp()
    ; Przed zamknięciem posprzątajmy folder tymczasowy
    If FileExists($g_sTempDir) Then
        FileDelete($g_sTempDir & "\*.*")
    EndIf
    Exit
EndFunc