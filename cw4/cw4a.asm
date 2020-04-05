;Aplikacja "Instrukcje arytmetyczne i logiczne. Przesuwanie i rotacja bit�w"
.586
.MODEL flat, STDCALL
;--- stale ---
;--- z pliku ..\include\windows.inc ---
STD_INPUT_HANDLE                     equ -10
STD_OUTPUT_HANDLE                    equ -11
;--- funkcje API Win32 ---
;--- z pliku  ..\include\user32.inc ---
CharToOemA PROTO :DWORD,:DWORD
;--- z pliku ..\include\kernel32.inc ---
GetStdHandle PROTO :DWORD
ReadConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExitProcess PROTO :DWORD
wsprintfA PROTO C :VARARG
lstrlenA PROTO :DWORD
;-------------
includelib .\lib\user32.lib
includelib .\lib\kernel32.lib
;-------------
_DATA SEGMENT
hout DD ?
hinp DD ?
naglow DB "Autor aplikacji Grzegorz Makowski i53",0                 ; nag��wek
wzor DB 0Dh,0Ah,"Instrukcje arytmetyczne i logiczne.",0                                       ; tekst formatuj�cy
ALIGN 4                                                             ; wyr�wnanie do granicy 4-bajtowej
rozmN DD $ - naglow                                                 ; ilosc znakow w tablocy
nowa DB 0Dh, 0Ah, 0
ALIGN 4                                                             ; przesuniece do adresu podzielonego na 4

zadA DB "Zadanie a) ",0                                             ; nag��wek zadania A
rozmzadA DD $ - zadA
naglowA DB 0Dh,0Ah, "Wprowad� 4 parametry do fun. f() = A/B-C+D",0  ; nag��wek
rozmnaglA DD $ - naglowA 

zaproszenieA DB 0Dh,0Ah,"Prosz� wprowadzi� argument A [+Enter]: ",0 ; Tekst zaproszenia do wprowadzenie amiennej A
rozmiarA DD $ - zaproszenieA
zmA DD 1                                                            ; argument A
  
zaproszenieB DB 0Dh,0Ah,"Prosz� wprowadzi� argument B [+Enter]: ",0 ; Tekst zaproszenia do wprowadzenie amiennej B
rozmiarB DD $ - zaproszenieB
zmB DD 1                                                            ; argument B
    
zaproszenieC DB 0Dh,0Ah,"Prosz� wprowadzi� argument C [+Enter]: ",0 ; Tekst zaproszenia do wprowadzenie amiennej C
rozmiarC DD $ - zaproszenieC
zmC DD 1                                                            ; argument C
    
zaproszenieD DB 0Dh,0Ah,"Prosz� wprowadzi� argument D [+Enter]: ",0 ; Tekst zaproszenia do wprowadzenie amiennej D
rozmiarD DD $ - zaproszenieD
zmD DD 1

wynik DB 0Dh,0Ah,"Wynik f() =  %ld",0
rout DD 0                                                           ; faktyczna ilo�� wyprowadzonych znak�w
rinp DD 0                                                           ; faktyczna ilo�� wprowadzonych znak�w
rbuf DD 128
bufor	DB    128 dup(?)
   
zadB DB "Zadanie b) ",0                                            ; nag��wek zadania B
rozmB DD $ - zadB                                            
tekstZakoncz DB "Dzi�kuj� za uwag�! PWSBIA@2020",0                  ; nag��wek
rozmZ DD $ - tekstZakoncz
_DATA ENDS
;------------
_TEXT SEGMENT
start:
;--- deskryptory konsoli 
push	STD_OUTPUT_HANDLE
call	GetStdHandle	; wywo�anie funkcji GetStdHandle
mov	hout, EAX	      ; deskryptor wyj�ciowego bufora konsoli
push	STD_INPUT_HANDLE
call	GetStdHandle	; wywo�anie funkcji GetStdHandle
mov	hinp, EAX	      ; deskryptor wej�ciowego bufora konsoli
;--- nag��wek ---------
push	OFFSET naglow
push	OFFSET naglow
call	CharToOemA	      ; konwersja polskich znak�w
;--- wy�wietlenie ---------
push	0		      ; rezerwa, musi by� zero
push	OFFSET rout	      ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	rozmN		      ; ilo�� znak�w
push	OFFSET naglow 	; wska�nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
;--- wy�wietlenie now� linii ---
push	0		      ; rezerwa, musi by� zero
push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	2		      ; ilo�� znak�w
push	OFFSET nowa 	; wska�nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
;--- opis funkcji programu ---------

