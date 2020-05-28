.586p
.model flat, stdcall
;-------------------------------------------|
;     wczytanie plikow zewnetrznych         |
;-------------------------------------------| 
;-------------------------------------------|
;    wczytanie wlasnych makr z pliku        |
;-------------------------------------------|
include mojemakra.mac	; Makra
include cw8.mac
;include .\include\masm32rt.inc
;-------------------------------------------|
;      bilioteki systemowe i masm           |
;-------------------------------------------|
includelib .\lib\user32.lib
includelib .\lib\kernel32.lib
includelib .\lib\masm32.lib
;-------------------------------------------|
;  Sta�e do zadania 8                       |
;-------------------------------------------|
KEY_EVENT EQU 1h ; zdarzenie klawiatury
MOUSE_EVENT EQU 2h ; zdarzenie myszy
MENU_EVENT EQU 8h
FOCUS_EVENT EQU 10h
RIGHT_ALT_PRESSED EQU 1h ; Alt prawy
LEFT_ALT_PRESSED EQU 2h ; Alt lewy
RIGHT_CTRL_PRESSED EQU 4h ; Ctrl prawy
LEFT_CTRL_PRESSED EQU 8h ; Ctrl lewy
SHIFT_PRESSED EQU 10h ; Shift naci�ni�ty
NUMLOCK_ON EQU 20h ; Num Lock w��czony
SCROLLLOCK_ON EQU 40h ; Scroll Lock w��czony
CAPSLOCK_ON EQU 80h ; Caps Lock w��czony
ENHANCED_KEY EQU 100h ; klawisz jest zwolniony
FROM_LEFT_1ST_BUTTON_PRESSED EQU 1h ; przycisk lewy
RIGHTMOST_BUTTON_PRESSED EQU 2h ; przycisk prawy
FROM_LEFT_2ND_BUTTON_PRESSED EQU 4h ; przycisk srodkowy
FROM_LEFT_3ND_BUTTON_PRESSED EQU 8h ; przycisk trzeci z lewa
FROM_LEFT_4ND_BUTTON_PRESSED EQU 10h ;przycisk 4-ty z lewa
MOUSE_MOVED EQU 1h ; mysz przesuwa si�
DOUBLE_CLICK EQU 2h ; podw�jne klikniecie
MOUSE_WHEELED EQU 4h ; poruszenie k�kiem myszy
;--- struktury z pliku windows.inc ----------
coord STRUCT
X DW ?
Y DW ?
coord ENDS
MOUSE_EVENT_RECORD STRUCT
dwMousePosition coord <> ; wsp�rz�dne X, Y kursora myszy
dwButtonState dword ? ; znaczniki naci�ni�cia przycisk�w myszy
dwControlKeyState dword ? ; znaczniki naci�ni�cia klawiszy steruj�cych
dwEventFlags dword ? ; znaczniki przesuwania i podw�jnego klik-niecie myszy
MOUSE_EVENT_RECORD ENDS
KEY_EVENT_RECORD STRUCT
bKeyDown dword ? ;znacznik naci�ni�cia kt�regokolwiek klawisza
wRepeatCount WORD ? ; ilo�� powt�rze� kodu przy d�ugim naci�ni�ciu
wVirtualKeyCode WORD ? ; wirtualny kod klawisza
wVirtualScanCode WORD ? ; scan-kod klawisza
UNION
UnicodeChar WORD ? ; UNICODE kod klawisza
AsciiChar BYTE ? ; ASCII kod klawisza
ENDS
dwControlKeyState dword ? ;znaczniki klawiszy steruj�cych
KEY_EVENT_RECORD ENDS
WINDOW_BUFFER_SIZE_RECORD STRUCT
dwSize coord <>
WINDOW_BUFFER_SIZE_RECORD ENDS
MENU_EVENT_RECORD STRUCT
dwCommandId dword ?
MENU_EVENT_RECORD ENDS
FOCUS_EVENT_RECORD STRUCT
bSetFocus dword ?
FOCUS_EVENT_RECORD ENDS
INPUT_RECORD STRUCT ;struktura z informacj� o zdarzeniu
EventType WORD ? ; typ zdarzenia
two_byte_alignment WORD ? ; wyr�wnanie do granicy/4
UNION
KeyEvent KEY_EVENT_RECORD <>
MouseEvent MOUSE_EVENT_RECORD <>
WindowBufferSizeEvent WINDOW_BUFFER_SIZE_RECORD <>
MenuEvent MENU_EVENT_RECORD <>
FocusEvent FOCUS_EVENT_RECORD <>
ENDS
INPUT_RECORD ENDS
;-------------------------------------------|
;    stale z pliku .\include\windows.inc    |
;-------------------------------------------|
STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11
GetStdHandle proto :dword
ReadConsoleA proto :dword,:dword,:dword,:dword,:dword
WriteConsoleA proto :dword,:dword,:dword,:dword,:dword
ExitProcess proto :dword
wsprintfA proto c :vararg
lstrlenA proto :dword
;--- funkcje API Win32 z pliku .\include\user32.inc ---
CharToOemA proto :dword,:dword
AllocConsole proto
FreeConsole proto
SetConsoleTitleA proto :dword
SetConsoleTextAttribute proto :dword,:dword
GetLargestConsoleWindowSize proto :dword
FillConsoleOutputAttribute proto :dword,:dword,:dword,:coord,:dword
SetConsoleCursorPosition proto :dword, :coord
ReadConsoleInputA proto :dword,:dword,:dword,:dword
FlushConsoleInputBuffer proto :dword
WriteConsoleOutputCharacterA proto :dword,:dword,:dword,:coord,:dword


