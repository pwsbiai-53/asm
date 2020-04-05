;Przesuwanie i rotacja bitów
.586P
.MODEL flat, STDCALL
option casemap :none
;--- stale z pliku .\include\windows.inc ---
STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11
;--- funkcje API Win32 z pliku .\include\user32.inc ---
CharToOemA PROTO :DWORD,:DWORD
;--- funkcje API Win32 z pliku .\include\kernel32.inc ---
GetStdHandle PROTO :DWORD
ReadConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExitProcess PROTO :DWORD
wsprintfA PROTO C :VARARG
lstrlenA PROTO :DWORD
;--- podprogramy ----
ScanInt PROTO C adres:DWORD
ScanBin PROTO STDCALL adres:DWORD
DrukBin PROTO STDCALL liczba:DWORD
DrukShortBin PROTO STDCALL liczba:DWORD
;--- funkcje
;-------------
includelib .\lib\user32.lib
includelib .\lib\kernel32.lib
;-------------
_DATA SEGMENT
hout DD ?
hinp DD ?
naglow DB "Autor aplikacji Grzegorz Makowski.",0Dh,0Ah,0
rozmN DD $ - naglow
newline DB 0Dh,0Ah,0
ALIGN 4
naglrot DB 0Dh,0Ah,"Liczba binarna przed rotacja: ",0
poarot DB 0Dh,0Ah,"Cyklicznie przez znacznik CF 4 w prawo razy: ",0
ponrot DB 0Dh,0Ah,"W lewo 2 razy: ",0
align 4
rout DD 0 ;faktyczna ilosc wyprowadzonych znaków
rinp DD 0 ;faktyczna ilosc wprowadzonych znaków
rinp2 DD 0 ;faktyczna ilosc wprowadzonych znaków
bufor DB 128 dup(?)
rbuf DD 128
zmY DD 0
st0 DD 10100110001110000111100000111110b

