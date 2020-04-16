;�wiczenie 5, Podprogramy i makrodefinicje
.586P
.MODEL flat, stdcall
;-------------
includelib .\lib\user32.lib
includelib .\lib\kernel32.lib
;--- stale z pliku .\include\windows.inc ---
STD_INPUT_HANDLE    equ -10
STD_OUTPUT_HANDLE   equ -11
;--- stale ---
mbuf = 128
SYS_exit        equ 0
;--- makra ---
podajdeskr macro handle, deskrypt 
 push	handle
 call	GetStdHandle
 mov	deskrypt,eax ; deskryptor bufora konsoli
endm

plznaki macro text, bufor
 invoke CharToOemA, addr text, addr bufor
endm

wyswietl macro bufor, rozmiar
 ;--- wy�wietlenie wyniku ---------
 push 0 ; rezerwa, musi by� zero
 push offset rout ;wska�nik na faktyczn� ilo�� wyprowadzonych znak�w
 push rozmiar ; ilo�� znak�w
 push offset bufor ; wska�nik na tekst w buforze
 push hout ; deskryptor buforu konsoli
 call WriteConsoleA ; wywo�anie funkcji WriteConsoleA
endm

nowalinia macro nowa
;--- wy�wietlenie now� linii ---
push	0		        ; rezerwa, musi by� zero
push	OFFSET rout     ; wska�nik na faktyczn� ilo�� wyprowadzonych znak�w 
push	2		        ; ilo�� znak�w
push	OFFSET nowa 	; wska�nik na tekst
push	hout		    ; deskryptor buforu konsoli
call	WriteConsoleA	; wywo�anie funkcji WriteConsoleA
endm

zmienna macro deskkons, bufor, rozmb, frozm, zmienna
 invoke ReadConsoleA, deskkons, addr bufor, rozmb, addr frozm, 0
 push offset bufor
 call ScanInt
 add esp, 4
 mov zmienna, eax
endm

;--- funkcje API Win32 z pliku  .\include\user32.inc ---
CharToOemA proto :dword,:dword

;--- funkcje API Win32 z pliku .\include\kernel32.inc ---
GetStdHandle proto :dword
ReadConsoleA proto 	hinp:dword,adres_bufor:dword,rbuf:dword,adres_rinp:dword,rezerwa:dword
WriteConsoleA proto hout:dword,adres_bufor:dword,rozm:dword,adres_out:dword,rezerwa:dword
ExitProcess proto :dword
wsprintfA proto c :vararg
lstrlenA proto :dword

;--- funkcje
ScanInt proto c :dword
DrukBin proto stdcall :dword
; --- deklaracje podprogram�w
arytm proto c
logika proto stdcall :dword, :dword, :dword, :dword
przesuwanie proto stdcall :dword 