;--------------------------------|
;--- wlasne defeinicje           |
;--------------------------------|
Cls proto 	; czyszczenie akranu przez przewiniecie
Menu proto 	; wy�wietlanie menu	
;--------------------------------|
; ---- koniec wlasnych def       |
;--------------------------------|
;--------------------------------|
;            stale               |
;--------------------------------|
mbuf = 512
kolorb = 00010001b ; Niebieski - BG_I,G,R,B,FG__I,G,R,B
kolorw = 11111111b ; Bia�y - BG_I,G,R,B,FG__I,G,R,B
kolorc = 01000100b ; Czerwony BG_I,G,R,B,FG__I,G,R,B
kolor1 = 00000111b ; Kolory: BG_I,G,R,B,FG__I,G,R,B
kolor2 = 01100001b ; Kolory: BG_I,R,G,B,FG__I,R,G,B
;------------
;clear db "20h"
_data segment
hout dd 0
hinp dd ? ; deskryptor buforu wej�ciowego
rout dd 0
szkola1 db "Warszawska Uczelnia Medyczna",0
sz1 dd $ - szkola1
align 4
szkola2 db "im. Tadeusza Ko�luka",0
sz2 dd $ - szkola2
align 4
szkola3 db "�wiczenie z programowania niskopozomowego",0
sz3 dd $ - szkola3
align 4
szkola4 db "Obs�uga klawiatury i myszy",0
sz4 dd $ - szkola4
align 4
szkola5 db "Wariant N 8",0
sz5 dd $ - szkola5
align 4
szkola6 db '"Obs�uga klawiszy H i I oraz Lewy Alt + lewy myszy"',0
sz6 dd $ - szkola6
align 4
tytul db "PWSBiA - Grzegorz Makowski@2020",0
ALIGN 4
tytulr dd $ - tytul ;ilo�� znak�w tablicy tytu�
tytulA db "Aplikacj� konsolow� stworzy� Grzegorz Makowski",0
ALIGN 4
tytulrozm dd $ - tytulA ;ilo�� znak�w tablicy tytu�
align 4
menuTekst db "....:::: MENU ::::.... "
menuR dd $ - menuTekst
naglow db "Autor aplikacji Grzegorz Makowski i53",0
align 4 ; przesuniecie do adresu podzielnego na 4
rozmN dd $ - naglow ;ilo�� znak�w w tablicy
zadanieA db "Zadanie a) wci�nij klawisz [A/a]",0
rozmA dd $ - zadanieA ; ilosc znakow tekstu zadanieA
align 4
zadanieB db "Zadanie b) wci�nij klawisz [B/b]",0
rozmB dd $ - zadanieB
align 4
zadanieC db "Zadanie c) wci�nij klawisz [C/c]",0
rozmC dd $ - zadanieC
align 4
zakonczenie db "Wci�nij klawisz [Q/q] aby wyj�� z programu.",0
zakR dd $ - zakonczenie
align 4
wybrany db "Wybra�e� klawisz : [ ]",0
wybrR dd $ - wybrany
align 4
student db "Wykona�: Grzegorz Makowski i53",0
stuR dd $ - student
align 4
profesor db "Prowadz�cy: Prof. dr hab. in�. Aleksandr Timofiejew",0
proR dd $ - profesor
align 4
tab dd 100 dup(0)
bufor db mbuf dup(0)
leng dd 0
buf db mbuf dup(0)		; bufor pomocniczy
buff db mbuf dup(0)		; bufor pomocniczy
zmMenu	dd 4 			; zmienna do trzymania wyniku z manu
rbuf	dd	mbuf
rinp	dd	0 ;faktyczna ilo�� wprowadzonych znak�w
ile 	dd 0
nl db 0Dh, 0Ah, 0	; nowa linia
nl2	db 0Dh,0Ah,20h,0 ; nowa inne formatowanie
nxt db 13,10,0 ; nastepny wiersz
rogGL db 0c9h ; rog g�ra lewy
rogGP db 0bbh ; r�g g�ra prawy
prosta db 0cdh ; prosta pozioma
pion db 0bah    ; prosta pionowa
pionL db 0cch   ; pionowa w lewe skrzyzowanie
pionP db 0b9h	; pionowa w prawo skrzyzowanie
rogDL db 0c8h	; r�g d� lewy
rogDP db 0bch	; r�g d� prawy 
spacja db 020h
licznik1 db "1",0
licznik2 db "15"
;--------------
nzdarz dd ? ; ilo�� zdarze�
zapis INPUT_RECORD <>
YX COORD <>
symb db 'A'
rkom dd ? ; ilo�� kom�rek konsoli
rfakt dd ? ; faktyczna ilo�� kom�rek konsoli
wierszB db "Zako�czy� mo�na klawiszami klawiszami H, I wprowadzasz znaki [ ]",0Dh,0Ah,0
ALIGN 4
wierszrB dd $ - wierszB ;ilo�� znak�w tablicy wiersz
niebieski dd kolorb
bialy dd kolorw
czerwony dd kolorc
atryb dd kolor2
atryb1 dd kolor1
align 4
tekst db "Kolory s� ustawione przez Grzegorza Makowskiego"
rozmT dd $ - tekst
align 4
wierszC db "Zadanie mo�na zako�czy� klawiszami Lewy Alt + Lewy przycisk myszy lub "
db " klawiszami H, I lub h, i",0Dh,0Ah,0
wierszrC dd $ - wierszC ;ilo�� znak�w tablicy wiersza
align 4
LeKlMyszy db "FROM_LEFT_1ST_BUTTON_PRESSED",0
LeKlMyszyr dd $ - LeKlMyszy
align 4
;------------------
_data ends
;----------------------------------------|
;    Koniec segmentu danych              |
;----------------------------------------|