tekstZakoncz DB "Dziêkujê za uwagê! PWSBiA@2020",0                  ; nag³ówek
rozmZ DD $ - tekstZakoncz
_DATA ENDS
;------------
_DATA? SEGMENT
rbin dd ? ;ilosc znaków liczby binarnej
rrot dd ? ;ilosc znaków poszczególnych naglównków przy rotacji
_DATA? ENDS
_TEXT SEGMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
;--- wywolanie funkcji GetStdHandle
push STD_OUTPUT_HANDLE
call GetStdHandle ; wywolanie funkcji GetStdHandle
mov hout, EAX ; deskryptor wyjsciowego bufora konsoli
push STD_INPUT_HANDLE
call GetStdHandle ; wywolanie funkcji GetStdHandle
mov hinp, EAX ; deskryptor wejsciowego bufora konsoli
;--- naglówek ---------
push OFFSET naglow
push OFFSET naglow
call CharToOemA ; konwersja polskich znaków
;--- wyswietlenie ---------
push 0 ; rezerwa, musi byc zero
push OFFSET rout ; wskaznik na faktyczna ilosc wyprowadzonych znaków
push rozmN ; ilosc znaków
push OFFSET naglow ; wskaznik na tekst
push hout ; deskryptor buforu konsoli
call WriteConsoleA ; wywolanie funkcji WriteConsoleA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
invoke CharToOemA, offset naglrot, offset bufor ; konwersja polskich znaków
; liczymy dlugosc stringu do wyswietlenia
invoke lstrlenA, offset bufor
mov rrot, eax
; wyswietlamy powitanie
invoke WriteConsoleA, hout, offset bufor, rrot, offset rout, 0
; i wyswietlamy nasz ciag binarny
invoke DrukBin, st0
invoke CharToOemA, offset poarot, offset bufor ; konwersja polskich znaków
; liczymy dlugosc stringu do wyswietlenia
invoke lstrlenA, offset bufor
mov rrot, eax
; wyswietlamy powiadomienia o rotacji
invoke WriteConsoleA, hout, offset bufor, rrot, offset rout, 0
mov eax, st0 ; kopiujemy nasz ciag bitów do akumulatora
rcr eax, 4 ; przesuwamy go w prawo o 4 pozycje
mov st0, eax ; i kopiujemy spowrotem do zmiennej st0 i wyswietlamy ciag binarny
invoke DrukBin, st0
invoke CharToOemA, offset ponrot, offset bufor ; konwersja polskich znaków
; liczymy dlugosc stringu do wyswietlenia
invoke lstrlenA, offset bufor
mov rrot, eax
; wyswietlamy powiadomienia o rotacji
invoke WriteConsoleA, hout, offset bufor, rrot, offset rout, 0
mov eax, st0 ; kopiujemy nasz ciag bitów do akumulatora
rol eax, 2 ; przesuwamy go w lewo o 2 pozycje
mov st0, eax ; i kopiujemy spowrotem do zmiennej st0
; i wyswietlamy nasz ciag binarny
invoke DrukBin, st0
;--- wyœwietlenie now¹ linii ---
push	0		      	; rezerwa, musi byæ zero
push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
push	2		      	; iloœæ znaków
push	OFFSET newline 	; wska¿nik na tekst
push	hout		    ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
;--- wyœwietlenie zakonczenia ---
push 0                  ; rezerwa, musi byæ zero
push OFFSET rout        ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmZ  
push OFFSET tekstZakoncz
push OFFSET tekstZakoncz
call CharToOemA
push 0                          ; rezerwa, musi byæ zero
push OFFSET rout                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmZ                      ; iloœæ znaków
push OFFSET tekstZakoncz        ; wska¿nik na tekst
push hout                       ; deskryptor buforu konsoli
call WriteConsoleA              ; wywo³anie funkcji WriteConsole
;--- zakonczenie procesu ---------
push 0
call ExitProcess ; wywolanie funkcji ExitProcess
ScanInt PROC C adres
;; funkcja ScanInt przeksztalca ciag cyfr do liczby, która jest zwracana przez EAX
;; argument - zakonczony zerem wiersz z cyframi
;; rejestry: EBX - adres wiersza, EDX - znak liczby, ESI - indeks cyfry w wierszu, EDI - tymcza-sowy
;--- poczatek funkcji
;--- odkladanie na stos
push EBX
push ECX
push EDX
push ESI
push EDI
;--- przygotowywanie cyklu
INVOKE lstrlenA, adres
mov EDI, EAX ;ilosc znaków
mov ECX, EAX ;ilosc powtórzen = ilosc znaków
xor ESI, ESI ; wyzerowanie ESI
xor EDX, EDX ; wyzerowanie EDX
xor EAX, EAX ; wyzerowanie EAX
mov EBX, adres
;--- cykl --------------------------
pocz: cmp BYTE PTR [EBX+ESI], 02Dh ;porównanie z kodem '-'
jne @F
mov EDX, 1
jmp nast
@@: cmp BYTE PTR [EBX+ESI], 030h ;porównanie z kodem '0'
jae @F
jmp nast
@@: cmp BYTE PTR [EBX+ESI], 039h ;porównanie z kodem '9'
jbe @F
jmp nast
;----
@@: push EDX ; do EDX procesor moze zapisac wynik mnozenia
mov EDI, 10
mul EDI ;mnozenie EAX * EDI
mov EDI, EAX ; tymczasowo z EAX do EDI
xor EAX, EAX ;zerowani EAX
mov AL, BYTE PTR [EBX+ESI]
sub AL, 030h ; korekta: cyfra = kod znaku - kod '0'
add EAX, EDI ; dodanie cyfry
pop EDX
nast: inc ESI
dec ECX
jz @F
jmp pocz
;--- wynik
@@: or EDX, EDX ;analiza znacznika EDX
jz @F
neg EAX
@@:
;--- zdejmowanie ze stosu
pop EDI
pop ESI
pop EDX
pop ECX
pop EBX
;--- powrót
ret
ScanInt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ScanBin PROC STDCALL adres:DWORD
;; funkcja ScanBin przeksztalca ciag cyfr do liczby, która jest zwracana przez EAX
;; argument - zakonczony zerem wiersz z cyframi binarnymi '0' badz '1'
;; rejestry: EBX - adres wiersza, ESI - indeks cyfry w wierszu, EDI - tymczasowy
;--- poczatek funkcji
;--- odkladanie na stos
push ebx
push ecx
push edx ; podczas mnozenia moze sie zdazyc ze EDX zostanie zmodyfikowane
push esi
push edi
;--- przygotowanie cyklu
invoke lstrlenA, adres
mov ecx, eax ; ilosc powtórzen = ilosc znaków
mov ebx, adres ; do rejetru EBX przenosimy adres ciagu cyfr
xor esi, esi ; zerujemy numer kolejnych cyfr w tablicy
xor edi, edi ; zerujemy rejestr tymczasowy
xor eax, eax ; zerujemy akumulator
;--- cykl --------------------
pocz:
cmp byte ptr[ebx + esi], '0' ; porównujemy znak z bufora z znakiem '0'
jae @F ; jesli jest wiekszy badz równy to dobrze, przechodzimy do kolejnej etykiety.
jmp nast ; jesli jest mniejszy to oznacza iz jest to niepoprawny znak,
; przechodzimy do nastepnego znaku.
@@:
cmp byte ptr[ebx + esi], '1' ; porównujemy znak z bufora z kodem znaku '1'
jbe @F ; jesli jest mniejszy badz równy to dobrze i przechodzimy do kolejnej etykiety
jmp nast ; jesli jest wiekszy to jest to niepoprawny znak i przechodzimy do nastep-nego zna-ku.
@@:
mov edi, 2 ; do rejestru edi wstawiamy 2
mul edi ; przy kazdym przejsciu petli mnozymy eax przez 2 aby przesunac poprzedni wynik w lewo
mov edi, eax ; czasowo nasza cyfre przenosimy do rejestru edi
xor eax, eax ; i zerujemy akumulator
mov al, byte ptr[ebx + esi] ; do akumulatora przenosimy bajt naszego znaku '0' badz '1'
sub al, '0' ; odejmujemy kod znaku '0' aby uzyskac cyfre 1 badz 0
add eax, edi ; i dodajemy to do zapisanej liczby
nast: ; przechodzenie do nastepnej pozycji polega na:
inc esi ; zwiekszeniu indeksu cyfry aby przejsc na kolejny znak
dec ecx ; zmniejszeniu kiczby znaków do przejscia o 1
jz @F ; jesli ilosc znaków do przejscia wynosi 0 to przechodzimy do kolejnej etykiety
jmp pocz ; jesli jeszcze mamy znaki do przejscia to zaczynamy wykonywac od po-czatku wszystko,
; tylko tym razem na kolejnym znaku
@@:
;--- zdejmowanie ze stosu
pop edi
pop esi
pop edx
pop ecx
pop ebx
;--- powrót
ret 4 ; poniewaz funkcja uzywa konwencji STDCALL wiec sprzatamy po sobie na stosie
; odejmujac od esp 4
ScanBin ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrukBin PROC STDCALL liczba:DWORD
;; funkcja DrukBin wyswietla liczbe-argument w postaci binarnej
;; rejestry: ECX - cykl, EDI - maska, ESI - indeks w buforze, EBX - przesuniecie bufo-ra
;--- odkladanie na stos
push ECX
push EDI
push ESI
push EBX
;---
mov ECX,32
mov EDI,80000000h
mov ESI,0
mov EBX,OFFSET bufor
@@d1:
mov BYTE PTR [EBX+ESI],'0'
test liczba,EDI
jz @@d2
inc BYTE PTR [EBX+ESI]
@@d2:
shr EDI,1
inc ESI
loopnz @@d1
mov BYTE PTR [EBX+32],0Dh
mov BYTE PTR [EBX+33],0Ah
;--- wyswietlenie wynika ---------
push 0 ; rezerwa, musi byc zero
push OFFSET rout ; wskaznik na faktyczna ilosc wyprowadzonych znaków
push 34 ; ilosc znaków
push OFFSET bufor ; wskaznik na tekst w buforze
push hout ; deskryptor buforu konsoli
call WriteConsoleA ; wywolanie funkcji WriteConsoleA
;--- zdejmowanie ze stosu
pop EBX
pop ESI
pop EDI
pop ECX
;--- powrót
ret 4
DrukBin ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrukShortBin PROC STDCALL liczba:DWORD
;; funkcja DrukShortBin wysfietla liczbe-argument w postaci binarnej,
;; pomijamy nieznaczace zera na poczatku
;; rejestr ecx - liczba pozycji znaczacych, rejestr ebx - wskaznik na bufor,
;; esi - indeks w buforze, eax - liczba, edx - reszta z dzielenia(czyli nasze '1' i '0')
;; edi - liczbe do dzielenia
;; funkcja wykorzystuje najprostrzy algorytm zamiany liczby na postac dwujkowa
;; czyli dzielimy liczbe przez 2 i reszte zapisujemy na stosie
;; i tak do momentu kiedy liczba bedzie równa 0, wtedy odczytujemy liczbe binarna
;; w odwrotnej koljnosci do zapisywania na stosie
;--- odkladanie na stos
push ebx
push ecx
push edx
push esi
push edi
;--- przygotowywanie rejestrów ---
mov ebx, offset bufor ; do ebx kopiujemy adres bufora,
;do którego bedziemy wstawiac kolejne cyfry liczby binarnej
xor esi, esi ; zerujemy indeks liter w buforze
mov eax, liczba ; do akumulatora kopiujemy nasza liczbe
xor edx, edx ; zerujemy edx
xor ecx, ecx ; zerujemy licznik znaków
mov edi, 2 ; do edi wstawiamy 2
;--- cykl dzielenia i wkladania na stos ---
pocz:
xor edx, edx ; zerujemy edx poniewaz instrukcja div uzywa rejestrów EDX:EAX
div edi ; dzielimy nasza liczbe przez 2
add edx, '0' ; dodajemy do niej kod znaku zero aby zamienic ja na znak
push edx ; i wstawiamy ja na stos
inc ecx ; zwiekszamy licznik cyfr na stosie
or eax, eax ; wykonyjeme instrukcje or aby ustawic flage ZF jesli eax równa sie zero
jz @F ; jesli eax równa sie zero to przechodzimy do kolejne etykiety
jmp pocz ; a jesli jest jeszcze co dzielic to skaczemy na poczatek
;--- tworzenie stringu(napisu)
; polega na pobraniu ze stosu w odwrotnej kolejnosci niz wstawialismy naszyc zna-ków
@@:
pop eax ; pobieramy nasz znak i umieszczamy go w akumulatorze
mov byte ptr [ebx + esi], al ; nastepnie bit znaku umieszczamy w buforze
inc esi ; przesówamy pozycje do wstawiania na kolejna w buforze
dec ecx ; i zmniejszamu ilosc liczb do wstawienia
jz @F ; jesli nie ma juz wiecej cyfr to przechodzimy dalen
jmp @B ; lecz jesli sa to przechodzimy do pobierania kolejnego znaku ze stosu
;--- nak koniec dodajemy 0Dh, 0Ah oraz 0 ---
@@:
mov byte ptr[ebx + esi], 0Dh ; dodajemy jeszcze na koniec znak noweh lini
mov byte ptr[ebx + esi + 1], 0Ah ; oraz znak powrotu karetki
mov byte ptr[ebx + esi + 2], 0 ; no i na koniec zakanczamy nasz ciag zerem
;--- wyswietlamy
invoke lstrlenA, offset bufor ; liczymy dlugosc naszego napisu
mov rbin, eax ; kopiujemy go do rbin
invoke WriteConsoleA, hout, offset bufor, rbin, offset rout, 0
; i wyswietlamy go
;--- zdejmowanie ze stosu
pop edi
pop esi
pop edx
pop ecx
pop ebx
ret 4
DrukShortBin ENDP
_TEXT ENDS
END start