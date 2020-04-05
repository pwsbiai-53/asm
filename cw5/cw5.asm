;"Podprogramy i makrodefinicje"
.586P
.MODEL flat, STDCALL
;--- stale z pliku .\include\windows.inc ---
STD_INPUT_HANDLE                     equ -10
STD_OUTPUT_HANDLE                    equ -11
;--- stale ---
MBUF = 128
;--- makra ---
PODAJDESKR MACRO handle, deskrypt
 push	handle
 call	GetStdHandle
 mov	deskrypt,EAX ;; deskryptor bufora konsoli
ENDM

PLZNAKI MACRO text, bufor
 invoke CharToOemA, addr text, addr bufor
ENDM

WYSWIETLENIE MACRO bufor, rozmiar
 ;--- wy�wietlenie wyniku ---------
 push 0 ; rezerwa, musi by� zero
 push OFFSET rout ;wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
 push rozmiar ; ilo�� znak�w
 push OFFSET bufor ; wska�nik na tekst w buforze
 push hout ; deskryptor buforu konsoli
 call WriteConsoleA ; wywo�anie funkcji WriteConsoleA
ENDM

ZMIENNA MACRO deskkons, bufor, rozmb, frozm, zmienna
 invoke ReadConsoleA, deskkons, addr bufor, rozmb, addr frozm, 0
 push OFFSET bufor
 call ScanInt
 add ESP, 4
 mov zmienna, EAX
ENDM

;--- funkcje API Win32 z pliku  .\include\user32.inc ---
CharToOemA PROTO tekst1:DWORD,tekst2:DWORD

;--- funkcje API Win32 z pliku .\include\kernel32.inc ---
GetStdHandle PROTO :DWORD
ReadConsoleA PROTO 	hinp:DWORD,adres_bufor:DWORD,rbuf:DWORD,adres_rinp:DWORD,rezerwa:DWORD
 	;
WriteConsoleA PROTO 	hout:DWORD,adres_bufor:DWORD,rozm:DWORD,adres_out:DWORD,rezerwa:DWORD

ExitProcess PROTO :DWORD
wsprintfA PROTO C :VARARG
lstrlenA PROTO :DWORD
;--- funkcje
ScanInt PROTO C adres:DWORD
DrukBin PROTO STDCALL liczba:DWORD

arytm PROTO C
logika PROTO STDCALL argA:DWORD,argB:DWORD,argC:DWORD,argD:DWORD
przesuw PROTO C arg:DWORD
;-------------
includelib .\lib\user32.lib
includelib .\lib\kernel32.lib
;-------------
_DATA SEGMENT
	hout	DD	?
	hinp	DD	?
	naglow	DB	"Autor aplikacji Andrzej Witek",0
	ALIGN	4	; przesuniecie do adresu podzielnego na 4
	rozmN	DD	$ - naglow	;ilo�� znak�w w tablicy
	zaprA	DB	0Dh,0Ah,"Prosz� wprowadzi� argument a [+Enter]: ",0
	ALIGN	4
	rozmA	DD	$ - zaprA	;ilo�� znak�w w tablicy
	zmA	DD	1	; argument a
	zaprB	DB	0Dh,0Ah,"Prosz� wprowadzi� argument b [+Enter]: ",0
	ALIGN	4
	rozmB	DD	$ - zaprB	;ilo�� znak�w w tablicy
	zmB	DD	2	; argument b
	zaprC	DB	0Dh,0Ah,"Prosz� wprowadzi� argument c [+Enter]: ",0
	ALIGN	4
	rozmC	DD	$ - zaprC	;ilo�� znak�w w tablicy
	zmC	DD	3	; argument c
	zaprD	DB	0Dh,0Ah,"Prosz� wprowadzi� argument d [+Enter]: ",0
	ALIGN	4
	rozmD	DD	$ - zaprD	;ilo�� znak�w w tablicy
	zmD	DD	4	; argument d
	wzor	     DB	"Funkcja y=a/b-c+d = %4ld",0
	ALIGN	4
	wzor2	     DB	"Funkcja y=a#b*~c|d = %4ld",0
	ALIGN	4
      	newline     DB    0Dh,0Ah,0
	ALIGN	4
	rout	DD	0 ;faktyczna ilo�� wyprowadzonych znak�w
	rinp	DD	0 ;faktyczna ilo�� wprowadzonych znak�w
	rinp2	DD	0 ;faktyczna ilo�� wprowadzonych znak�w
	bufor	DB	MBUF dup(?)
	rbuf	DD	MBUF
      	zmY   DD  0
      	st0   DD  10100110001110000111100000111110b 
_DATA ENDS
;------------

_TEXT SEGMENT
start:
;--- wywo�anie funkcji GetStdHandle - MAKRO
      PODAJDESKR STD_OUTPUT_HANDLE, hout
      PODAJDESKR STD_INPUT_HANDLE, hinp