;----------------------------------------|
;    Poczatek segmentu kodu              |
;----------------------------------------|
_text segment
start:
;--- tworzenie konsoli ---
INVOKE FreeConsole
INVOKE AllocConsole
;--- nag��wek okna ---
INVOKE CharToOemA,OFFSET tytul,OFFSET tytul ; konwersja polskich znak�w
INVOKE SetConsoleTitleA,OFFSET tytul
;--- deskryptory bufor�w ---
INVOKE GetStdHandle, STD_OUTPUT_HANDLE ; wywo�anie funkcji GetStdHandle
mov hout, EAX
INVOKE GetStdHandle, STD_INPUT_HANDLE ; wywo�anie funkcji GetStdHandle
mov hinp, EAX
;--- obliczenie rozmiaru buforu ekranu
INVOKE GetLargestConsoleWindowSize,hout
mov YX, EAX
movzx EAX, YX.X
movzx EBX, YX.Y
mul EBX
mov rkom, EAX
mov YX.X, 0
mov YX.Y, 0
call Menu
mov YX.X, 69
mov YX.Y, 22
INVOKE SetConsoleCursorPosition,hout,COORD PTR [YX] ;ustawienie pozycji kursora
;--- p�tla
powt:
;--- odczyt komunikatu zdarzenia
INVOKE FlushConsoleInputBuffer,hinp ;czyszczenie kolejki komunikat�w
INVOKE ReadConsoleInputA,hinp,OFFSET zapis,1,OFFSET nzdarz ; odczyt komunikatu zdarzenia
cmp WORD PTR [zapis.EventType], KEY_EVENT
je @F
jmp powt
@@:
jmp klaw

