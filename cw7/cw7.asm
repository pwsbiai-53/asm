;-------------------------------------------|
;				  cw7.asm                   |
;      Operacje na plikach i katalogach.    |
;                                           |
;	               Autor: Grzegorz Makowski |
;                  MASM ver: 6.14.8444      |
;                  ost. akt. 29.04.2020     |
;-------------------------------------------|
.586p
.model flat, stdcall
;-------------------------------------------|
;     wczytanie plikow zewnetrznych         |
;-------------------------------------------| 
;-------------------------------------------|
;    wczytanie wlasnych makr z pliku        |
;-------------------------------------------|
include mojemakra.mac	; Makra
include cw7.mac			; Makra dedykowane do zad 7
;-------------------------------------------|
;      bilioteki systemowe i masm           |
;-------------------------------------------|
includelib .\lib\user32.lib
includelib .\lib\kernel32.lib
includelib .\lib\masm32.lib
;-------------------------------------------|
;    stale z pliku .\include\windows.inc    |
;-------------------------------------------|
STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11
;-------------------------------------------|
;			stale do obslugi plikow	        |
;-------------------------------------------|
GENERIC_READ equ 80000000h
GENERIC_WRITE equ 40000000h
CREATE_NEW equ 1
CREATE_ALWAYS equ 2
OPEN_EXISTING equ 3
OPEN_ALWAYS equ 4
TRUNCATE_EXISTING equ 5
FILE_FLAG_WRITE_THROUGH equ 80000000h
FILE_FLAG_OVERLAPPED equ 40000000h
FILE_FLAG_NO_BUFFERING equ 20000000h
FILE_FLAG_RANDOM_ACCESS equ 10000000h
FILE_FLAG_SEQUENTIAL_SCAN equ 8000000h
FILE_FLAG_DELETE_ON_CLOSE equ 4000000h
FILE_FLAG_BACKUP_SEMANTICS equ 2000000h
FILE_FLAG_POSIX_SEMANTICS equ 1000000h
FILE_ATTRIBUTE_READONLY equ 1h
FILE_ATTRIBUTE_HIddEN equ 2h
FILE_ATTRIBUTE_SYSTEM equ 4h
FILE_ATTRIBUTE_DIRECTORY equ 10h
FILE_ATTRIBUTE_ARCHIVE equ 20h
FILE_ATTRIBUTE_NORMAL equ 80h
FILE_ATTRIBUTE_TEMPORARY equ 100h
FILE_ATTRIBUTE_COMPRESSED equ 800h
FORMAT_MESSAGE_ALLOCATE_BUFFER equ 100h
FORMAT_MESSAGE_IGNORE_INSERTS equ 200h
FORMAT_MESSAGE_FROM_STRING equ 400h
FORMAT_MESSAGE_FROM_HMODULE equ 800h
FORMAT_MESSAGE_FROM_SYSTEM equ 1000h
FORMAT_MESSAGE_ARGUMENT_ARRAY equ 2000h
FORMAT_MESSAGE_MAX_WIDTH_MASK equ 0FFh
;--------------------------------|
;            stale               |
;--------------------------------|
mbuf = 512
;--- funkcje API Win32 z pliku .\include\user32.inc ---
CharToOemA proto :dword,:dword
;--- z pliku .\include\kernel32.inc ---
GetStdHandle proto :dword
ReadConsoleA proto :dword,:dword,:dword,:dword,:dword
WriteConsoleA proto :dword,:dword,:dword,:dword,:dword
ExitProcess proto :dword
wsprintfA proto c :vararg
;; int wsprintf(LPTSTR lpOut,// pointer to buffer for output
;; LPCTSTR lpFmt,// pointer to format-control string
;; ... // optional arguments );
lstrlenA proto :dword
GetCurrentDirectoryA proto :dword,:dword
;;nBufferLength, lpBuffer; zwraca length
CreateDirectoryA proto :dword,:dword
;;lpPathName, lpSecurityAttributes; zwraca 0 jeœli b³ad
lstrcatA proto :dword,:dword
;; lpString1, lpString2; zwraca lpString1
CreateFileA proto :dword,:dword,:dword,:dword,:dword,:dword,:dword
;; LPCTSTR lpszName, DWORD fdwAccess,
;; DWORD fdwShareMode, LPSECURITY_ATTRIBUTES lpsa, DWORD fdwCreate,
;; DWORD fdwAttrsAndFlags, HANDLE hTemplateFile
lstrcpyA proto :dword,:dword
;;LPTSTR lpString1 // address of buffer, LPCTSTR lpString2 // address of string to copy
CloseHandle proto :dword
;; BOOL CloseHandle(HANDLE hObject)
WriteFile proto :dword,:dword,:dword,:dword,:dword
;; BOOL WriteFile(
;; HANDLE hFile, // handle to file to write to
;; LPCVOID lpBuffer, // pointer to data to write to file
;; DWORD nNumberOfBytesToWrite, // number of bytes to write
;; LPDWORD lpNumberOfBytesWritten, // pointer to number of bytes written
;; LPOVERLAPPED lpOverlapped // pointer to structure needed for overlapped I/O
;;);
ReadFile proto :dword,:dword,:dword,:dword,:dword
;;BOOL ReadFile(
;;HANDLE hFile, // handle of file to read
;;LPVOID lpBuffer, // address of buffer that receives data
;;DWORD nNumberOfBytesToRead, // number of bytes to read
;;LPDWORD lpNumberOfBytesRead, // address of number of bytes read
;;LPOVERLAPPED lpOverlapped // address of structure for data
;;);
CopyFileA proto :dword,:dword,:dword
;; BOOL CopyFile(
;;LPCTSTR lpExistingFileName, // pointer to name of an existing file
;;LPCTSTR lpNewFileName, // pointer to filename to copy to
;;BOOL bFailIfExists // flag for operation if file exists
;;);
GetLastError proto
;--- z pliku .\include\masm32.inc ---
nrandom proto :dword
;--- funkcje
ScanInt proto C adres:dword

;----------------------------------------|
;    Poczatek segmentu danych            |
;----------------------------------------|
_data segment
hout dd 0
nl db 0Dh, 0Ah, 0	; nowa linia
nl2	db 0Dh,0Ah,20h,0 ; nowa inne formatowanie
nxt db 13,10,0 ; nastepny wiersz
naglow db "Autor aplikacji Grzegorz Makowski i53",0
align 4 ; przesuniecie do adresu podzielnego na 4
rozmN dd $ - naglow ;iloœæ znaków w tablicy
zadanieA db "Zadanie a",0
align 4
rozmA dd $ - zadanieA ; ilosc znakow tekstu zadanieA
opisKatZadA db "Œciezki do katalogu DANE i pliku test.txt.",0
align 4
rozmkatzada dd $ - opisKatZadA ; ilosc znakow w opisie zadania a
align 4
opisKatZadA2 db "Wyœwietlenie losowej zawrtoœci pliku test",0
align 4
rozmkatzada2 dd $ - opisKatZadA2 ; ilosc znakow w opisie zadania a
zadanieB db "Zadanie b",0
align 4
rozmB dd $ - zadanieB ; ilosc znakow tekstu zadanieB
align 4
opisKatZadB db "Œciezki do plików: plik1.txt i plik2.txt",0
align 4
rozmkatzadB dd $ - opisKatZadB ; ilosc znakow w opisie zadania a
align 4
rout dd 0
sciezka db mbuf dup(?)
nazwaDANE db "\DANE",0
nazwa db "\test.txt",0
nazwa1 db "\plik1.txt",0
nazwa2 db "\plik2.txt",0
nazwat1 db 13,10,"Dane z plik1.txt - co 8 nieparzysta:",13,10,0
nazwat2 db 13,10,"Dane z plik2.txt - co 8 parzysta:",13,10,0
tesTxt db mbuf dup(?)	; bufor na sciezke dla pliku test.txt
tesTxt1 db mbuf dup(?)	; bufor na sciezke dla pliku test1.txt
tesTxt2 db mbuf dup(?)	; bufor na sciezke dla pliku test2.txt
katDane db mbuf dup(?)	; bufor katalogu
hfile dd 0				; uchwyt do pliku test
hfile1 dd 0				; uchwyt do pliku test1
hfile2 dd 0				; uchwyt do pliku test2
tab dd 100 dup(0)
nbytes dd 0
liczba dd 0
licznik1 dd 0
licznik2 dd 0
bufor db mbuf dup(0)
leng dd 0
buf db mbuf dup(0)		; bufor pomocniczy
buff db mbuf dup(0)		; bufor pomocniczy
format1 db " %3ld",13,10,0
format2 db " %3ld",0
rsymb dd 0
_data ends
;----------------------------------------|
;    Koniec segmentu danych              |
;----------------------------------------|

;----------------------------------------|
;    Poczatek segmentu kodu              |
;----------------------------------------|
_text segment
start:
;--- nag³ówek ---------
Naglowek ; Makro
;---
zadA ; Makro
nowalinia nl, 2		; MAKRO
invoke GetCurrentDirectoryA, mbuf, offset sciezka ; pobranie pe³nej œcie¿ki
invoke lstrcpyA, offset katDane, offset sciezka ; ³aczenie stringow
invoke lstrcatA, offset katDane, offset nazwaDANE
invoke lstrlenA, offset katDane
mov leng, eax
wyswietl offset katDane, leng ; wyswietlenie pe³nego katalogu DANE - MAKRO
;--- nowa linia
nowalinia nl, 2		; nowa linia - MAKRO
;---
invoke CreateDirectoryA, offset katDane , 0 ; utworzenie katalogu
invoke lstrcpyA, offset tesTxt, offset katDane
invoke lstrcatA, offset tesTxt, offset nazwa
invoke lstrlenA, offset tesTxt
mov leng, eax
wyswietl offset tesTxt, leng ; MAKRO - wyswietlenie sciezki do pliku test.txt
;-- nowa linia
nowalinia nl, 2		; nowa linia - MAKRO
invoke CreateFileA, offset tesTxt,GENERIC_WRITE , 0, 0, CREATE_ALWAYS, 0, 0 ; tworzenie pliku
mov hfile, eax
;---
invoke CloseHandle, hfile ; zamkniecie pliku test
;--- liczby pseudolosowe -> tablica
lea ebx, tab
mov edi, 0
mov ecx, 100
losowe:
push ecx
push ebx
;;;
invoke nrandom, 200
sub eax, 99
;;;
pop ebx
mov dword ptr [ebx], eax
add ebx, 4
pop ecx
loop losowe
;------------------------------|
;       plik "test.txt"        |
;------------------------------|
;--- nowa linia
nowalinia nxt,2     ; nowa linia
invoke CreateFileA, offset tesTxt,GENERIC_READ OR GENERIC_WRITE , 0, 0, OPEN_EXISTING, 0, 0 ; tworzenie pliku
mov hfile, eax
;-- z tablicy do pliku ----
lea ebx, tab
mov ecx, 100
powt:
push ecx
push ebx
invoke wsprintfA,offset buf,offset format1,DWORD PTR [ebx]
mov rsymb,eax
invoke WriteFile, hfile, offset buf ,rsymb , offset nbytes, 0
pop ebx
add ebx, 4
pop ecx
loop powt
;;;
invoke CloseHandle, hfile
;-- pobranie z tablicy na ekran po 10 liczb na wierszu ----
lea ebx, tab
mov ecx, 100
mov licznik1,0
powtE:
push ecx ;;
push ebx
;;;
mov eax,licznik1
or eax,eax
jnz @F
;--- new line ---------
nowalinia nl, 2		;   MAKRO
@@:
inc licznik1
cmp licznik1,10
jb @F
mov licznik1,0
@@:
pop ebx
push ebx
invoke wsprintfA,offset buf,offset format2,DWORD PTR [ebx]
mov rsymb,eax
invoke WriteConsoleA, hout, offset buf ,rsymb , offset nbytes, 0
;;;
pop ebx
add ebx, 4
pop ecx
loop powtE
;--- new line ---------
nowalinia nl, 2		;   MAKRO
;--- new line ---------
nowalinia nl, 2		;   MAKRO
;------------------------------|
;  Operacje na plikach         |
;------------------------------|
zadB ; Makro
invoke CreateFileA, offset tesTxt,GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0 ; plik test.txt
mov hfile, eax
invoke lstrcpyA, offset tesTxt1, offset katDane
invoke lstrcatA, offset tesTxt1, offset nazwa1
invoke lstrlenA, offset tesTxt1
mov leng, eax
wyswietl offset tesTxt1, leng ; wyswietlenie 
nowalinia nxt,2     ; nowa linia
invoke CreateFileA, offset tesTxt1,GENERIC_WRITE , 0, 0, CREATE_ALWAYS, 0, 0 ; stworzenie pliku
mov hfile1, eax
invoke lstrcpyA, offset tesTxt2, offset katDane
invoke lstrcatA, offset tesTxt2, offset nazwa2
invoke lstrlenA, offset tesTxt2
mov leng, eax
wyswietl offset tesTxt2, leng
nowalinia nxt,2     ; nowa linia
invoke CreateFileA, offset tesTxt2,GENERIC_WRITE , 0, 0, CREATE_ALWAYS, 0, 0 ; stworzenie pliku
mov hfile2, eax
;---------
mov ecx, 100
mov licznik1,8 ;co osma parzysta
mov licznik2,8 ;co osma nieparzysta
powt2:
push ecx
invoke ReadFile, hfile, offset buf ,6 , offset nbytes, 0 ;;
cmp nbytes,0
jnz @F
jmp zamyk
@@:
invoke ScanInt,offset buf ; tekst ASCII -> liczba
mov liczba,eax
mov eax,liczba
test eax,1h
jz parz
;-- nieparzysta
dec licznik2
cmp licznik2,0
je @F
jmp dalej
@@:
mov licznik2,8
invoke wsprintfA,offset buf,offset format1,liczba
mov rsymb,eax
invoke WriteFile, hfile1, offset buf ,rsymb , offset nbytes, 0
jmp dalej
parz:
;-- parzysta
dec licznik1
cmp licznik1,0
je @F
jmp dalej
@@:
mov licznik1,8
invoke wsprintfA,offset buf,offset format1,liczba
mov rsymb,eax
invoke WriteFile, hfile2, offset buf ,rsymb , offset nbytes, 0
jmp dalej
dalej:
pop ecx
loop @F
jmp zamyk
@@:
jmp powt2
zamyk:
invoke CloseHandle, hfile
invoke CloseHandle, hfile1
invoke CloseHandle, hfile2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
invoke lstrlenA, offset nazwat1
mov leng, eax
invoke WriteConsoleA, hout, offset nazwat1, leng , offset rout , 0
;------------------------------|
;       plik "test1.txt"       |
;------------------------------|
invoke CreateFileA, offset tesTxt1,GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0 ; plik test1.txt
mov hfile1, eax
mov licznik1,0
powtE1:
invoke ReadFile, hfile1, offset buf ,6 , offset nbytes, 0 ;;
cmp nbytes,0
jnz @F
jmp zamyk1
@@:
cmp licznik1,0
jnz @F
;--- new line ---------
nowalinia nl, 2		;   MAKRO
@@:
inc licznik1
cmp licznik1,10
jb @F
mov licznik1,0
@@:
invoke WriteConsoleA, hout, offset buf ,4, offset nbytes, 0
jmp powtE1
zamyk1:
invoke CloseHandle, hfile1
;--- new line ---------
nowalinia nl, 2		;   MAKRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
invoke lstrlenA, offset nazwat2
mov leng, eax
invoke WriteConsoleA, hout, offset nazwat2, leng , offset rout , 0
;------------------------------|
;       plik "test2.txt"       |
;------------------------------|
invoke CreateFileA, offset tesTxt2,GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0 ; plik test2.txt
mov hfile1, eax
mov licznik1,0
powtE2:
invoke ReadFile, hfile2, offset buf ,6 , offset nbytes, 0 ;;
cmp nbytes,0
jnz @F
jmp zamyk2
@@:
cmp licznik1,0
jnz @F
;--- new line ---------
nowalinia nl, 2		;   MAKRO
@@:
inc licznik1
cmp licznik1,10
jb @F
mov licznik1,0
@@:
invoke WriteConsoleA, hout, offset buf ,4, offset nbytes, 0
jmp powtE2
zamyk2:
invoke CloseHandle, hfile2
;--- new line ---------
nowalinia nl, 2		;   MAKRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kon:
;----- wywo³anie funkcji ExitProcess ---------
invoke ExitProcess,0
;==================================
;=== Podprogramy ==================
;==================================
ScanInt PROC C adres
;; funkcja ScanInt przekszta³ca ci¹g cyfr do liczby, któr¹ jest zwracana przez eax
;; argument - zakoñczony zerem wiersz z cyframi
;; rejestry: ebx - adres wiersza, EDX - znak liczby, ESI - indeks cyfry w wierszu, EDI - tymczasowy
;--- pocz¹tek funkcji
;--- odk³adanie na stos
push ebx
push ecx
push EDX
push ESI
push EDI
;--- przygotowywanie cyklu
invoke lstrlenA, adres
mov EDI, eax ;iloœæ znaków
mov ecx, eax ;iloœæ powtórzeñ = iloœæ znaków
xor ESI, ESI ; wyzerowanie ESI
xor EDX, EDX ; wyzerowanie EDX
xor eax, eax ; wyzerowanie eax
mov ebx, adres
;--- cykl --------------------------
pocz: cmp BYTE PTR [ebx+ESI], 02Dh ;porównanie z kodem '-'
jne @F
mov EDX, 1
jmp nast
@@: cmp BYTE PTR [ebx+ESI], 030h ;porównanie z kodem '0'
jae @F
jmp nast
@@: cmp BYTE PTR [ebx+ESI], 039h ;porównanie z kodem '9'
jbe @F
jmp nast
;----
@@: push EDX ; do EDX procesor mo¿e zapisaæ wynik mno¿enia
mov EDI, 10
mul EDI ;mno¿enie eax * EDI
mov EDI, eax ; tymczasowo z eax do EDI
xor eax, eax ;zerowani eax
mov AL, BYTE PTR [ebx+ESI]
sub AL, 030h ; korekta: cyfra = kod znaku - kod '0'
add eax, EDI ; dodanie cyfry
pop EDX
nast: inc ESI
dec ecx
jz @F
jmp pocz
;--- wynik
@@: or EDX, EDX ;analiza znacznika EDX
jz @F
neg eax
@@:
;--- zdejmowanie ze stosu
pop EDI
pop ESI
pop EDX
pop ecx
pop ebx
;--- powrót
ret
ScanInt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_text ends
end start
;----------------------------------------|
;    Koniec segmentu kodu                |
;----------------------------------------|