;--- nag��wek ---------
	PLZNAKI naglow, bufor	; konwersja polskich znak�w - MAKRO
;--- wy�wietlenie ---------
	INVOKE WriteConsoleA,hout,OFFSET bufor,rozmN,OFFSET rout,0	; wywo�anie funkcji WriteConsoleA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- zaproszenie A ---------
	;INVOKE CharToOemA,OFFSET zaprA,OFFSET bufor	; konwersja polskich znak�w
	PLZNAKI zaprA, bufor
;--- wy�wietlenie zaproszenia A ---
	WYSWIETLENIE bufor, rozmA   ; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	ZMIENNA hinp, bufor, rbuf, rinp, zmA
;--- zaproszenie B ---------
	PLZNAKI zaprB, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia B ---
	WYSWIETLENIE bufor, rozmB	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	ZMIENNA hinp, bufor, rbuf, rinp, zmB
;--- zaproszenie C ---------
	PLZNAKI zaprC, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia C ---
	WYSWIETLENIE bufor, rozmC	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	ZMIENNA hinp, bufor, rbuf, rinp, zmC
;--- zaproszenie D ---------
	PLZNAKI zaprD, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia D ---
	WYSWIETLENIE bufor, rozmD	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	ZMIENNA hinp, bufor, rbuf, rinp, zmD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- obliczenia Funkcja y =a/b-c+d
      push zmD
      push zmC
      push zmB
      push zmA
      call arytm
      add   ESP,16
      mov   zmY,EAX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- wyprowadzenie wyniku oblicze� ---
	INVOKE wsprintfA,OFFSET bufor,OFFSET wzor,zmY	; zwraca ilo�� znak�w w buforze 
	mov	rinp, EAX	; zapami�tywanie ilo�ci znak�w
;--- wy�wietlenie wyniku ---------
;--- new line ---------
	INVOKE WriteConsoleA,hout,OFFSET newline,2,OFFSET rout,0	; wywo�anie funkcji WriteConsoleA
;----------------
	INVOKE WriteConsoleA,hout,OFFSET bufor,rinp,OFFSET rout,0	; wywo�anie funkcji WriteConsoleA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- zaproszenie A ---------
	PLZNAKI zaprA, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia A ---
	WYSWIETLENIE bufor, rozmA	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	ZMIENNA hinp, bufor, rbuf, rinp, zmA
;--- zaproszenie B ---------
	PLZNAKI zaprB, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia B ---
	WYSWIETLENIE bufor, rozmB	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	ZMIENNA hinp, bufor, rbuf, rinp, zmB
;--- zaproszenie C ---------
	PLZNAKI zaprC, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia C ---
	WYSWIETLENIE bufor, rozmC	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	ZMIENNA hinp, bufor, rbuf, rinp, zmC
;--- zaproszenie D ---------
	PLZNAKI zaprD, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia D ---
	WYSWIETLENIE bufor, rozmD	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	ZMIENNA hinp, bufor, rbuf, rinp, zmD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- obliczenia Funkcja y =a#b*~c|d
      INVOKE logika,zmA,zmB,zmC,zmD
      mov   zmY,EAX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- wyprowadzenie wyniku oblicze� ---
	INVOKE wsprintfA,OFFSET bufor,OFFSET wzor2,zmY	; zwraca ilo�� znak�w w buforze 
	mov	rinp2, EAX	; zapami�tywanie ilo�ci znak�w
;--- wy�wietlenie wyniku ---------
;--- new line ---------
	INVOKE WriteConsoleA,hout,OFFSET newline,2,OFFSET rout,0	; wywo�anie funkcji WriteConsoleA
;----------------
	INVOKE WriteConsoleA,hout,OFFSET bufor,rinp2,OFFSET rout,0	; wywo�anie funkcji WriteConsoleA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; w prawo CFc4, w lewo 2
;--- new line ---------
	INVOKE WriteConsoleA,hout,OFFSET newline,2,OFFSET rout,0	; wywo�anie funkcji WriteConsoleA
;----------------------------
      INVOKE przesuw, st0
	add	ESP, 4
      ;;; sic!
      ;INVOKE DrukBin, st0
;--- zako�czenie procesu ---------
	INVOKE ExitProcess,0	; wywo�anie funkcji ExitProcess
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;---------Podprogramy  
ScanInt PROC C adres
;; funkcja ScanInt przekszta�ca ci�g cyfr do liczby, kt�r� jest zwracana przez EAX
;; argument - zako�czony zerem wiersz z cyframi
;; rejestry: EBX - adres wiersza, EDX - znak liczby, ESI - indeks cyfry w wierszu, EDI - tymczasowy
;--- pocz�tek funkcji
;--- odk�adanie na stos
	push	EBX
	push	ECX
	push	EDX
	push	ESI
	push	EDI
