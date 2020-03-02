;Aplikacja korzystaj¹ca z otwartego okna konsoli
.586
.MODEL flat, STDCALL
                                                            ;--- stale ---
                                                            ;--- z pliku windows.inc ---
STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11
                                                            ;--- funkcje API Win32 ---
                                                            ;--- z pliku user32.inc ---
CharToOemA PROTO :DWORD,:DWORD
                                                            ;--- z pliku kernel32.inc ---
GetStdHandle PROTO :DWORD
ReadConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExitProcess PROTO :DWORD
wsprintfA PROTO C :VARARG
lstrlenA PROTO :DWORD
ScanInt PROTO C adres:DWORD
;-------------
includelib .\lib\user32.lib
includelib .\lib\kernel32.lib
;-------------
_DATA SEGMENT
hout DD ?
hinp DD ?
naglow DB "Autor aplikacji Grzegorz Makowski.",0                ; nag³ówek
zaprX DB 0Dh,0Ah,"Proszê wprowadziæ argument X [+Enter]: ",0    ; zaproszenie
wzor DB 0Dh,0Ah,"Funkcja f(X) = X/X-X*X = %ld ",0               ; tekst formatuj¹cy
ALIGN 4                                                         ; wyrównanie do granicy 4-bajtowej
rozmN DD 0                                                      ; iloœæ znaków w nag³ówku
rozmX DD 0                                                      ; iloœæ znaków w zaproszeniu X
zmX DD 1                                                        ; argument X
rout DD 0                                                       ; faktyczna iloœæ wyprowadzonych znaków
rinp DD 0                                                       ; faktyczna iloœæ wprowadzonych znaków
bufor DB 128 dup(0)                                             ; rezerwacja miejsca na bufor i inicjalizacja 0
rbuf DD 128                                                     ; rozmiar bufora
_DATA ENDS
_TEXT SEGMENT
start:
                                                                ; wywo³anie funkcji GetStdHandle
push STD_OUTPUT_HANDLE                                          ; odk³adanie na stos
call GetStdHandle                                               ; funkcja GetStdHandle = podaj deskryptor ekranu
mov hout, EAX                                                   ; deskryptor wyjœciowego bufora konsoli
push STD_INPUT_HANDLE                                           ; odk³adania na stos
call GetStdHandle                                               ; funkcja GetStdHandle = podaj deskryptor klawiatury
mov hinp, EAX                                                   ; deskryptor wejœciowego bufora konsoli

;--- nag³ówek ---------
push OFFSET naglow                                              ; odk³adanie na stos
push OFFSET naglow                                              ; odk³adanie na stos
call CharToOemA                                                 ; wywo³anie funkcji konwersji polskich znaków

;--- wyœwietlenie ---------
push OFFSET naglow
call lstrlenA                                                   ; wywo³anie funkcji
mov rozmN, EAX                                                  ; iloœæ znaków
push 0                                                          ; odk³adanie na stos: rezerwa, musi byæ zero
push OFFSET rout                                                ; odk³adanie na stos: wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmN                                                      ; odk³adanie na stos: iloœæ znaków
push OFFSET naglow                                              ; odk³adanie na stos: wska¿nik na tekst
push hout                                                       ; odk³adanie na stos: deskryptor wyjœciowego buforu konsoli
call WriteConsoleA                                              ; wywo³anie funkcji WriteConsoleA

;--- zaproszenie A ---------
push OFFSET zaprX                                               ; odk³adanie na stos
push OFFSET zaprX                                               ; odk³adanie na stos
call CharToOemA                                                 ; wywo³anie funkcji konwersji polskich znaków

;--- wyœwietlenie zaproszenia A ---
push OFFSET zaprX                                               ; odk³adanie na stos
call lstrlenA
mov rozmX, EAX                                                  ; iloœæ znaków z akumulatora do pamiêci
push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmX                                                      ; iloœæ znaków
push OFFSET zaprX                                               ; wska¿nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; funkcja WriteConsoleA = wyœwietlenie na ekranie

;--- czekanie na wprowadzenie znaków, koniec przez Enter ---
push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rinp                                                ; wskaŸnik na faktyczn¹ iloœæ wprowadzonych znaków
push rbuf                                                       ; rozmiar bufora
push OFFSET bufor                                               ; wska¿nik na bufor
push hinp                                                       ; deskryptor buforu konsoli
call ReadConsoleA                                               ; wywo³anie funkcji ReadConsoleA = odczyt z k³awiatury
lea EBX,bufor
mov EDI,rinp
mov BYTE PTR [EBX+EDI-1],0                                      ; zero na koñcu tekstu