;-------------
_data segment
	hout	DD	?
	hinp	DD	?
	nl DB 0Dh, 0Ah, 0	; nowa linia									;nowa linia
	align	4	; przesuniecie do adresu podzielnego na 4
	naglow DB "Autor aplikacji Grzegorz Makowski i53",0                 ; nag��wek
	align	4												; przesuniecie do adresu podzielnego na 4
	rozmN DD $ - naglow                                                ; ilosc znakow
	align	4												; przesuniecie do adresu podzielnego na 4
	temat DB 0Dh,0Ah,"Podprogramy i makrodefinicje.",0
	align	4	; przesuniecie do adresu podzielnego na 4
	rozmT DD $ - temat
	align	4	; przesuniecie do adresu podzielnego na 4
	naglowA DB 0Dh,0Ah, "Wprowad� 4 parametry fun. f() = A/B-C+D",0  ; nag��wek
	align	4	; przesuniecie do adresu podzielnego na 4
	rozmnaglA DD $ - naglowA 
	align	4
	naglowB DB 0Dh,0Ah, "Wprowad� 4 parametry fun. f() = A#B*~C|D",0  ; nag��wek
	align	4	; przesuniecie do adresu podzielnego na 4
	rozmnaglB DD $ - naglowB
	align	4	; przesuniecie do adresu podzielnego na 4
	zaprA	DB	0Dh,0Ah,"Prosz� wprowadzi� argument a [+Enter]: ",0
	align	4
	rozmA	DD	$ - zaprA	;ilo�� znak�w w tablicy
	zmA	DD	1	; argument a
	zaprB	DB	0Dh,0Ah,"Prosz� wprowadzi� argument b [+Enter]: ",0
	align	4
	rozmB	DD	$ - zaprB	;ilo�� znak�w w tablicy
	zmB	DD	2	; argument b
	zaprC	DB	0Dh,0Ah,"Prosz� wprowadzi� argument c [+Enter]: ",0
	align	4
	rozmC	DD	$ - zaprC	;ilo�� znak�w w tablicy
	zmC	DD	3	; argument c
	align	4
	zaprD	DB	0Dh,0Ah,"Prosz� wprowadzi� argument d [+Enter]: ",0
	align	4
	rozmD	DD	$ - zaprD	;ilo�� znak�w w tablicy
	align	4
	zmD	DD	4	; argument d
	align	4
	zadA DB 0Ah,"Zadanie a) ",0               ; nag��wek zadania A
	align	4	; przesuniecie do adresu podzielnego na 4
	rozmzadA DD $ - zadA
	align	4	; przesuniecie do adresu podzielnego na 4
	zadB DB 0Dh,0Ah,"Zadanie b) ",0               ; nag��wek zadania B
	align	4
	rozmzadB DD $ - zadB
	align	4
	zadC DB 0Dh,0Ah,"Zadanie c) ",0               ; nag��wek zadania C
	align	4
	rozmzadC DD $ - zadC
	align 4
	rot1 DB 0Dh,0Ah,"Liczba binarna: ",0
	align	4
	rozmrot1 DD $ - rot1
	rot2 DB 0Dh,0Ah,"Cykl.prawo CF4: ",0
	align	4
	rozmrot2 DD $ - rot2
	rot3 DB 0Dh,0Ah,"W lewo 2 razy : ",0
	align	4
	rozmrot3 DD $ - rot3
	wzorf	     DB	0Dh,0Ah,"Funkcja f() = %4ld",0
	align	4
	rout	DD	0 ;faktyczna ilo�� wyprowadzonych znak�w
	rinp	DD	0 ;faktyczna ilo�� wprowadzonych znak�w
	rinp2	DD	0 ;faktyczna ilo�� wprowadzonych znak�w
	bufor	DB	mbuf dup(?)
	bufor2	DB	mbuf dup(?)
	rbuf	DD	mbuf
    wyn   DD  0 ; zienna do przechowywania wyniku
    st0   DD  10100110001110000111100000111110b 
_data ends
;------------

_text segment
start:
;--- wywo�anie funkcji GetStdHandle - MAKRO
	podajdeskr STD_OUTPUT_HANDLE, hout
	podajdeskr STD_INPUT_HANDLE, hinp
;--- nag��wek ---------
	plznaki naglow, bufor	; konwersja polskich znak�w - MAKRO
	wyswietl bufor, rozmN
	plznaki temat, bufor	; konwersja polskich znak�w - MAKRO
	wyswietl bufor, rozmT
;--- wy�wietlenie nowej linni---------
	nowalinia nl
;--- zaproszenie A ---------
	plznaki zadA, bufor2
	wyswietl bufor2, rozmzadA
	;--- new line ---------
	nowalinia nl
	plznaki naglowA, bufor ; konwersja polskich znak�w - MAKRO
	wyswietl bufor, rozmnaglA
	plznaki zaprA, bufor
;--- wy�wietlenie zaproszenia A ---
	wyswietl bufor, rozmA   ; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	zmienna hinp, bufor, rbuf, rinp, zmA
;--- zaproszenie B ---------
	plznaki zaprB, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia B ---
	wyswietl bufor, rozmB	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	zmienna hinp, bufor, rbuf, rinp, zmB
;--- zaproszenie C ---------
	plznaki zaprC, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia C ---
	wyswietl bufor, rozmC	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	zmienna hinp, bufor, rbuf, rinp, zmC
