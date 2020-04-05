;Aplikacja "Instrukcje arytmetyczne i logiczne. Przesuwanie i rotacja bitów"
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
naglow DB "Autor aplikacji Grzegorz Makowski i53",0                 ; nag³ówek
wzor DB 0Dh,0Ah,"Instrukcje arytmetyczne i logiczne.",0                                       ; tekst formatuj¹cy
ALIGN 4                                                             ; wyrównanie do granicy 4-bajtowej
rozmN DD $ - naglow                                                 ; ilosc znakow w tablocy
nowa DB 0Dh, 0Ah, 0
ALIGN 4                                                             ; przesuniece do adresu podzielonego na 4

zadA DB "Zadanie a) ",0                                             ; nag³ówek zadania A
rozmzadA DD $ - zadA
naglowA DB 0Dh,0Ah, "WprowadŸ 4 parametry do fun. f() = A/B-C+D",0  ; nag³ówek
rozmnaglA DD $ - naglowA 

zaproszenieA DB 0Dh,0Ah,"Proszê wprowadziæ argument A [+Enter]: ",0 ; Tekst zaproszenia do wprowadzenie amiennej A
rozmiarA DD $ - zaproszenieA
zmA DD 1                                                            ; argument A
  
zaproszenieB DB 0Dh,0Ah,"Proszê wprowadziæ argument B [+Enter]: ",0 ; Tekst zaproszenia do wprowadzenie amiennej B
rozmiarB DD $ - zaproszenieB
zmB DD 1                                                            ; argument B
    
zaproszenieC DB 0Dh,0Ah,"Proszê wprowadziæ argument C [+Enter]: ",0 ; Tekst zaproszenia do wprowadzenie amiennej C
rozmiarC DD $ - zaproszenieC
zmC DD 1                                                            ; argument C
    
zaproszenieD DB 0Dh,0Ah,"Proszê wprowadziæ argument D [+Enter]: ",0 ; Tekst zaproszenia do wprowadzenie amiennej D
rozmiarD DD $ - zaproszenieD
zmD DD 1

wynik DB 0Dh,0Ah,"Wynik f() =  %ld",0
rout DD 0                                                           ; faktyczna iloœæ wyprowadzonych znaków
rinp DD 0                                                           ; faktyczna iloœæ wprowadzonych znaków
rbuf DD 128
bufor	DB    128 dup(?)
   
zadB DB "Zadanie b) ",0                                            ; nag³ówek zadania B
rozmB DD $ - zadB                                            
tekstZakoncz DB "Dziêkujê za uwagê! PWSBIA@2020",0                  ; nag³ówek
rozmZ DD $ - tekstZakoncz
_DATA ENDS
;------------
_TEXT SEGMENT
start:
;--- deskryptory konsoli 
push	STD_OUTPUT_HANDLE
call	GetStdHandle	; wywo³anie funkcji GetStdHandle
mov	hout, EAX	      ; deskryptor wyjœciowego bufora konsoli
push	STD_INPUT_HANDLE
call	GetStdHandle	; wywo³anie funkcji GetStdHandle
mov	hinp, EAX	      ; deskryptor wejœciowego bufora konsoli
;--- nag³ówek ---------
push	OFFSET naglow
push	OFFSET naglow
call	CharToOemA	      ; konwersja polskich znaków
;--- wyœwietlenie ---------
push	0		      ; rezerwa, musi byæ zero
push	OFFSET rout	      ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
push	rozmN		      ; iloœæ znaków
push	OFFSET naglow 	; wska¿nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
;--- wyœwietlenie now¹ linii ---
push	0		      ; rezerwa, musi byæ zero
push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
push	2		      ; iloœæ znaków
push	OFFSET nowa 	; wska¿nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
;--- opis funkcji programu ---------