;--- komunikat od klawiatury ---
klaw:
cmp (KEY_EVENT_RECORD PTR [zapis.KeyEvent]).bKeyDown, 0 ; por�wnanie z zerem
jne @F
jmp powt ;je�li nie ma naci�ni�cia
@@:
mov AL,(KEY_EVENT_RECORD PTR [zapis.KeyEvent]).ASCIIChar
mov symb,AL
cmp AL, 051h ; por�wnanie z kodem Q
jne @F
jmp kon
@@:
cmp AL, 071h ; por�wnanie z kodem q
jne @F
jmp kon
@@:
cmp AL, 041h ; por�wnanie z kodem A
jne @F
jmp zadanie_a
@@:
cmp AL, 061h ; por�wnanie z kodem a
jne @F
jmp zadanie_a
@@:
cmp AL, 042h ; por�wnanie z kodem B
jne @F
jmp zadanie_b
@@:
cmp AL, 062h ; por�wnanie z kodem b
jne @F
jmp zadanie_b
@@:
cmp AL, 043h ; por�wnanie z kodem C
jne @F
jmp zadanie_c
@@:
cmp AL, 063h ; por�wnanie z kodem c
jne @F
jmp zadanie_c
@@:
INVOKE WriteConsoleOutputCharacterA,hout,OFFSET symb,1,COORD PTR [YX],OFFSET rout ; wypisywanie znaku
jmp powt
;--------------------------------|
; koniec menu                    |
;--------------------------------|
;--------------------------------|
; Zadanie a                      |
;--------------------------------|
zadanie_a:
;--- tworzenie konsoli ---
INVOKE FreeConsole
INVOKE AllocConsole
;--- nag��wek okna ---
INVOKE CharToOemA,OFFSET tytul,OFFSET tytul ; konwersja polskich znak�w
INVOKE SetConsoleTitleA,OFFSET tytul
;--- deskryptory bufor�w ---
INVOKE GetStdHandle, STD_OUTPUT_HANDLE ; wywo�anie funkcji GetStdHandle
mov hout, EAX
INVOKE GetStdHandle, STD_INPUT_HANDLE ; wywo�anie funkcji GetStdHandle
mov hinp, EAX
;--- obliczenie rozmiaru buforu ekranu
INVOKE GetLargestConsoleWindowSize,hout
mov YX, EAX
movzx EAX, YX.X
movzx EBX, YX.Y
mul EBX
mov rkom, EAX
;--- nape�nienie kom�rek jednakowym atrybutem ---
mov YX.X, 0
mov YX.Y, 0
;--- ustawienie koloru konsoli ---
INVOKE SetConsoleTextAttribute,hout,kolor1
INVOKE FillConsoleOutputAttribute, hout, kolor2, rkom, COORD PTR [YX], OFFSET rfakt
;--- wyprowadzenie komunikatu informacyjnego ---
mov YX.X, 10
mov YX.Y, 15
INVOKE SetConsoleCursorPosition, hout, YX
plznaki tekst, tekst 			; makro
wyswietl offset tekst, rozmT	; makro
;--- op�nienie zamkni�cia okna ---
mov ECX, 07FFFFFFFh
etykA: loop etykA
;--- zamkni�cie konsoli
konA:
INVOKE FreeConsole
jmp start
;---------------------------|
; koniec zadania a          |
;---------------------------|
;---------------------------|
; Zadanie b                 |
;---------------------------|
zadanie_b:
;--- tworzenie konsoli ---
INVOKE FreeConsole
INVOKE AllocConsole
;--- nag��wek okna ---
INVOKE CharToOemA,OFFSET tytul,OFFSET tytul ; konwersja polskich znak�w
INVOKE SetConsoleTitleA,OFFSET tytul
;--- deskryptory bufor�w ---
INVOKE GetStdHandle, STD_OUTPUT_HANDLE ; wywo�anie funkcji GetStdHandle
mov hout, EAX
INVOKE GetStdHandle, STD_INPUT_HANDLE ; wywo�anie funkcji GetStdHandle
mov hinp, EAX
;--- obliczenie rozmiaru buforu ekranu
INVOKE GetLargestConsoleWindowSize,hout
mov YX, EAX
movzx EAX, YX.X
movzx EBX, YX.Y
mul EBX
mov rkom, EAX
;--- nape�nienie kom�rek jednakowym atrybutem ---
mov YX.X, 0
mov YX.Y, 0
INVOKE FillConsoleOutputAttribute,hout,niebieski,rkom, \
COORD PTR [YX],OFFSET rfakt
;--- wyprowadzenie komunikatu informacyjnego ---
mov YX.X, 0
mov YX.Y, 29
INVOKE SetConsoleCursorPosition, hout, YX
INVOKE SetConsoleTextAttribute,hout,atryb1
plznaki wierszB, wierszB
wyswietl offset wierszB, wierszrB
;--- ustawienie kursora
mov YX.X, 62
mov YX.Y, 29
INVOKE SetConsoleCursorPosition,hout,COORD PTR [YX] ;ustawienie pozycji kursora
;--- p�tla
powtB:
;--- odczyt komunikatu zdarzenia
INVOKE FlushConsoleInputBuffer,hinp ;czyszczenie kolejki komunikat�w
INVOKE ReadConsoleInputA,hinp,OFFSET zapis,1,OFFSET nzdarz ; odczyt komunikatu zdarzenia
;--- sprawdzanie typu zdarzenia
cmp WORD PTR [zapis.EventType], KEY_EVENT
je @F
jmp powtB
@@:
jmp klawB
INVOKE SetConsoleCursorPosition,hout,COORD PTR [YX] ; ustawienie pozycji kursora
;--- komunikat od klawiatury ---
klawB:
cmp (KEY_EVENT_RECORD PTR [zapis.KeyEvent]).bKeyDown, 0 ; por�wnanie z zerem
jne @F
jmp powtB ;je�li nie ma naci�ni�cia
@@:
mov AL,(KEY_EVENT_RECORD PTR [zapis.KeyEvent]).ASCIIChar
mov symb,AL
cmp AL, 048h ; por�wnanie z kodem H
jne @F
jmp etykB
@@:
cmp AL, 068h ; por�wnanie z kodem h
jne @F
jmp etykB
@@:
INVOKE WriteConsoleOutputCharacterA,hout,OFFSET symb,1,COORD PTR [YX],OFFSET rout ; wypisywanie znaku
jmp powtB
etykB:
INVOKE FlushConsoleInputBuffer,hinp ;czyszczenie kolejki komunikat�w
INVOKE ReadConsoleInputA,hinp,OFFSET zapis,1,OFFSET nzdarz ; odczyt komunikatu zdarzenia
cmp WORD PTR [zapis.EventType], KEY_EVENT
je @F
jmp etykB
@@:
jmp klaw2B
klaw2B:
cmp (KEY_EVENT_RECORD PTR [zapis.KeyEvent]).bKeyDown, 0 ; por�wnanie z zerem
jne @F
jmp etykB ;je�li nie ma naci�ni�cia
@@:
mov AL,(KEY_EVENT_RECORD PTR [zapis.KeyEvent]).ASCIIChar
mov symb,AL
cmp AL, 049h ; por�wnanie z kodem I
jne @F
jmp konB
@@:
cmp AL, 069h ; por�wnanie z kodem i
jne @F
jmp konB
@@:
INVOKE WriteConsoleOutputCharacterA,hout,OFFSET symb,1,COORD PTR [YX],OFFSET rout ; wypisywanie znaku
jmp powtB
;--- zamkni�cie konsoli
konB:
INVOKE FreeConsole
jmp start
;--------------------------------|
; Koniec zadania B               |
;--------------------------------|