;--- zaproszenie D ---------
	plznaki zaprD, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia D ---
	wyswietl bufor, rozmD	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	zmienna hinp, bufor, rbuf, rinp, zmD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- obliczenia Funkcja y =a/b-c+d
      push zmD
      push zmC
      push zmB
      push zmA
      call arytm
      add  esp, 16
      mov  wyn, eax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- wyprowadzenie wyniku oblicze� ---
	invoke wsprintfA,OFFSET bufor,OFFSET wzorf,wyn	; zwraca ilo�� znak�w w buforze 
	mov	rinp, eax	; zapami�tywanie ilo�ci znak�w
	;--- new line ---------
	nowalinia nl
	wyswietl bufor, rinp
;--- wy�wietlenie nowej linni---------
	nowalinia nl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- zaproszenie B ---------
	plznaki zadB, bufor2
	wyswietl bufor2, rozmzadB
	;--- wy�wietlenie nowej linni---------
	nowalinia nl
	plznaki naglowB, bufor ; konwersja polskich znak�w - MAKRO
	wyswietl bufor, rozmnaglB ; wywo�anie funkcji WriteConsoleA
	plznaki zaprA, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia A ---
	wyswietl bufor, rozmA	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	zmienna hinp, bufor, rbuf, rinp, zmA
;--- zaproszenie B ---------
	plznaki zaprB, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia B ---
	wyswietl bufor, rozmB	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	zmienna hinp, bufor, rbuf, rinp, zmB
;--- zaproszenie C ---------
	plznaki zaprC, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia C ---
	wyswietl bufor, rozmC	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	zmienna hinp, bufor, rbuf, rinp, zmC
;--- zaproszenie D ---------
	plznaki zaprD, bufor	; konwersja polskich znak�w
;--- wy�wietlenie zaproszenia D ---
	wyswietl bufor, rozmD	; wywo�anie funkcji WriteConsoleA
;--- czekanie na wprowadzenie znak�w, koniec przez Enter ---
	zmienna hinp, bufor, rbuf, rinp, zmD
	;--- new line ---------
	nowalinia nl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- obliczenia Funkcja y =a#b*~c|d
	invoke logika,zmA,zmB,zmC,zmD
	add   esp,16
    mov   wyn,eax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- wyprowadzenie wyniku oblicze� ---
	invoke wsprintfA,OFFSET bufor,OFFSET wzorf,wyn	; zwraca ilo�� znak�w w buforze 
	mov	rinp2, eax	; zapami�tywanie ilo�ci znak�w
;--- wy�wietlenie wyniku ---------
	wyswietl bufor, rinp2
;--- new line ---------
	nowalinia nl
;----------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;--- zaproszenie C ---------
	plznaki zadC, bufor2
	wyswietl bufor2, rozmzadC
;;;; w prawo CFc4, w lewo 2
;--- new line ---------
	nowalinia nl
	;----------------------------
	invoke przesuwanie, st0
	add	esp, 16
;--- zako�czenie procesu ---------
	invoke ExitProcess, SYS_exit	; wywo�anie funkcji ExitProcess
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;---------Podprogramy  
ScanInt proc c adres
;; funkcja ScanInt przekszta�ca ci�g cyfr do liczby, kt�r� jest zwracana przez eax
;; argument - zako�czony zerem wiersz z cyframi
;; rejestry: ebx - adres wiersza, edx - znak liczby, esi - indeks cyfry w wierszu, edi - tymczasowy
;--- pocz�tek funkcji
;--- odk�adanie na stos
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
;--- przygotowywanie cyklu
	invoke lstrlenA, adres
	mov	edi, eax	;ilo�� znak�w
	mov	ecx, eax	;ilo�� powt�rze� = ilo�� znak�w
	xor	esi, esi	; wyzerowanie esi
	xor	edx, edx	; wyzerowanie edx
	xor	eax, eax	; wyzerowanie eax
	mov	ebx, adres
;--- cykl  
pocz:	cmp	BYTE PTR [ebx+esi], 02Dh	;por�wnanie z kodem '-'
	jne	@F
	mov	edx, 1
	jmp	nast
@@:	cmp	BYTE PTR [ebx+esi], 030h	;por�wnanie z kodem '0'
	jae	@F
	jmp	nast
@@:	cmp	BYTE PTR [ebx+esi], 039h	;por�wnanie z kodem '9'
	jbe	@F
	jmp	nast