;--- przygotowywanie cyklu
	INVOKE lstrlenA, adres
	mov	EDI, EAX	;ilo�� znak�w
	mov	ECX, EAX	;ilo�� powt�rze� = ilo�� znak�w
	xor	ESI, ESI	; wyzerowanie ESI
	xor	EDX, EDX	; wyzerowanie EDX
	xor	EAX, EAX	; wyzerowanie EAX
	mov	EBX, adres
;--- cykl  
pocz:	cmp	BYTE PTR [EBX+ESI], 02Dh	;por�wnanie z kodem '-'
	jne	@F
	mov	EDX, 1
	jmp	nast
@@:	cmp	BYTE PTR [EBX+ESI], 030h	;por�wnanie z kodem '0'
	jae	@F
	jmp	nast
@@:	cmp	BYTE PTR [EBX+ESI], 039h	;por�wnanie z kodem '9'
	jbe	@F
	jmp	nast
;----
@@:	push	EDX	; do EDX procesor mo�e zapisa� wynik mno�enia 
	mov	EDI, 10
	mul	EDI		;mno�enie EAX * EDI
	mov	EDI, EAX	; tymczasowo z EAX do EDI
	xor	EAX, EAX	;zerowani EAX
	mov	AL, BYTE PTR [EBX+ESI]
	sub	AL, 030h	; korekta: cyfra = kod znaku - kod '0'	
	add	EAX, EDI	; dodanie cyfry
	pop	EDX
nast:	inc	ESI
      dec   ECX   
      jz    @F
      jmp   pocz
;--- wynik
@@:	or	EDX, EDX	;analiza znacznika EDX
	jz	@F
	neg	EAX
@@:	
;--- zdejmowanie ze stosu
	pop	EDI
	pop	ESI
	pop	EDX
	pop	ECX
	pop	EBX
;--- powr�t
	ret
ScanInt	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrukBin PROC STDCALL liczba:DWORD
;; funkcja DrukBin wyswietla liczb�-argument w postaci binarnej
;; rejestry: ECX - cykl, EDI - maska, ESI - indeks w buforze, EBX - przesuni�cie bufora
;--- odk�adanie na stos
    push    ECX
    push    EDI
    push    ESI
    push    EBX
;---
    mov     ECX,32
    mov     EDI,80000000h
    mov     ESI,0
    mov     EBX,OFFSET bufor
et1:
    mov     BYTE PTR [EBX+ESI],'0'
    test    liczba,EDI
    jz      @F
    inc     BYTE PTR [EBX+ESI]
@@:
    shr     EDI,1
    inc     ESI
    loopnz  et1       
    mov     BYTE PTR [EBX+32],0Dh
    mov     BYTE PTR [EBX+33],0Ah
;--- wy�wietlenie wyniku ---------
    INVOKE WriteConsoleA,hout,OFFSET bufor,34,OFFSET rout,0	
;--- zdejmowanie ze stosu
    pop     EBX
    pop     ESI
    pop     EDI
    pop     ECX
;--- powr�t
    ret     4
DrukBin ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OPTION PROLOGUE: NONE
OPTION EPILOGUE: NONE
arytm PROC C
          ;--- obliczenia Funkcja y=a/b-c+d --- 
          push EBP 
          mov EBP,ESP 
          mov EAX, DWORD PTR [EBP+8] ;zmA 
          mov EDX,0 
          sub EAX, DWORD PTR [EBP+12] ;zmB 
          div DWORD PTR [EBP+16] ;zmC 
          add EAX, DWORD PTR [EBP+20] ;zmD 
          mov ESP,EBP 
          pop EBP 
          ret 
          arytm ENDP 
          
          ;--- obliczenia Funkcja y =a#b*~c|d --- 
          ;mov EAX, zmB 
          ;and EAX, zmC 
          ;mul zmC 
          ;mov ECX, zmD 
          ;not ECX 
          ;add ECX,2 
          ;and EAX,ECX 
          ;or EAX,zmA 
          ;add EAX, zmA 
          ;sub EAX, zmD 
          
          OPTION PROLOGUE: PROLOGUEDEF 
          OPTION EPILOGUE: EPILOGUEDEF
		  logika PROTO STDCALL argA:DWORD,argB:DWORD,argC:DWORD,argD:DWORD
		  ;logika PROC STDCALL argA:DWORD,argB:DWORD,argC:DWORD,argD:DWORD
		  ;logika PROC STDCALL argA:DWORD,argB:DWORD,argC:DWORD,argD:DWORD
;;;;;;;;;;;;;;;;;;;;;;;;;;;
przesuw PROC C arg:DWORD
		INVOKE DrukBin, arg
		shr  arg,4
		INVOKE DrukBin, arg
		rol   arg,2
		INVOKE DrukBin, arg
		ret
przesuw ENDP
END start
_TEXT ENDS