push OFFSET zadA
push OFFSET ZadA
call CharToOemA               ; konwersja polskich znak�w
push 0                        ; rezerwa, musi by� zero
push OFFSET rout              ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmzadA                    ; ilo�� znak�w
push OFFSET ZadA              ; wska�nik na tekst
push hout                     ; deskryptor buforu konsoli
call WriteConsoleA 
;--- wy�wietlenie now� linii ---
push	0		      ; rezerwa, musi by� zero
push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	2		      ; ilo�� znak�w
push	OFFSET nowa 	; wska�nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
;--- Zaproszenie do zadania A ---------
push OFFSET naglowA
push OFFSET naglowA
call CharToOemA               ; konwersja polskich znak�w
push 0                        ; rezerwa, musi by� zero
push OFFSET rout              ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmnaglA                   ; ilo�� znak�w
push OFFSET naglowA            ; wska�nik na tekst
push hout                     ; deskryptor buforu konsoli
call WriteConsoleA 
;--- wy�wietlenie now� linii ---
push	0		      ; rezerwa, musi by� zero
push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	2		      ; ilo�� znak�w
push	OFFSET nowa 	; wska�nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
;--- wy�wietlenie now� linii ---
push	0		        ; rezerwa, musi by� zero
push	OFFSET rout         ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	2		        ; ilo�� znak�w
push	OFFSET nowa 	  ; wska�nik na tekst
push	hout		        ; deskryptor buforu konsoli
call	WriteConsoleA	  ; wywo�anie funkcji WriteConsoleA
;--- zaproszenie A ---------
push OFFSET zaproszenieA
push OFFSET zaproszenieA
call CharToOemA             ; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia A ---
push 0                      ; rezerwa, musi by� zero
push OFFSET rout            ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmiarA               ; ilo�� znak�w
push OFFSET zaproszenieA    ; wska�nik na tekst
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
push 0                      ; rezerwa, musi by� zero
push OFFSET rinp            ; wska�nik na faktyczn� ilo�� wprowadzonych znak�w
push rbuf                   ; rozmiar bufora
push OFFSET bufor           ;wska�nik na bufor
push hinp                   ; deskryptor buforu konsoli
call ReadConsoleA           ; wywo�anie funkcji ReadConsoleA
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0  ;zero na ko�cu tekstu
;--- przekszta�cenie A
push OFFSET bufor
call ScanInt
add ESP, 8
mov zmA, EAX
;;;........ B
;--- zaproszenie B---------
push OFFSET zaproszenieB
push OFFSET zaproszenieB
call CharToOemA             ; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia B ---
push 0                      ; rezerwa, musi by� zero
push OFFSET rout            ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmiarB               ; ilo�� znak�w
push OFFSET zaproszenieB    ; wska�nik na tekst
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
push 0                      ; rezerwa, musi by� zero
push OFFSET rinp            ; wska�nik na faktyczn� ilo�� wprowadzonych znak�w
push rbuf                   ; rozmiar bufora
push OFFSET bufor           ;wska�nik na bufor
push hinp                   ; deskryptor buforu konsoli
call ReadConsoleA           ; wywo�anie funkcji ReadConsoleA
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0 ;zero na ko�cu tekstu
;--- przekszta�cenie B
push OFFSET bufor
call ScanInt
add ESP, 8
mov zmB, EAX
;--- zaproszenie C ---------
push OFFSET zaproszenieC
push OFFSET zaproszenieC
call CharToOemA             ; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia C ---
push 0                      ; rezerwa, musi by� zero
push OFFSET rout            ; wska�nik na faktyczn� ilos� wyprowadzonych znak�w
push rozmiarC               ; ilo�� znak�w
push OFFSET zaproszenieC    ; wska�nik na tekst
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
push 0                      ; rezerwa, musi by� zero
push OFFSET rinp            ; wska�nik na faktyczn� ilo�� wprowadzonych znak�w
push rbuf                   ; rozmiar bufora
push OFFSET bufor           ; wska�nik na bufor
push hinp                   ; deskryptor buforu konsoli
call ReadConsoleA           ; wywo�anie funkcji ReadConsoleA
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0  ;zero na ko�cu tekstu
;--- przekszta�cenie C
push OFFSET bufor
call ScanInt
add ESP, 8
mov zmC, EAX
;--- zaproszenie D ---------
push OFFSET zaproszenieD
push OFFSET zaproszenieD
call CharToOemA             ; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia D ---
push 0                      ; rezerwa, musi by� zero
push OFFSET rout            ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmiarD               ; ilo�� znak�w
push OFFSET zaproszenieD    ; wska�nik na tekst
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
push 0                      ; rezerwa, musi by� zero
push OFFSET rinp            ; wska�nik na faktyczn� ilo�� wprowadzonych znak�w
push rbuf                   ; rozmiar bufora
push OFFSET bufor           ;wska�nik na bufor
push hinp                   ; deskryptor buforu konsoli
call ReadConsoleA           ; wywo�anie funkcji ReadConsoleA
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0  ;zero na ko�cu tekstu
;--- przekszta�cenie D
push OFFSET bufor
call ScanInt
add ESP, 8
mov zmD, EAX
;--- obliczenia A / B - C + D
mov EDX, 0			; zerowanie EDX
mov EAX, 0          ; zerowanie EAX
mov EAX, zmA        ; zm A do EAX
div zmB				; dzielenie  A / B wynik w EAX
mov EDX, zmC        ; zmienna C do EDX
sub EAX, EDX		; odejumjemy od wyniku dzielenia C, wynik w EAX
add EAX, zmD		; dodajemy do EAX zmienn� D, wynik w EAX
mov EDX, 0          ; sprz�tanie, zerowanie edx
;;;; ................
;--- wyprowadzenie wyniku oblicze� ---
push EAX
push OFFSET wynik
push OFFSET bufor
call wsprintfA              ; zwraca ilo�� znak�w w buforze
add ESP, 16                 ; czyszczenie stosu
mov rinp, EAX               ; zapami�tywanie ilo�ci znak�w
;--- wy�wietlenie wynika ---------
push 0                      ; rezerwa, musi by� zero
push OFFSET rout            ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rinp                   ; ilo�� znak�w
push OFFSET bufor           ; wska�nik na tekst w buforze
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo�anie funkcji WriteConsoleA
;--- wy�wietlenie now� linii ---
push	0		      ; rezerwa, musi by� zero
push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	2		      ; ilo�� znak�w
push	OFFSET nowa 	; wska�nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
;--- wy�wietlenie now� linii ---
push	0		      ; rezerwa, musi by� zero
push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	2		      ; ilo�� znak�w
push	OFFSET nowa 	; wska�nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
;--- wy�wietlenie nowej lini ---------
push 0                 ; rezerwa, musi by� zero
push OFFSET rout      ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push 2                ; ilo�� znak�w
push OFFSET nowa      ; wska�nik na tekst
push hout             ; deskryptor buforu konsoli
call WriteConsoleA       
;--- wy�wietlenie zakonczenia ---
push 0                  ; rezerwa, musi by� zero
push OFFSET rout        ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmZ  
push OFFSET tekstZakoncz
push OFFSET tekstZakoncz
call CharToOemA
push 0                          ; rezerwa, musi by� zero
push OFFSET rout                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmZ                      ; ilo�� znak�w
push OFFSET tekstZakoncz        ; wska�nik na tekst
push hout                       ; deskryptor buforu konsoli
call WriteConsoleA              ; wywo�anie funkcji WriteConsole
;--- zako�czenie procesu ---------
push	0
call	ExitProcess	; wywo�anie funkcji ExitProcess
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ScanInt PROC
;; funkcja ScanInt przekszta�ca ci�g cyfr do liczby, kt�re jest zwracana przez EAX
;; argument - zako�czony zerem wiersz z cyframi
;; rejestry: EBX - adres wiersza, EDX - znak liczby, ESI - indeks cyfry w wierszu, EDI - tymczasowy
;--- pocz�tek funkcji
push EBP
mov EBP, ESP        ; wskz�nik stosu ESP przypisujemy do EBP
;--- odk�adanie na stos
push EBX
push ECX
push EDX
push ESI
push EDI
;--- przygotowywanie cyklu
mov EBX, [EBP+8]
push EBX
call lstrlenA
mov EDI, EAX        ; ilo�� znak�w
mov ECX, EAX        ; ilo�� powt�rze� = ilo�� znak�w
xor ESI, ESI        ; wyzerowanie ESI
xor EDX, EDX        ; wyzerowanie EDX
xor EAX, EAX        ; wyzerowanie EAX
mov EBX, [EBP+8]    ; adres tekstu
;--- cykl --------------------------
pocz:
cmp BYTE PTR [EBX+ESI], 0h ;por�wnanie z kodem \0
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 0Dh ;por�wnanie z kodem CR
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 0Ah ;por�wnanie z kodem LF
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 02Dh ;por�wnanie z kodem -
jne @F
mov EDX, 1
jmp nast
@@:
cmp BYTE PTR [EBX+ESI], 030h ;por�wnanie z kodem 0
jae @F
jmp nast
@@:
cmp BYTE PTR [EBX+ESI], 039h ;por�wnanie z kodem 9
jbe @F
jmp nast
;----
@@:
push EDX            ; do EDX procesor mo�e zapisa� wynik mno�enia
mov EDI, 10
mul EDI             ; mno�enie EAX * EDI
mov EDI, EAX        ; tymczasowo z EAX do EDI
xor EAX, EAX        ; zerowani EAX
mov AL, BYTE PTR [EBX+ESI]
sub AL, 030h        ; korekta: cyfra = kod znaku - kod 0
add EAX, EDI        ; dodanie cyfry
pop EDX
nast:
inc ESI
loop pocz
;--- wynik
or EDX, EDX ;analiza znacznika EDX
jz @F
neg EAX
@@:
et4:
;--- zdejmowanie ze stosu
pop EDI
pop ESI
pop EDX
pop ECX
pop EBX
;--- powr�t
mov ESP, EBP        ; przywracamy wska�nik stosu ESP
pop EBP
ret
ScanInt ENDP
_TEXT ENDS
END start