;----
@@:	push	edx	; do edx procesor mo�e zapisa� wynik mno�enia 
	mov	edi, 10
	mul	edi		;mno�enie eax * edi
	mov	edi, eax	; tymczasowo z eax do edi
	xor	eax, eax	;zerowani eax
	mov	AL, BYTE PTR [ebx+esi]
	sub	AL, 030h	; korekta: cyfra = kod znaku - kod '0'	
	add	eax, edi	; dodanie cyfry
	pop	edx
nast:	inc	esi
      dec   ecx   
      jz    @F
      jmp   pocz
;--- wynik
@@:	or	edx, edx	;analiza znacznika edx
	jz	@F
	neg	eax
@@:	
;--- zdejmowanie ze stosu
	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
;--- powr�t
	ret
ScanInt	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrukBin proc stdcall liczba:dword
;; funkcja DrukBin wyswietla liczb�-argument w postaci binarnej
;; rejestry: ecx - cykl, edi - maska, esi - indeks w buforze, ebx - przesuni�cie bufora
;--- odk�adanie na stos
    push    ecx
    push    edi
    push    esi
    push    ebx
;---
    mov     ecx,32
    mov     edi,80000000h
    mov     esi,0
    mov     ebx,OFFSET bufor
et1:
    mov     BYTE PTR [ebx+esi],'0'
    test    liczba,edi
    jz      @F
    inc     BYTE PTR [ebx+esi]
@@:
    shr     edi,1
    inc     esi
    loopnz  et1       
    mov     BYTE PTR [ebx+32],0Dh
    mov     BYTE PTR [ebx+33],0Ah
;--- wy�wietlenie wyniku ---------
    invoke WriteConsoleA,hout,OFFSET bufor,34,OFFSET rout,0	
;--- zdejmowanie ze stosu
    pop     ebx
    pop     esi
    pop     edi
    pop     ecx
;--- powr�t
    ret     8
DrukBin ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
option prologue: none
option epilogue: none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
arytm proc c
;--- obliczenia A / B - C + D 
	push ebp 
	mov ebp, esp 
	mov edx, 0					; zerowanie edx
	mov eax, 0          		; zerowanie eax
	mov eax, dword ptr [ebp+8] 	; zm A do eax
	div dword ptr [ebp+12]		; dzielenie  A / B wynik w eax
	mov edx, dword ptr [ebp+16] ; zmienna C do edx
	sub eax, edx				; odejumjemy od wyniku dzielenia C, wynik w eax
	add eax, dword ptr [ebp+20]	; dodajemy do eax zmienn� D, wynik w eax
	mov edx, 0          		; sprz�tanie, zerowanie edx
	mov esp,ebp 
	pop ebp 
	ret 8 ;omini�cie ramki stosu z parametrami 
arytm endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
option prologue: prologuedef
option epilogue: epiloguedef
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
logika proc stdcall argA:dword,argB:dword,argC:dword,argD:dword       
;--- obliczenia a # b * ~c | d
;--- kolejno�� ~ * | #
	push ebp ;przechowywanie ebp na stosie
	mov ebp, esp ;zamiana ebp
	mov eax, 0 			; zerowanie eax
	mov eax, zmC		; c do eax
	not eax				; negacja bitowa eax (c)
	add eax, 2			; korekta wyniku negacji
	and eax, zmB		; mno�enie logiczne b * ~c
	or  eax, zmD			; wynik mno�enia logicznego or (|) d
	xor eax, zmA
	mov esp, ebp ;zamiana esp
	pop ebp ;przewr�cenie ebp ze stosu
	ret 8 ;omini�cie ramki stosu z parametrami 
logika endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
przesuwanie proc stdcall arg:dword
	push ebp
	mov ebp, esp
	plznaki rot1, bufor
	wyswietl bufor, rozmrot1
	invoke DrukBin, st0
	mov eax, 0
	mov eax, st0
	rcr eax, 4
	mov st0, eax
	plznaki rot2, bufor
	wyswietl bufor, rozmrot2
	invoke DrukBin, st0
	mov eax, 0
	mov eax, st0
	rol eax, 2
	mov st0, eax
	plznaki rot3, bufor
	wyswietl bufor, rozmrot3
	invoke DrukBin, st0
	mov esp, ebp ;zamiana esp
	pop ebp ;przewr�cenie ebp ze stosu
	ret 8 ;omini�cie ramki stosu z parametrami
przesuwanie endp
end start
_text ends