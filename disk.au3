#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

; ==================================================================================================
; APLIKACJA DO ODCZYTYWANIA DYSKÓW - WERSJA 1.0
; ==================================================================================================

; --- Konfiguracja aplikacji ---
Global $g_sFFmpegPath = '"' & @ScriptDir & '\bin\ffmpeg.exe"'         ; Ścieżka do FFmpeg
Global $g_sTesseractPath = '"' & @ScriptDir & '\bin\Tesseract-OCR\tesseract.exe"'  ; Ścieżka do Tesseract OCR
Global $g_sCameraName = 'video="Microsoft LifeCam Studio"'            ; UWAGA: Dostosuj do swojej kamery!
Global $g_sCameraRes = "1920x1080"                                    ; Rozdzielczość kamery
Global $g_sTempDir = @ScriptDir & "\temp"                             ; Folder na pliki tymczasowe

; --- Zmienne interfejsu użytkownika ---
Global $g_hMainGUI, $g_hRadio_Typ1, $g_hRadio_Typ2, $g_hRadio_Typ3, $g_hRadio_Typ4
Global $g_hInputSN, $g_hButtonStart, $g_hLabelStatus

; ==================================================================================================
; FUNKCJA GŁÓWNA
; ==================================================================================================

_Main()

; ==================================================================================================
; FUNKCJA GŁÓWNA - KONTROLUJE PRZEPŁYW APLIKACJI
; ==================================================================================================
Func _Main()
    ; Sprawdź dostępność wymaganych programów
    If Not _VerifyPrerequisites() Then
        MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Błąd Krytyczny", _
               "Nie znaleziono wymaganego oprogramowania w oczekiwanych folderach." & @CRLF & _
               "Aplikacja zostanie zamknięta.")
        Exit
    EndIf

    ; Przygotuj folder na pliki tymczasowe
    If Not FileExists($g_sTempDir) Then
        If Not DirCreate($g_sTempDir) Then
            MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Błąd", _
                   "Nie można utworzyć folderu tymczasowego: " & $g_sTempDir)
            Exit
        EndIf
    EndIf

    ; Utwórz interfejs użytkownika
    _CreateGUI()

    ; Główna pętla aplikacji - obsługa zdarzeń GUI
    Local $nMsg
    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                _ExitApp()
            Case $g_hButtonStart
                _StartProcess()
        EndSwitch
        Sleep(10)  ; Odciążenie procesora
    WEnd
EndFunc

; ==================================================================================================
; FUNKCJE POMOCNICZE
; ==================================================================================================

; --------------------------------------------------------------------------------------------------
; Sprawdza dostępność wymaganych programów (FFmpeg i Tesseract)
; --------------------------------------------------------------------------------------------------
Func _VerifyPrerequisites()
    ; Usuń cudzysłowy ze ścieżek przed sprawdzeniem istnienia plików
    Local $sFFmpegCheck = StringReplace($g_sFFmpegPath, '"', '')
    Local $sTesseractCheck = StringReplace($g_sTesseractPath, '"', '')
    
    If Not FileExists($sFFmpegCheck) Or Not FileExists($sTesseractCheck) Then
        Return False
    EndIf
    Return True
EndFunc

; --------------------------------------------------------------------------------------------------
; Tworzy główne okno aplikacji z elementami interfejsu użytkownika
; --------------------------------------------------------------------------------------------------
Func _CreateGUI()
    $g_hMainGUI = GUICreate("Aplikacja do Zdjęć Dysków", 400, 220)

    ; Grupa przycisków wyboru typu urządzenia
    GUICtrlCreateGroup("Wybierz typ urządzenia", 10, 10, 380, 80)
    $g_hRadio_Typ1 = GUICtrlCreateRadio("Typ 1 (4 dyski)", 20, 30, 150, 20)
    GUICtrlSetState($g_hRadio_Typ1, $GUI_CHECKED)  ; Domyślny wybór
    $g_hRadio_Typ2 = GUICtrlCreateRadio("Typ 2 (12 dysków)", 20, 55, 150, 20)
    $g_hRadio_Typ3 = GUICtrlCreateRadio("Typ 3 (6 dysków)", 200, 30, 150, 20)
    $g_hRadio_Typ4 = GUICtrlCreateRadio("Typ 4 (2 dyski)", 200, 55, 150, 20)
    GUICtrlCreateGroup("", -99, -99, 1, 1)  ; Zamknięcie grupy

    ; Pole wprowadzania numeru seryjnego
    GUICtrlCreateLabel("Wprowadź numer seryjny do weryfikacji:", 10, 105, 250, 20)
    $g_hInputSN = GUICtrlCreateInput("", 10, 125, 380, 25)
    GUICtrlSetFont($g_hInputSN, 10, 700)  ; Pogrubiona czcionka

    ; Przycisk rozpoczęcia procesu
    $g_hButtonStart = GUICtrlCreateButton("Start", 10, 160, 120, 40)

    ; Etykieta statusu
    $g_hLabelStatus = GUICtrlCreateLabel("Status: Oczekuję na rozpoczęcie...", 140, 170, 250, 20)
    GUICtrlSetFont($g_hLabelStatus, 9)

    GUISetState(@SW_SHOW)  ; Wyświetl okno
EndFunc

; ==================================================================================================
; FUNKCJE OBSŁUGI ZDARZEŃ
; ==================================================================================================

; --------------------------------------------------------------------------------------------------
; Rozpoczyna proces przetwarzania - główna logika aplikacji
; --------------------------------------------------------------------------------------------------
Func _StartProcess()
    ; Walidacja numeru seryjnego
    Local $sSN = GUICtrlRead($g_hInputSN)
    If StringLen(StringStripWS($sSN, 8)) = 0 Then
        MsgBox($MB_ICONWARNING, "Błąd", "Wprowadź numer seryjny!")
        Return
    EndIf
    
    ; Określ wybrany typ urządzenia
    Local $sDeviceType = _GetSelectedDeviceType()
    
    ; Zaktualizuj status
    GUICtrlSetData($g_hLabelStatus, "Status: Rozpoczynam proces dla " & $sDeviceType & "...")
    
    ; TODO: Implementacja głównej logiki robienia zdjęć
EndFunc

; --------------------------------------------------------------------------------------------------
; Określa aktualnie wybrany typ urządzenia na podstawie przycisków radio
; --------------------------------------------------------------------------------------------------
Func _GetSelectedDeviceType()
    If GUICtrlRead($g_hRadio_Typ1) = $GUI_CHECKED Then Return "Typ1 (4 dyski)"
    If GUICtrlRead($g_hRadio_Typ2) = $GUI_CHECKED Then Return "Typ2 (12 dysków)"
    If GUICtrlRead($g_hRadio_Typ3) = $GUI_CHECKED Then Return "Typ3 (6 dysków)"
    If GUICtrlRead($g_hRadio_Typ4) = $GUI_CHECKED Then Return "Typ4 (2 dyski)"
    Return "Typ1 (4 dyski)"  ; Wartość domyślna
EndFunc

; --------------------------------------------------------------------------------------------------
; Czyści zasoby i zamyka aplikację
; --------------------------------------------------------------------------------------------------
Func _ExitApp()
    ; Usuń pliki tymczasowe
    If FileExists($g_sTempDir) Then
        FileDelete($g_sTempDir & "\*.*")
    EndIf
    
    ; Zamknij interfejs użytkownika
    GUIDelete($g_hMainGUI)
    
    ; Zakończ aplikację
    Exit
EndFunc