;Aplikacja "Przesy�anie tablic"
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
    naglow DB "Autor aplikacji Grzegorz Makowski i53",0             ; nag��wek
    wzor DB 0Dh,0Ah,"Wariant 8 Fun. A/B-C+D",0                      ; tekst formatuj�cy
    ALIGN 4                                                         ; wyr�wnanie do granicy 4-bajtowej
    rozmN DD $ - naglow                                             ; ilosc znakow w tablocy
    tab1 DB "A/B-C+D", 0
    nowa DB 0Dh, 0Ah, 0
    ALIGN 4                                                         ; przesuniece do adresu podzielonego na 4
    rout DD 0                                                       ; faktyczna ilo�� wyprowadzonych znak�w
    rinp DD 0 
    rbuf DD 8
    bufor	DB	8 dup(?)
    tekstT DB "Tekst tablicy: ",0
    rozmTT DD $ - tekstT
    tekstTB DB "Zawarto�� tabl buf: ",0
    rozmTB DD $ - tekstTB
    tekstTBb DB "Zawarto�� tabl buf: ",0
    rozmTBb DD $ - tekstTBb
    zadA DB "Zadanie a) ",0                                         ; nag��wek zadania A
    rozmA DD $ - zadA
    zadB DB "Zadanie b) ",0                                         ; nag��wek zadania B
    rozmB DD $ - zadB                                            
    tekstZakoncz DB "Dzi�kuj� za uwag�! PWSBIA@2020",0              ; nag��wek
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
    push rozmA                    ; ilo�� znak�w
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

;--- opis tekst tablict tekstowej ---------
    push OFFSET tekstT
    push OFFSET tekstT
    call CharToOemA               ; konwersja polskich znak�w
    push 0                        ; rezerwa, musi by� zero
    push OFFSET rout              ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
    push rozmTT                   ; ilo�� znak�w
    push OFFSET tekstT            ; wska�nik na tekst
    push hout                     ; deskryptor buforu konsoli
    call WriteConsoleA 

;--- wy�wietlenie now� linii ---

    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	2		      ; ilo�� znak�w
    push	OFFSET nowa 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA

;--- wy�wietlenie tab1 ---

    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	8		      ; ilo�� znak�w
    push	OFFSET tab1 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA

;--- Zadanie a)

    lea EBX, tab1    
    lea EAX, bufor    
    push    DWORD PTR [EBX]
    pop     DWORD PTR [EAX+4]
    push    DWORD PTR [EBX+4]
    pop     DWORD PTR [EAX]
    
;--- wy�wietlenie now� linii ---

    push	0		        ; rezerwa, musi by� zero
    push	OFFSET rout         ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	2		        ; ilo�� znak�w
    push	OFFSET nowa 	  ; wska�nik na tekst
    push	hout		        ; deskryptor buforu konsoli
    call	WriteConsoleA	  ; wywo�anie funkcji WriteConsoleA

;--- opis -- wy�wietlenie zawarto�ci bufora ---------

    push OFFSET tekstTB
    push OFFSET tekstTB
    call CharToOemA             ; konwersja polskich znak�w
    push 0                      ; rezerwa, musi by� zero
    push OFFSET rout            ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
    push rozmTB                 ; ilo�� znak�w
    push OFFSET tekstTB         ; wska�nik na tekst
    push hout                   ; deskryptor buforu konsoli
    call WriteConsoleA 

;--- wy�wietlenie now� linii ---

    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	2		      ; ilo�� znak�w
    push	OFFSET nowa 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA

;--- wy�wietlenie bufor ---

    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	8		      ; ilo�� znak�w
    push	OFFSET bufor 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
    
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

;--- opis funkcji programu ---------

    push OFFSET zadB
    push OFFSET ZadB
    call CharToOemA            ; konwersja polskich znak�w

    push 0                     ; rezerwa, musi by� zero
    push OFFSET rout           ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
    push rozmB                 ; ilo�� znak�w
    push OFFSET ZadB           ; wska�nik na tekst
    push hout                  ; deskryptor buforu konsoli
    call WriteConsoleA 
;--- wy�wietlenie now� linii ---

    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	2		      ; ilo�� znak�w
    push	OFFSET nowa 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA

;--- opis - zawartosc tabl tekstowej ---------
    push OFFSET tekstT
    push OFFSET tekstT
    call CharToOemA               ; konwersja polskich znak�w
    push 0                        ; rezerwa, musi by� zero
    push OFFSET rout              ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
    push rozmTT                   ; ilo�� znak�w
    push OFFSET tekstT            ; wska�nik na tekst
    push hout                     ; deskryptor buforu konsoli
    call WriteConsoleA 

;--- wy�wietlenie now� linii ---

    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	2		      ; ilo�� znak�w
    push	OFFSET nowa 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA

;--- wy�wietlenie tab1 ---

    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	8		      ; ilo�� znak�w
    push	OFFSET tab1 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA

;--- wy�wietlenie now� linii ---

    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	2		      ; ilo�� znak�w
    push	OFFSET nowa 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA

;--- opis -- wy�wietlenie zawarto�ci bufora ---------

    push OFFSET tekstTBb
    push OFFSET tekstTBb
    call CharToOemA               ; konwersja polskich znak�w
    push 0                        ; rezerwa, musi by� zero
    push OFFSET rout              ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
    push rozmTBb                   ; ilo�� znak�w
    push OFFSET tekstTBb           ; wska�nik na tekst
    push hout                     ; deskryptor buforu konsoli
    call WriteConsoleA 

;--- wy�wietlenie now� linii ---
    push	0		      ; rezerwa, musi by� zero
    push	OFFSET rout 	; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	2		      ; ilo�� znak�w
    push	OFFSET nowa 	; wska�nik na tekst
    push	hout		      ; deskryptor buforu konsoli
    call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
    
;--- Zadanie b)---- 

    lea ESI, tab1
    lea EDI, bufor
    cld
    mov ECX,8
    rep movsb
    
;--- wy�wietlenie bufor ---

    push	0		        ; rezerwa, musi by� zero
    push	OFFSET rout 	  ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
    push	8		        ; ilo�� znak�w
    push	OFFSET bufor 	  ; wska�nik na tekst
    push	hout		        ; deskryptor buforu konsoli
    call	WriteConsoleA	  ; wywo�anie funkcji WriteConsoleA
    
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
    push	0
    call	ExitProcess	; wywo�anie funkcji ExitProcess
_TEXT	ENDS
END start