push OFFSET zadA
push OFFSET ZadA
call CharToOemA               ; konwersja polskich znaków
push 0                        ; rezerwa, musi byæ zero
push OFFSET rout              ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmzadA                    ; iloœæ znaków
push OFFSET ZadA              ; wska¿nik na tekst
push hout                     ; deskryptor buforu konsoli
call WriteConsoleA 
;--- wyœwietlenie now¹ linii ---
push	0		      ; rezerwa, musi byæ zero
push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
push	2		      ; iloœæ znaków
push	OFFSET nowa 	; wska¿nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
;--- Zaproszenie do zadania A ---------
push OFFSET naglowA
push OFFSET naglowA
call CharToOemA               ; konwersja polskich znaków
push 0                        ; rezerwa, musi byæ zero
push OFFSET rout              ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmnaglA                   ; iloœæ znaków
push OFFSET naglowA            ; wska¿nik na tekst
push hout                     ; deskryptor buforu konsoli
call WriteConsoleA 
;--- wyœwietlenie now¹ linii ---
push	0		      ; rezerwa, musi byæ zero
push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
push	2		      ; iloœæ znaków
push	OFFSET nowa 	; wska¿nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
;--- wyœwietlenie now¹ linii ---
push	0		        ; rezerwa, musi byæ zero
push	OFFSET rout         ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
push	2		        ; iloœæ znaków
push	OFFSET nowa 	  ; wska¿nik na tekst
push	hout		        ; deskryptor buforu konsoli
call	WriteConsoleA	  ; wywo³anie funkcji WriteConsoleA
;--- zaproszenie A ---------
push OFFSET zaproszenieA
push OFFSET zaproszenieA
call CharToOemA             ; konwersja polskich znaków
;--- wyœwietlenie zaproszenia A ---
push 0                      ; rezerwa, musi byæ zero
push OFFSET rout            ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmiarA               ; iloœæ znaków
push OFFSET zaproszenieA    ; wska¿nik na tekst
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo³anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znaków, koniec przez Enter ---
push 0                      ; rezerwa, musi byæ zero
push OFFSET rinp            ; wskaŸnik na faktyczn¹ iloœæ wprowadzonych znaków
push rbuf                   ; rozmiar bufora
push OFFSET bufor           ;wska¿nik na bufor
push hinp                   ; deskryptor buforu konsoli
call ReadConsoleA           ; wywo³anie funkcji ReadConsoleA
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0  ;zero na koñcu tekstu
;--- przekszta³cenie A
push OFFSET bufor
call ScanInt
add ESP, 8
mov zmA, EAX
;;;........ B
;--- zaproszenie B---------
push OFFSET zaproszenieB
push OFFSET zaproszenieB
call CharToOemA             ; konwersja polskich znaków
;--- wyœwietlenie zaproszenia B ---
push 0                      ; rezerwa, musi byæ zero
push OFFSET rout            ; wskaŸnik na faktycznš iloœæ wyprowadzonych znaków
push rozmiarB               ; iloœæ znaków
push OFFSET zaproszenieB    ; wska¿nik na tekst
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo³anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znaków, koniec przez Enter ---
push 0                      ; rezerwa, musi byæ zero
push OFFSET rinp            ; wskaŸnik na faktycznš iloœæ wprowadzonych znaków
push rbuf                   ; rozmiar bufora
push OFFSET bufor           ;wska¿nik na bufor
push hinp                   ; deskryptor buforu konsoli
call ReadConsoleA           ; wywo³anie funkcji ReadConsoleA
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0 ;zero na koñcu tekstu
;--- przekszta³cenie B
push OFFSET bufor
call ScanInt
add ESP, 8
mov zmB, EAX
;--- zaproszenie C ---------
push OFFSET zaproszenieC
push OFFSET zaproszenieC
call CharToOemA             ; konwersja polskich znaków
;--- wyœwietlenie zaproszenia C ---
push 0                      ; rezerwa, musi byæ zero
push OFFSET rout            ; wskaŸnik na faktycznš ilosæ wyprowadzonych znaków
push rozmiarC               ; iloœæ znaków
push OFFSET zaproszenieC    ; wska¿nik na tekst
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo³anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znaków, koniec przez Enter ---
push 0                      ; rezerwa, musi byæ zero
push OFFSET rinp            ; wskaŸnik na faktycznš iloœæ wprowadzonych znaków
push rbuf                   ; rozmiar bufora
push OFFSET bufor           ; wska¿nik na bufor
push hinp                   ; deskryptor buforu konsoli
call ReadConsoleA           ; wywo³anie funkcji ReadConsoleA
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0  ;zero na koñcu tekstu
;--- przekszta³cenie C
push OFFSET bufor
call ScanInt
add ESP, 8
mov zmC, EAX
;--- zaproszenie D ---------
push OFFSET zaproszenieD
push OFFSET zaproszenieD
call CharToOemA             ; konwersja polskich znaków
;--- wyœwietlenie zaproszenia D ---
push 0                      ; rezerwa, musi byæ zero
push OFFSET rout            ; wskaŸnik na faktycznš iloœæ wyprowadzonych znaków
push rozmiarD               ; iloœæ znaków
push OFFSET zaproszenieD    ; wska¿nik na tekst
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo³anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znaków, koniec przez Enter ---
push 0                      ; rezerwa, musi byæ zero
push OFFSET rinp            ; wskaŸnik na faktycznš iloœæ wprowadzonych znaków
push rbuf                   ; rozmiar bufora
push OFFSET bufor           ;wska¿nik na bufor
push hinp                   ; deskryptor buforu konsoli
call ReadConsoleA           ; wywo³anie funkcji ReadConsoleA
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0  ;zero na koñcu tekstu
;--- przekszta³cenie D
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
add EAX, zmD		; dodajemy do EAX zmienn¹ D, wynik w EAX
mov EDX, 0          ; sprz¹tanie, zerowanie edx
;;;; ................
;--- wyprowadzenie wyniku obliczeñ ---
push EAX
push OFFSET wynik
push OFFSET bufor
call wsprintfA              ; zwraca iloœæ znaków w buforze
add ESP, 16                 ; czyszczenie stosu
mov rinp, EAX               ; zapamiêtywanie iloœci znaków
;--- wyœwietlenie wynika ---------
push 0                      ; rezerwa, musi byæ zero
push OFFSET rout            ; wskaŸnik na faktycznš iloœæ wyprowadzonych znaków
push rinp                   ; iloœæ znaków
push OFFSET bufor           ; wska¿nik na tekst w buforze
push hout                   ; deskryptor buforu konsoli
call WriteConsoleA          ; wywo³anie funkcji WriteConsoleA
;--- wyœwietlenie now¹ linii ---
push	0		      ; rezerwa, musi byæ zero
push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
push	2		      ; iloœæ znaków
push	OFFSET nowa 	; wska¿nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
;--- wyœwietlenie now¹ linii ---
push	0		      ; rezerwa, musi byæ zero
push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
push	2		      ; iloœæ znaków
push	OFFSET nowa 	; wska¿nik na tekst
push	hout		      ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
;--- wyœwietlenie nowej lini ---------
push 0                 ; rezerwa, musi byæ zero
push OFFSET rout      ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push 2                ; iloœæ znaków
push OFFSET nowa      ; wskaŸnik na tekst
push hout             ; deskryptor buforu konsoli
call WriteConsoleA       
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
;--- zakoñczenie procesu ---------
push	0
call	ExitProcess	; wywo³anie funkcji ExitProcess
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ScanInt PROC
;; funkcja ScanInt przekszta³ca ci¹g cyfr do liczby, które jest zwracana przez EAX
;; argument - zakoñczony zerem wiersz z cyframi
;; rejestry: EBX - adres wiersza, EDX - znak liczby, ESI - indeks cyfry w wierszu, EDI - tymczasowy
;--- poczštek funkcji
push EBP
mov EBP, ESP        ; wskzŸnik stosu ESP przypisujemy do EBP
;--- odk³adanie na stos
push EBX
push ECX
push EDX
push ESI
push EDI
;--- przygotowywanie cyklu
mov EBX, [EBP+8]
push EBX
call lstrlenA
mov EDI, EAX        ; iloœæ znaków
mov ECX, EAX        ; iloœæ powtórzeñ = iloœæ znaków
xor ESI, ESI        ; wyzerowanie ESI
xor EDX, EDX        ; wyzerowanie EDX
xor EAX, EAX        ; wyzerowanie EAX
mov EBX, [EBP+8]    ; adres tekstu
;--- cykl --------------------------
pocz:
cmp BYTE PTR [EBX+ESI], 0h ;porównanie z kodem \0
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 0Dh ;porównanie z kodem CR
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 0Ah ;porównanie z kodem LF
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 02Dh ;porównanie z kodem -
jne @F
mov EDX, 1
jmp nast
@@:
cmp BYTE PTR [EBX+ESI], 030h ;porównanie z kodem 0
jae @F
jmp nast
@@:
cmp BYTE PTR [EBX+ESI], 039h ;porównanie z kodem 9
jbe @F
jmp nast
;----
@@:
push EDX            ; do EDX procesor mo¿e zapisaæ wynik mno¿enia
mov EDI, 10
mul EDI             ; mno¿enie EAX * EDI
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
;--- powrót
mov ESP, EBP        ; przywracamy wskaŸnik stosu ESP
pop EBP
ret
ScanInt ENDP
_TEXT ENDS
END start