;Aplikacja "Przesy³anie tablic"
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
    naglow DB "Autor aplikacji Grzegorz Makowski i53",0             ; nag³ówek
    wzor DB 0Dh,0Ah,"Wariant 8 Fun. A/B-C+D",0                      ; tekst formatuj¹cy
    ALIGN 4                                                         ; wyrównanie do granicy 4-bajtowej
    rozmN DD $ - naglow                                             ; ilosc znakow w tablocy
    tab1 DB "A/B-C+D", 0
    nowa DB 0Dh, 0Ah, 0
    ALIGN 4                                                         ; przesuniece do adresu podzielonego na 4
    rout DD 0                                                       ; faktyczna iloœæ wyprowadzonych znaków
    rinp DD 0 
    rbuf DD 8
    bufor	DB	8 dup(?)
    tekstT DB "Tekst tablicy: ",0
    rozmTT DD $ - tekstT
    tekstTB DB "Zawartoœæ tabl buf: ",0
    rozmTB DD $ - tekstTB
    tekstTBb DB "Zawartoœæ tabl buf: ",0
    rozmTBb DD $ - tekstTBb
    zadA DB "Zadanie a) ",0                                         ; nag³ówek zadania A
    rozmA DD $ - zadA
    zadB DB "Zadanie b) ",0                                         ; nag³ówek zadania B
    rozmB DD $ - zadB                                            
    tekstZakoncz DB "Dziêkujê za uwagê! PWSBIA@2020",0              ; nag³ówek
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
    push rozmA                    ; iloœæ znaków
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

;--- opis tekst tablict tekstowej ---------
    push OFFSET tekstT
    push OFFSET tekstT
    call CharToOemA               ; konwersja polskich znaków
    push 0                        ; rezerwa, musi byæ zero
    push OFFSET rout              ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
    push rozmTT                   ; iloœæ znaków
    push OFFSET tekstT            ; wska¿nik na tekst
    push hout                     ; deskryptor buforu konsoli
    call WriteConsoleA 

;--- wyœwietlenie now¹ linii ---

    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	2		      ; iloœæ znaków
    push	OFFSET nowa 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA

;--- wyœwietlenie tab1 ---

    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	8		      ; iloœæ znaków
    push	OFFSET tab1 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA

;--- Zadanie a)

    lea EBX, tab1    
    lea EAX, bufor    
    push    DWORD PTR [EBX]
    pop     DWORD PTR [EAX+4]
    push    DWORD PTR [EBX+4]
    pop     DWORD PTR [EAX]
    
;--- wyœwietlenie now¹ linii ---

    push	0		        ; rezerwa, musi byæ zero
    push	OFFSET rout         ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	2		        ; iloœæ znaków
    push	OFFSET nowa 	  ; wska¿nik na tekst
    push	hout		        ; deskryptor buforu konsoli
    call	WriteConsoleA	  ; wywo³anie funkcji WriteConsoleA

;--- opis -- wyœwietlenie zawartoœci bufora ---------

    push OFFSET tekstTB
    push OFFSET tekstTB
    call CharToOemA             ; konwersja polskich znaków
    push 0                      ; rezerwa, musi byæ zero
    push OFFSET rout            ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
    push rozmTB                 ; iloœæ znaków
    push OFFSET tekstTB         ; wska¿nik na tekst
    push hout                   ; deskryptor buforu konsoli
    call WriteConsoleA 

;--- wyœwietlenie now¹ linii ---

    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	2		      ; iloœæ znaków
    push	OFFSET nowa 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA

;--- wyœwietlenie bufor ---

    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	8		      ; iloœæ znaków
    push	OFFSET bufor 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
    
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

;--- opis funkcji programu ---------

    push OFFSET zadB
    push OFFSET ZadB
    call CharToOemA            ; konwersja polskich znaków

    push 0                     ; rezerwa, musi byæ zero
    push OFFSET rout           ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
    push rozmB                 ; iloœæ znaków
    push OFFSET ZadB           ; wska¿nik na tekst
    push hout                  ; deskryptor buforu konsoli
    call WriteConsoleA 
;--- wyœwietlenie now¹ linii ---

    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	2		      ; iloœæ znaków
    push	OFFSET nowa 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA

;--- opis - zawartosc tabl tekstowej ---------
    push OFFSET tekstT
    push OFFSET tekstT
    call CharToOemA               ; konwersja polskich znaków
    push 0                        ; rezerwa, musi byæ zero
    push OFFSET rout              ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
    push rozmTT                   ; iloœæ znaków
    push OFFSET tekstT            ; wska¿nik na tekst
    push hout                     ; deskryptor buforu konsoli
    call WriteConsoleA 

;--- wyœwietlenie now¹ linii ---

    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	2		      ; iloœæ znaków
    push	OFFSET nowa 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA

;--- wyœwietlenie tab1 ---

    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	8		      ; iloœæ znaków
    push	OFFSET tab1 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA

;--- wyœwietlenie now¹ linii ---

    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	2		      ; iloœæ znaków
    push	OFFSET nowa 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA

;--- opis -- wyœwietlenie zawartoœci bufora ---------

    push OFFSET tekstTBb
    push OFFSET tekstTBb
    call CharToOemA               ; konwersja polskich znaków
    push 0                        ; rezerwa, musi byæ zero
    push OFFSET rout              ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków
    push rozmTBb                   ; iloœæ znaków
    push OFFSET tekstTBb           ; wska¿nik na tekst
    push hout                     ; deskryptor buforu konsoli
    call WriteConsoleA 

;--- wyœwietlenie now¹ linii ---
    push	0		      ; rezerwa, musi byæ zero
    push	OFFSET rout 	; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	2		      ; iloœæ znaków
    push	OFFSET nowa 	; wska¿nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo³anie funkcji WriteConsoleA
    
;--- Zadanie b)---- 

    lea ESI, tab1
    lea EDI, bufor
    cld
    mov ECX,8
    rep movsb
    
;--- wyœwietlenie bufor ---

    push	0		        ; rezerwa, musi byæ zero
    push	OFFSET rout 	  ; wskaŸnik na faktyczn¹ iloœæ wyprowadzonych znaków 
    push	8		        ; iloœæ znaków
    push	OFFSET bufor 	  ; wska¿nik na tekst
    push	hout		        ; deskryptor buforu konsoli
    call	WriteConsoleA	  ; wywo³anie funkcji WriteConsoleA
    
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
    push	0
    call	ExitProcess	; wywo³anie funkcji ExitProcess
_TEXT	ENDS
END start

