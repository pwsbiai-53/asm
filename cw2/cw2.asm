;Aplikacja przesy��nie danych i zarzadzanie danymi
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
naglow DB "Autor aplikacji Grzegorz Makowski i53",0                ; nag��wek
wzor DB 0Dh,0Ah,"Wariant 8 Fun. A/B-C+D",0                       ; tekst formatuj�cy
ALIGN 4                                                         ; wyr�wnanie do granicy 4-bajtowej
rozmN DD $ - naglow                                             ;ilosc znakow w tablocy
tab1 DB "A/B-C+D", 0
nowa DB 0Dh, 0Ah, 0
ALIGN 4                                                         ; przesuniece do adresu podzielonego na 4
rout DD 0                                                       ; faktyczna ilo�� wyprowadzonych znak�w
rinp DD 0 
rbuf DD 8                                                      ; faktyczna ilo�� wprowadzonych znak�w
tekstNotacja DB "Zapis w notacji polskiej: ",0                ; nag��wek
rozmNot DD $ - tekstNotacja
tekstZakoncz DB "Dzi�kuj� za uwag�! PWSBIA@2020",0                ; nag��wek
rozmZ DD $ - tekstZakoncz
bufor DD 8 dup (?)                                               

_DATA ENDS
_TEXT SEGMENT

start:

;--- wywo�anie funkcji GetStdHandle- Deskryptor konsoli

push STD_OUTPUT_HANDLE
call GetStdHandle                                               ; wywo�anie funkcji GetStdHandle
mov hout, EAX                                                   ; deskryptor wyj�ciowego bufora konsoli
push STD_INPUT_HANDLE
call GetStdHandle                                               ; wywo�anie funkcji GetStdHandle
mov hinp, EAX                                                   ; deskryptor wej�ciowego bufora konsoli

;--- nag��wek ---------

push OFFSET naglow
push OFFSET naglow
call CharToOemA                                                 ; konwersja polskich znak�w

;--- wy�wietlenie ---------

push 0                                                          ; rezerwa, musi by� zero
push OFFSET rout                                                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmN                                                      ; ilo�� znak�w
push OFFSET naglow                                              ; wska�nik na tekst
;push OFFSET wzor
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo�anie funkcji WriteConsoleA

;--- wy�wietlenie nowej lini ---------

push 0                                                          ; rezerwa, musi by� zero
push OFFSET rout                                                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push 2                                                          ; ilo�� znak�w
push OFFSET nowa                                                ; wska�nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo�anie funkcji WriteConsoleA

;--- opis funkcji programu ---------

push OFFSET tekstNotacja
push OFFSET tekstNotacja
call CharToOemA                                                 ; konwersja polskich znak�w

push 0                                                          ; rezerwa, musi by� zero
push OFFSET rout                                                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmNot                                                    ; ilo�� znak�w
push OFFSET tekstNotacja                                        ; wska�nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA 

;-- Zadanie b Zmieni� "A/B-C+D" na -/AB+CD (Notacja polska)

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

;--- wy�wietlenie bufor ---
push	0		; rezerwa, musi by� zero
push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	8		; ilo�� znak�w
;push	OFFSET tab1	; wska�nik na tekst
push	OFFSET tab1
push	hout		; deskryptor buforu konsoli
call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA	

;--- wy�wietlenie nowej lini ---------

push 0                                                          ; rezerwa, musi by� zero
push OFFSET rout                                                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push 2                                                          ; ilo�� znak�w
push OFFSET nowa                                                ; wska�nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo�anie funkcji WriteConsoleA

;--- wy�wietlenie bufor ---

push 0                                                          ; rezerwa, musi by� zero
push OFFSET rout                                                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push 8                                                          ; ilo�� znak�w
push OFFSET bufor                                               ; wska�nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo�anie funkcji WriteConsoleA

;--- wy�wietlenie nowej lini ---------

push 0                                                          ; rezerwa, musi by� zero
push OFFSET rout                                                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push 2                                                          ; ilo�� znak�w
push OFFSET nowa                                                ; wska�nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA        

;--- wy�wietlenie zakonczenia ---

push 0                                                          ; rezerwa, musi by� zero
push OFFSET rout                                                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmZ  
push OFFSET tekstZakoncz
push OFFSET tekstZakoncz
call CharToOemA

push 0                                                          ; rezerwa, musi by� zero
push OFFSET rout                                                ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
push rozmZ                                                      ; ilo�� znak�w
push OFFSET tekstZakoncz                                        ; wska�nik na tekst
push hout                                                       ; deskryptor buforu konsoli
call WriteConsoleA                                              ; wywo�anie funkcji WriteConsoleA

;--- zako�czenie procesu ---------

push 0
call ExitProcess                                                ; wywo�anie funkcji ExitProcess
ScanInt PROC
;; funkcja ScanInt przekszta�ca ci�g cyfr do liczby, kt�r� jest zwracana przez EAX
;; argument - zako�czony zerem wiersz z cyframi
;; rejestry: EBX - adres wiersza, EDX - znak liczby, ESI - indeks cyfry w wierszu, EDI - tymczasowy
;--- pocz�tek funkcji
push EBP
mov EBP, ESP                                                    ; wska�nik stosu ESP przypisujemy do EBP
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
mov EDI, EAX ; ilo�� znak�w
mov ECX, EAX ; ilo�� powt�rze� = ilo�� znak�w
xor ESI, ESI ; wyzerowanie ESI
xor EDX, EDX ; wyzerowanie EDX
xor EAX, EAX ; wyzerowanie EAX
mov EBX, [EBP+8] ; adres tekstu
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
push EDX ; do EDX procesor mo�e zapisa� wynik mno�enia
mov EDI, 10
mul EDI ;mno�enie EAX * EDI
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
;--- powr�t
mov ESP, EBP                                            ; przywracamy wska�nik stosu ESP
pop EBP
ret
ScanInt ENDP
_TEXT ENDS

END start
