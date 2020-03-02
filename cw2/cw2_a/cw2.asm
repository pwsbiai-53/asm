;Aplikacja przesy³¹nie danych i zarzadzanie danymi
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
;-------------
includelib .\lib\user32.lib
includelib .\lib\kernel32.lib
;-------------
_DATA SEGMENT
hout DD ?
hinp DD ?
naglow DB "Autor aplikacji Grzegorz Makowski i53",0                ; nag³ówek
wzor DB 0Dh,0Ah,"Wariant 8 Fun. A/B-C+D",0                       ; tekst formatuj¹cy
ALIGN 4                                                         ; wyrównanie do granicy 4-bajtowej
rozmN DD $ - naglow                                             ;ilosc znakow w tablocy
tab1 DB "A/B-C+D", 0
nowa DB 0Dh, 0Ah, 0
ALIGN 4                                                         ; przesuniece do adresu podzielonego na 4
rout DD 0                                                       ; faktyczna iloœæ wyprowadzonych znaków
rinp DD 0 
rbuf DD 8                                                      ; faktyczna iloœæ wprowadzonych znaków
tekstZakoncz DB "Dziêkujê za uwagê! PWSBIA@2020",0                ; nag³ówek
rozmZ DD $ - tekstZakoncz
bufor DD 8 dup (?)                                               

_DATA ENDS
_TEXT SEGMENT

start:

;--- wywo³anie funkcji GetStdHandle- Deskryptor konsoli

push STD_OUTPUT_HANDLE
call GetStdHandle                                               ; wywo³anie funkcji GetStdHandle
mov hout, EAX                                                   ; deskryptor wyjœciowego bufora konsoli
push STD_INPUT_HANDLE
call GetStdHandle                                               ; wywo³anie funkcji GetStdHandle
mov hinp, EAX                                                   ; deskryptor wejœciowego bufora konsoli

;--- nag³ówek ---------

push OFFSET naglow
push OFFSET naglow
call CharToOemA                                                 ; konwersja polskich znaków

;--- wyœwietlenie ---------

push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmN                                                      ; iloœæ znaków
push OFFSET naglow                                              ; wska¿nik na tekst
;push OFFSET wzor
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo³anie funkcji WriteConsoleA

;--- wyœwietlenie nowej lini ---------

push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push 2                                                          ; iloœæ znaków
push OFFSET nowa                                                ; wskaŸnik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo³anie funkcji WriteConsoleA

;--- wyœwietlenie tab1 ---

push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push 8                                                          ; iloœæ znaków
push OFFSET tab1                                                ; wska¿nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo³anie funkcji WriteConsoleA

;-- Zadanie a

;mov EBX, OFFSET tab1
;mov ECX, DWORD PTR [EBX]                                        ; w DWORD urkyte 4 bajty
;mov EDX, DWORD PTR [EBX+4]                                      ; adres w EBX + 4
;lea EBX, bufor
;xchg ECX, EDX                                                   ; zamiana miejscami
;mov DWORD PTR [EBX], ECX                                        ; zapisanie z powrotem z przesuniêtymi znakami
;mov DWORD PTR [EBX+4], EDX

;-- Zadanie b Zmieniæ "A/B-C+D" na -/AB+CD (Notacja polska)

mov EBX, OFFSET tab1
mov AL, BYTE PTR [EBX+0]
mov CL, BYTE PTR [EBX+3]
mov BYTE PTR [EBX+0], CL
mov CL,BYTE PTR [EBX+2]
mov BYTE PTR [EBX+2], AL
mov BYTE PTR [EBX+3], CL
mov CL,BYTE PTR [EBX+4]
mov AL,BYTE PTR [EBX+5]
mov BYTE PTR [EBX+4], AL
mov BYTE PTR [EBX+5], CL


;--- wyœwietlenie nowej lini ---------

push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push 2                                                          ; iloœæ znaków
push OFFSET nowa                                                ; wskaŸnik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo³anie funkcji WriteConsoleA

;--- wyœwietlenie bufor ---

push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push 8                                                          ; iloœæ znaków
push OFFSET bufor                                               ; wska¿nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo³anie funkcji WriteConsoleA

;--- wyœwietlenie nowej lini ---------

push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push 2                                                          ; iloœæ znaków
push OFFSET nowa                                                ; wskaŸnik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA        

;--- wyœwietlenie zakonczenia ---

push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmZ  
push OFFSET tekstZakoncz
push OFFSET tekstZakoncz
call CharToOemA

push 0                                                          ; rezerwa, musi byæ zero
push OFFSET rout                                                ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
push rozmZ                                                      ; iloœæ znaków
push OFFSET tekstZakoncz                                        ; wska¿nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo³anie funkcji WriteConsoleA


;--- zakoñczenie procesu ---------

push 0
call ExitProcess                                                ; wywo³anie funkcji ExitProcess
ScanInt PROC
;; funkcja ScanInt przekszta³ca ci¹g cyfr do liczby, któr¹ jest zwracana przez EAX
;; argument - zakoñczony zerem wiersz z cyframi
;; rejestry: EBX - adres wiersza, EDX - znak liczby, ESI - indeks cyfry w wierszu, EDI - tymczasowy
;--- pocz¹tek funkcji
push EBP
mov EBP, ESP                                                    ; wskaŸnik stosu ESP przypisujemy do EBP
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
mov EDI, EAX ; iloœæ znaków
mov ECX, EAX ; iloœæ powtórzeñ = iloœæ znaków
xor ESI, ESI ; wyzerowanie ESI
xor EDX, EDX ; wyzerowanie EDX
xor EAX, EAX ; wyzerowanie EAX
mov EBX, [EBP+8] ; adres tekstu
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
push EDX ; do EDX procesor mo¿e zapisaæ wynik mno¿enia
mov EDI, 10
mul EDI ;mno¿enie EAX * EDI
mov EDI, EAX ; tymczasowo z EAX do EDI
xor EAX, EAX ;zerowani EAX
mov AL, BYTE PTR [EBX+ESI]
sub AL, 030h ; korekta: cyfra = kod znaku - kod 0
add EAX, EDI ; dodanie cyfry
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
mov ESP, EBP                                            ; przywracamy wskaŸnik stosu ESP
pop EBP
ret
ScanInt ENDP
_TEXT ENDS

END start