;--------------------------------|
; Zadanie C                      |
;--------------------------------|
zadanie_c:
;--- tworzenie konsoli ---
INVOKE FreeConsole
INVOKE AllocConsole
;--- nag��wek okna ---
INVOKE CharToOemA,OFFSET tytul,OFFSET tytul ; konwersja polskich znak�w
INVOKE SetConsoleTitleA,OFFSET tytul
;--- deskryptory bufor�w ---
INVOKE GetStdHandle, STD_OUTPUT_HANDLE ; wywo�anie funkcji GetStdHandle
mov hout, EAX
INVOKE GetStdHandle, STD_INPUT_HANDLE ; wywo�anie funkcji GetStdHandle
mov hinp, EAX
;--- obliczenie rozmiaru buforu ekranu
INVOKE GetLargestConsoleWindowSize,hout
mov YX, EAX
movzx EAX, YX.X
movzx EBX, YX.Y
mul EBX
mov rkom, EAX
;--- nape�nienie kom�rek jednakowym atrybutem ---
mov YX.X, 0
mov YX.Y, 0
INVOKE FillConsoleOutputAttribute,hout,czerwony,rkom, \
COORD PTR [YX],OFFSET rfakt
;--- wyprowadzenie komunikatu informacyjnego ---
mov YX.X, 0
mov YX.Y, 29
INVOKE SetConsoleCursorPosition, hout, YX
INVOKE SetConsoleTextAttribute,hout,atryb1
plznaki wierszC, wierszC
wyswietl offset wierszC, wierszrC
;--- ustawienie kursora
mov YX.X, 0
mov YX.Y, 1
INVOKE SetConsoleCursorPosition,hout,COORD PTR [YX] ;ustawienie pozycji kursora
;--- p�tla
powtC:
;--- odczyt komunikatu zdarzenia
INVOKE FlushConsoleInputBuffer,hinp ;czyszczenie kolejki komunikat�w
INVOKE ReadConsoleInputA,hinp,OFFSET zapis,1,OFFSET nzdarz ; odczyt komunikatu zdarzenia
;--- sprawdzanie typu zdarzenia
cmp WORD PTR [zapis.EventType], MOUSE_EVENT
je myszC
cmp WORD PTR [zapis.EventType], KEY_EVENT
je klawC
jmp powtC
;--- komunikat od myszy
myszC:
test (MOUSE_EVENT_RECORD PTR [zapis.MouseEvent]).dwButtonState, FROM_LEFT_1ST_BUTTON_PRESSED
jnz @F
jmp powtC ; na koniec programu
@@:
test (MOUSE_EVENT_RECORD PTR [zapis.MouseEvent]).dwControlKeyState, LEFT_ALT_PRESSED
jz @F
jmp konC
@@:
;--- jest naci�ni�ty prawy klawisz myszy
mov EAX, (MOUSE_EVENT_RECORD PTR [zapis.MouseEvent]).dwMousePosition ; wsp�rz�dne X,Y
mov COORD PTR [YX], EAX ; wsp�rz�dne X,Y
INVOKE SetConsoleCursorPosition,hout,COORD PTR [YX] ; ustawienie pozycji kursora
jmp powtC
;--- komunikat od klawiatury ---
klawC:
cmp (KEY_EVENT_RECORD PTR [zapis.KeyEvent]).bKeyDown, 0 ; por�wnanie z zerem
jne @F
jmp powtC ;je�li nie ma naci�ni�cia
@@:
mov AL,(KEY_EVENT_RECORD PTR [zapis.KeyEvent]).ASCIIChar
mov symb,AL
cmp AL, 048h ; por�wnanie z kodem H
jne @F
jmp etykC
@@:
cmp AL, 068h ; por�wnanie z kodem h
jne @F
jmp etykC
@@:
INVOKE WriteConsoleOutputCharacterA,hout,OFFSET symb,1,COORD PTR [YX],OFFSET rout ; wypisywanie znaku
jmp powtC
etykC:
INVOKE FlushConsoleInputBuffer,hinp ;czyszczenie kolejki komunikat�w
INVOKE ReadConsoleInputA,hinp,OFFSET zapis,1,OFFSET nzdarz ; odczyt komunikatu zdarzenia
cmp WORD PTR [zapis.EventType], MOUSE_EVENT
je myszC
cmp WORD PTR [zapis.EventType], KEY_EVENT
je @F
jmp etykC
@@:
jmp klaw2C
klaw2C:
cmp (KEY_EVENT_RECORD PTR [zapis.KeyEvent]).bKeyDown, 0 ; por�wnanie z zerem
jne @F
jmp etykC ;je�li nie ma naci�ni�cia
@@:
mov AL,(KEY_EVENT_RECORD PTR [zapis.KeyEvent]).ASCIIChar
mov symb,AL
cmp AL, 049h ; por�wnanie z kodem I
jne @F
jmp konC
@@:
cmp AL, 069h ; por�wnanie z kodem i
jne @F
jmp konC
@@:
INVOKE WriteConsoleOutputCharacterA,hout,OFFSET symb,1,COORD PTR [YX],OFFSET rout ; wypisywanie znaku
jmp powtC
;--- zamkni�cie konsoli
konC:
INVOKE FreeConsole
jmp start
;--------------------------------|
; Koniec zadania C               |
;--------------------------------|
kon:
;--- zamkni�cie konsoli
INVOKE FreeConsole
;----- wywo�anie funkcji ExitProcess ---------
invoke ExitProcess,0
;podprogramy
;--------------------------------|
; czyszczenie ekranu             |
;--------------------------------|
Cls proc
mov bl,1
@@:
	cmp bl, 50h
	je @F
	wyswietl nl,2
	add bl, 1
	jmp @B