;--- przekszta³cenie A
push OFFSET bufor                                               ; odk³adanie na stos
call ScanInt                                                    ; wywo³anie funkcji przekszta³cenie tekstu do postaci binarnej
add ESP, 8
mov zmX, EAX

;--- obliczenia ---
mov EAX, zmX                                                    ; przeniesienei doeax zmiennej
mul zmX                                                         ; mnozenie zmiennej
mov ECX, EAX                                                    ; przeniesienie 
mov EAX, zmX
mov EDX, 0                                                      ; zerujemt edx
div zmX                                                         ; dzieli zmeinna
sub EAX, ECX                                                    ; odejmowanie i wynik w eax

;;;; ................
;--- wyprowadzenie wyniku obliczeñ ---
push EAX                                                        ; odk³adanie na stos
push OFFSET wzor                                                ; odk³adanie na stos
push OFFSET bufor                                               ; odk³adanie na stos
call wsprintfA                                                  ; funkcja przekszta³cenia liczby; zwraca iloœæ znaków
add ESP, 12                                                     ; czyszczenie stosu
mov rinp, EAX                                                   ; zapamiêtywanie iloœci znaków

;--- wyœwietlenie wynika ---------
push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rinp                                                       ; iloœæ znaków
push OFFSET bufor                                               ; wskaŸnik na tekst w buforze
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo³anie funkcji WriteConsoleA

;--- zakoñczenie procesu ---------
push 0
call ExitProcess                                                ; wywo³anie funkcji ExitProcess

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ScanInt PROC C adres
;; funkcja ScanInt przekszta³ca ci¹g cyfr do liczby, któr¹ bêdzie w EAX
;; argument - zakoñczony zerem wiersz z cyframi
;; rejestry: EBX - adres wiersza, EDX - znak liczby, ESI - indeks cyfry w wierszu, EDI - tymczasowy
;--- pocz¹tek funkcji
LOCAL number, znacz

;--- odk³adanie na stos
push EBX
push ECX
push EDX
push ESI
push EDI

;--- przygotowywanie cyklu
INVOKE lstrlenA, adres
mov EDI, EAX                                                    ; iloœæ znaków
mov ECX, EAX                                                    ; iloœæ powtórzeñ = iloœæ znaków
xor ESI, ESI                                                    ; wyzerowanie ESI
xor EDX, EDX                                                    ; wyzerowanie EDX
xor EAX, EAX                                                    ; wyzerowanie EAX
mov EBX, adres

;-----------
mov znacz,0
mov number,0

;--- cykl --------------------------
pocz:
cmp BYTE PTR [EBX+ESI], 0h                                              ; porównanie z kodem \0
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 0Dh                                             ; porównanie z kodem CR
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 0Ah                                             ; porównanie z kodem LF
jne @F
jmp et4
@@:
cmp BYTE PTR [EBX+ESI], 02Dh                                            ; porównanie z kodem '-'
jne @F
mov znacz, 1
jmp nast
@@: cmp BYTE PTR [EBX+ESI], '0'                                         ; porównanie z kodem '0'
jae @F
jmp nast
@@: cmp BYTE PTR [EBX+ESI], '9'                                         ; porównanie z kodem '9'
jbe @F
jmp nast

;----
@@: push EDX                                                            ; do EDX procesor mo¿e zapisaæ wynik mno¿enia
mov EAX, number
mov EDI, 10
mul EDI                                                                 ; mno¿enie EAX * (EDI=10)
mov number, EAX                                                         ; tymczasowo z EAX do EDI
xor EAX, EAX                                                            ; zerowanie EAX
mov AL, BYTE PTR [EBX+ESI]
sub AL, '0'                                                             ; korekta: cyfra = kod znaku - kod '0'
add number, EAX                                                         ; dodanie cyfry
pop EDX
nast: inc ESI
dec ECX
jz @F
jmp pocz
    
;--- wynik
@@:
et4:
cmp znacz, 1                                                            ; analiza znacznika
jne @F
neg number
@@:
mov EAX, number

;--- zdejmowanie ze stosu
pop EDI
pop ESI
pop EDX
pop ECX
pop EBX

;--- powrót
ret
ScanInt ENDP
_TEXT ENDS
END start