@@:
mov bl,0
ret
Cls endp
;---------------------------------|
; Rysowanie menu programu         |
;---------------------------------|
Menu proc
;--- rysuje menu programu ----
wyswietl rogGL, 1 	; wyswietlenie leweg rogu tabelki
drukujZnak prosta, 118 ; wyswietla przyjety znak 118 razy
wyswietl rogGP, 1 	; wy�wietlanie prawego rogu tabelki 
nowalinia nl, 2 	; makro	
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 45
plznaki szkola1, szkola1
wyswietl offset szkola1, sz1
drukujZnak spacja, 45
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 49
plznaki szkola2, szkola2
wyswietl offset szkola2, sz2
drukujZnak spacja, 49
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2 
wyswietl pion,1
drukujZnak spacja, 39
plznaki szkola3, szkola3
wyswietl offset szkola3, sz3
drukujZnak spacja, 38
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 46
plznaki szkola4, szkola4
wyswietl offset szkola4, sz4
drukujZnak spacja, 46
wyswietl pion,1
nowalinia nl, 2 
wyswietl pion,1
drukujZnak spacja, 54
plznaki szkola5, szkola5
wyswietl offset szkola5, sz5
drukujZnak spacja, 53
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 34
plznaki szkola6, szkola6
wyswietl offset szkola6, sz6
drukujZnak spacja, 33
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1	; wy�wietlenie pionowej linii
drukujZnak spacja, 48 ; wyswietla przyjety znak 118 razy
wyswietl offset menuTekst, menuR	; tekst 
drukujZnak spacja,48
wyswietl pion,1		; wy�wietlenie pionowej linii 
nowalinia nl, 2 	; makro
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1	
drukujZnak spacja, 43 ;	; wy�wietlenie pionowej linii
plznaki  zadanieA, zadanieA	; konwersja polskich znak�w
wyswietl offset zadanieA, rozmA	; tekst
drukujZnak spacja, 43 
wyswietl pion,1		; wy�wietlenie pionowej linii
nowalinia nl, 2 	; makro
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1		; wy�wietlenie pionowej linii
drukujZnak spacja, 43 
plznaki  zadanieB, buf	; konwersja polskich znak�w
wyswietl offset buf, rozmB ; tekst
drukujZnak spacja, 43 
wyswietl pion,1		; wy�wietlenie pionowej linii
nowalinia nl, 2 	; makro
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2 ; makro
wyswietl pion,1		; wy�wietlenie pionowej linii
drukujZnak spacja, 43 
plznaki zadanieC, buf	; konwersja polskich znak�w
wyswietl offset buf, rozmC ; tekst
drukujZnak spacja, 43 
wyswietl pion,1		; wy�wietlenie pionowej linii
nowalinia nl, 2 	; makro
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1	
drukujZnak spacja, 38 ;	; wy�wietlenie pionowej linii
plznaki zakonczenie, zakonczenie	; konwersja polskich znak�w
wyswietl offset zakonczenie, zakR	; tekst
drukujZnak spacja, 37 
wyswietl pion,1		; wy�wietlenie pionowej linii
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1	
drukujZnak spacja, 49 ;	; wy�wietlenie pionowej linii
plznaki wybrany, wybrany	; konwersja polskich znak�w
wyswietl offset wybrany, wybrR	; tekst
drukujZnak spacja, 47 
wyswietl pion,1		; wy�wietlenie pionowej linii
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1
drukujZnak spacja, 118 ; wyswietla przyjety znak 118 razy
wyswietl pion,1
nowalinia nl, 2
wyswietl pion,1	
drukujZnak spacja, 45 ;	; wy�wietlenie pionowej linii
plznaki student, student	; konwersja polskich znak�w
wyswietl offset student, stuR	; tekst
drukujZnak spacja, 43 
wyswietl pion,1
nowalinia nl, 2
wyswietl pionL,1
drukujZnak prosta, 118 ; wyswietla przyjety znak 118 razy
wyswietl pionP,1
nowalinia nl, 2
wyswietl pion,1	
drukujZnak spacja, 34 ;	; wy�wietlenie pionowej linii
plznaki profesor, profesor	; konwersja polskich znak�w
wyswietl offset profesor, proR	; tekst
drukujZnak spacja, 33 
wyswietl pion,1
nowalinia nl, 2
wyswietl rogDL,1	; wyswietlenie leweg dolnego rogu tabelki
drukujZnak prosta, 118 ; wyswietla przyjety znak 118 razy
wyswietl rogDP,1	; wyswietlenie prawego dolnego rogu tabelki
nowalinia nl,2
ret					; powr�t do miejsca wywo�ania podprogramu
Menu endp
_text ends
end start
;----------------------------------------|
;    Koniec segmentu kodu                |
;----------------------------------------|
