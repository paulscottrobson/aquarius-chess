//
//	This file is automatically generated
//
case 0x00: /**** $00:nop ****/
	{};
	cycles += 11;break;

case 0x01: /**** $01:ld bc,$2 ****/
	temp16 = FETCH16(); SETBC(temp16);;
	cycles += 11;break;

case 0x02: /**** $02:ld (bc),a ****/
	WRITE8(BC(),A);
	cycles += 11;break;

case 0x03: /**** $03:inc bc ****/
	INCBC();
	cycles += 11;break;

case 0x04: /**** $04:inc b ****/
	INC8(B);
	cycles += 11;break;

case 0x05: /**** $05:dec b ****/
	DEC8(B);
	cycles += 11;break;

case 0x06: /**** $06:ld b,$1 ****/
	B = FETCH8();
	cycles += 11;break;

case 0x07: /**** $07:rlca ****/
	SETCARRY((A & 0x80) != 0); A = (A << 1) | (A >> 7); SETHALFCARRY(0);SETNFLAG(0);;
	cycles += 11;break;

case 0x08: /**** $08:ex af,af' ****/
	temp16 = AF();SETAF(AFalt);AFalt = temp16;;
	cycles += 11;break;

case 0x09: /**** $09:add hl,bc ****/
	temp16 = add16(HL(),BC()); SETHL(temp16);;
	cycles += 11;break;

case 0x0a: /**** $0a:ld a,(bc) ****/
	A = READ8(BC());
	cycles += 11;break;

case 0x0b: /**** $0b:dec bc ****/
	DECBC();
	cycles += 11;break;

case 0x0c: /**** $0c:inc c ****/
	INC8(C);
	cycles += 11;break;

case 0x0d: /**** $0d:dec c ****/
	DEC8(C);
	cycles += 11;break;

case 0x0e: /**** $0e:ld c,$1 ****/
	C = FETCH8();
	cycles += 11;break;

case 0x0f: /**** $0f:rrca ****/
	SETCARRY((A & 0x01) != 0); A = (A >> 1) | (A << 7); SETHALFCARRY(0);SETNFLAG(0);;
	cycles += 11;break;

case 0x10: /**** $10:djnz $o ****/
	B--;JUMPR(B != 0);
	cycles += 11;break;

case 0x11: /**** $11:ld de,$2 ****/
	temp16 = FETCH16(); SETDE(temp16);;
	cycles += 11;break;

case 0x12: /**** $12:ld (de),a ****/
	WRITE8(DE(),A);
	cycles += 11;break;

case 0x13: /**** $13:inc de ****/
	INCDE();
	cycles += 11;break;

case 0x14: /**** $14:inc d ****/
	INC8(D);
	cycles += 11;break;

case 0x15: /**** $15:dec d ****/
	DEC8(D);
	cycles += 11;break;

case 0x16: /**** $16:ld d,$1 ****/
	D = FETCH8();
	cycles += 11;break;

case 0x17: /**** $17:rla ****/
	temp16 = (A << 1) | (c_Flag ? 1 : 0); SETCARRY((A & 0x80) != 0); A = temp16; SETHALFCARRY(0);SETNFLAG(0);;
	cycles += 11;break;

case 0x18: /**** $18:jr $o ****/
	JUMPR(1);
	cycles += 11;break;

case 0x19: /**** $19:add hl,de ****/
	temp16 = add16(HL(),DE()); SETHL(temp16);;
	cycles += 11;break;

case 0x1a: /**** $1a:ld a,(de) ****/
	A = READ8(DE());
	cycles += 11;break;

case 0x1b: /**** $1b:dec de ****/
	DECDE();
	cycles += 11;break;

case 0x1c: /**** $1c:inc e ****/
	INC8(E);
	cycles += 11;break;

case 0x1d: /**** $1d:dec e ****/
	DEC8(E);
	cycles += 11;break;

case 0x1e: /**** $1e:ld e,$1 ****/
	E = FETCH8();
	cycles += 11;break;

case 0x1f: /**** $1f:rra ****/
	temp16 = A | (c_Flag ? 0x100 : 0); SETCARRY((A & 0x01) != 0); A = temp16 >> 1; SETHALFCARRY(0);SETNFLAG(0);;
	cycles += 11;break;

case 0x20: /**** $20:jr nz,$o ****/
	JUMPR(TESTNZ());
	cycles += 11;break;

case 0x21: /**** $21:ld hl,$2 ****/
	temp16 = FETCH16(); SETHL(temp16);;
	cycles += 11;break;

case 0x22: /**** $22:ld ($2),hl ****/
	temp16 = FETCH16();WRITE16(temp16,HL());
	cycles += 11;break;

case 0x23: /**** $23:inc hl ****/
	INCHL();
	cycles += 11;break;

case 0x24: /**** $24:inc h ****/
	INC8(H);
	cycles += 11;break;

case 0x25: /**** $25:dec h ****/
	DEC8(H);
	cycles += 11;break;

case 0x26: /**** $26:ld h,$1 ****/
	H = FETCH8();
	cycles += 11;break;

case 0x27: /**** $27:daa ****/
	DAA();;
	cycles += 11;break;

case 0x28: /**** $28:jr z,$o ****/
	JUMPR(TESTZ());
	cycles += 11;break;

case 0x29: /**** $29:add hl,hl ****/
	temp16 = add16(HL(),HL()); SETHL(temp16);;
	cycles += 11;break;

case 0x2a: /**** $2a:ld hl,($2) ****/
	temp16 = FETCH16();SETHL(READ16(temp16));
	cycles += 11;break;

case 0x2b: /**** $2b:dec hl ****/
	DECHL();
	cycles += 11;break;

case 0x2c: /**** $2c:inc l ****/
	INC8(L);
	cycles += 11;break;

case 0x2d: /**** $2d:dec l ****/
	DEC8(L);
	cycles += 11;break;

case 0x2e: /**** $2e:ld l,$1 ****/
	L = FETCH8();
	cycles += 11;break;

case 0x2f: /**** $2f:cpl ****/
	A = A ^ 0xFF; SETHALFCARRY(1); SETNFLAG(1);;
	cycles += 11;break;

case 0x30: /**** $30:jr nc,$o ****/
	JUMPR(TESTNC());
	cycles += 11;break;

case 0x31: /**** $31:ld sp,$2 ****/
	temp16 = FETCH16(); SETSP(temp16);;
	cycles += 11;break;

case 0x32: /**** $32:ld ($2),a ****/
	WRITE8(FETCH16(),A);
	cycles += 11;break;

case 0x33: /**** $33:inc sp ****/
	INCSP();
	cycles += 11;break;

case 0x34: /**** $34:inc (hl) ****/
	temp8 = READ8(HL()); INC8(temp8); WRITE8(HL(),temp8);;
	cycles += 11;break;

case 0x35: /**** $35:dec (hl) ****/
	temp8 = READ8(HL()); DEC8(temp8); WRITE8(HL(),temp8);;
	cycles += 11;break;

case 0x36: /**** $36:ld (hl),$1 ****/
	WRITE8(HL(),FETCH8());
	cycles += 11;break;

case 0x37: /**** $37:scf ****/
	SETCARRY(1); SETHALFCARRY(0); SETNFLAG(0);;
	cycles += 11;break;

case 0x38: /**** $38:jr c,$o ****/
	JUMPR(TESTC());
	cycles += 11;break;

case 0x39: /**** $39:add hl,sp ****/
	temp16 = add16(HL(),SP()); SETHL(temp16);;
	cycles += 11;break;

case 0x3a: /**** $3a:ld a,($2) ****/
	A = READ8(FETCH16());;
	cycles += 11;break;

case 0x3b: /**** $3b:dec sp ****/
	DECSP();
	cycles += 11;break;

case 0x3c: /**** $3c:inc a ****/
	INC8(A);
	cycles += 11;break;

case 0x3d: /**** $3d:dec a ****/
	DEC8(A);
	cycles += 11;break;

case 0x3e: /**** $3e:ld a,$1 ****/
	A = FETCH8();
	cycles += 11;break;

case 0x3f: /**** $3f:ccf ****/
	SETHALFCARRY(c_Flag); SETCARRY(c_Flag == 0); SETNFLAG(0);;
	cycles += 11;break;

case 0x40: /**** $40:ld b,b ****/
	B = B;
	cycles += 11;break;

case 0x41: /**** $41:ld b,c ****/
	B = C;
	cycles += 11;break;

case 0x42: /**** $42:ld b,d ****/
	B = D;
	cycles += 11;break;

case 0x43: /**** $43:ld b,e ****/
	B = E;
	cycles += 11;break;

case 0x44: /**** $44:ld b,h ****/
	B = H;
	cycles += 11;break;

case 0x45: /**** $45:ld b,l ****/
	B = L;
	cycles += 11;break;

case 0x46: /**** $46:ld b,(hl) ****/
	B = READ8(HL());
	cycles += 11;break;

case 0x47: /**** $47:ld b,a ****/
	B = A;
	cycles += 11;break;

case 0x48: /**** $48:ld c,b ****/
	C = B;
	cycles += 11;break;

case 0x49: /**** $49:ld c,c ****/
	C = C;
	cycles += 11;break;

case 0x4a: /**** $4a:ld c,d ****/
	C = D;
	cycles += 11;break;

case 0x4b: /**** $4b:ld c,e ****/
	C = E;
	cycles += 11;break;

case 0x4c: /**** $4c:ld c,h ****/
	C = H;
	cycles += 11;break;

case 0x4d: /**** $4d:ld c,l ****/
	C = L;
	cycles += 11;break;

case 0x4e: /**** $4e:ld c,(hl) ****/
	C = READ8(HL());
	cycles += 11;break;

case 0x4f: /**** $4f:ld c,a ****/
	C = A;
	cycles += 11;break;

case 0x50: /**** $50:ld d,b ****/
	D = B;
	cycles += 11;break;

case 0x51: /**** $51:ld d,c ****/
	D = C;
	cycles += 11;break;

case 0x52: /**** $52:ld d,d ****/
	D = D;
	cycles += 11;break;

case 0x53: /**** $53:ld d,e ****/
	D = E;
	cycles += 11;break;

case 0x54: /**** $54:ld d,h ****/
	D = H;
	cycles += 11;break;

case 0x55: /**** $55:ld d,l ****/
	D = L;
	cycles += 11;break;

case 0x56: /**** $56:ld d,(hl) ****/
	D = READ8(HL());
	cycles += 11;break;

case 0x57: /**** $57:ld d,a ****/
	D = A;
	cycles += 11;break;

case 0x58: /**** $58:ld e,b ****/
	E = B;
	cycles += 11;break;

case 0x59: /**** $59:ld e,c ****/
	E = C;
	cycles += 11;break;

case 0x5a: /**** $5a:ld e,d ****/
	E = D;
	cycles += 11;break;

case 0x5b: /**** $5b:ld e,e ****/
	E = E;
	cycles += 11;break;

case 0x5c: /**** $5c:ld e,h ****/
	E = H;
	cycles += 11;break;

case 0x5d: /**** $5d:ld e,l ****/
	E = L;
	cycles += 11;break;

case 0x5e: /**** $5e:ld e,(hl) ****/
	E = READ8(HL());
	cycles += 11;break;

case 0x5f: /**** $5f:ld e,a ****/
	E = A;
	cycles += 11;break;

case 0x60: /**** $60:ld h,b ****/
	H = B;
	cycles += 11;break;

case 0x61: /**** $61:ld h,c ****/
	H = C;
	cycles += 11;break;

case 0x62: /**** $62:ld h,d ****/
	H = D;
	cycles += 11;break;

case 0x63: /**** $63:ld h,e ****/
	H = E;
	cycles += 11;break;

case 0x64: /**** $64:ld h,h ****/
	H = H;
	cycles += 11;break;

case 0x65: /**** $65:ld h,l ****/
	H = L;
	cycles += 11;break;

case 0x66: /**** $66:ld h,(hl) ****/
	H = READ8(HL());
	cycles += 11;break;

case 0x67: /**** $67:ld h,a ****/
	H = A;
	cycles += 11;break;

case 0x68: /**** $68:ld l,b ****/
	L = B;
	cycles += 11;break;

case 0x69: /**** $69:ld l,c ****/
	L = C;
	cycles += 11;break;

case 0x6a: /**** $6a:ld l,d ****/
	L = D;
	cycles += 11;break;

case 0x6b: /**** $6b:ld l,e ****/
	L = E;
	cycles += 11;break;

case 0x6c: /**** $6c:ld l,h ****/
	L = H;
	cycles += 11;break;

case 0x6d: /**** $6d:ld l,l ****/
	L = L;
	cycles += 11;break;

case 0x6e: /**** $6e:ld l,(hl) ****/
	L = READ8(HL());
	cycles += 11;break;

case 0x6f: /**** $6f:ld l,a ****/
	L = A;
	cycles += 11;break;

case 0x70: /**** $70:ld (hl),b ****/
	WRITE8(HL(),B);
	cycles += 11;break;

case 0x71: /**** $71:ld (hl),c ****/
	WRITE8(HL(),C);
	cycles += 11;break;

case 0x72: /**** $72:ld (hl),d ****/
	WRITE8(HL(),D);
	cycles += 11;break;

case 0x73: /**** $73:ld (hl),e ****/
	WRITE8(HL(),E);
	cycles += 11;break;

case 0x74: /**** $74:ld (hl),h ****/
	WRITE8(HL(),H);
	cycles += 11;break;

case 0x75: /**** $75:ld (hl),l ****/
	WRITE8(HL(),L);
	cycles += 11;break;

case 0x76: /**** $76:halt ****/
	{};
	cycles += 11;break;

case 0x77: /**** $77:ld (hl),a ****/
	WRITE8(HL(),A);
	cycles += 11;break;

case 0x78: /**** $78:ld a,b ****/
	A = B;
	cycles += 11;break;

case 0x79: /**** $79:ld a,c ****/
	A = C;
	cycles += 11;break;

case 0x7a: /**** $7a:ld a,d ****/
	A = D;
	cycles += 11;break;

case 0x7b: /**** $7b:ld a,e ****/
	A = E;
	cycles += 11;break;

case 0x7c: /**** $7c:ld a,h ****/
	A = H;
	cycles += 11;break;

case 0x7d: /**** $7d:ld a,l ****/
	A = L;
	cycles += 11;break;

case 0x7e: /**** $7e:ld a,(hl) ****/
	A = READ8(HL());
	cycles += 11;break;

case 0x7f: /**** $7f:ld a,a ****/
	A = A;
	cycles += 11;break;

case 0x80: /**** $80:add b ****/
	ALUADD(B);
	cycles += 11;break;

case 0x81: /**** $81:add c ****/
	ALUADD(C);
	cycles += 11;break;

case 0x82: /**** $82:add d ****/
	ALUADD(D);
	cycles += 11;break;

case 0x83: /**** $83:add e ****/
	ALUADD(E);
	cycles += 11;break;

case 0x84: /**** $84:add h ****/
	ALUADD(H);
	cycles += 11;break;

case 0x85: /**** $85:add l ****/
	ALUADD(L);
	cycles += 11;break;

case 0x86: /**** $86:add (hl) ****/
	ALUADD(READ8(HL()));
	cycles += 11;break;

case 0x87: /**** $87:add a ****/
	ALUADD(A);
	cycles += 11;break;

case 0x88: /**** $88:adc b ****/
	ALUADC(B);
	cycles += 11;break;

case 0x89: /**** $89:adc c ****/
	ALUADC(C);
	cycles += 11;break;

case 0x8a: /**** $8a:adc d ****/
	ALUADC(D);
	cycles += 11;break;

case 0x8b: /**** $8b:adc e ****/
	ALUADC(E);
	cycles += 11;break;

case 0x8c: /**** $8c:adc h ****/
	ALUADC(H);
	cycles += 11;break;

case 0x8d: /**** $8d:adc l ****/
	ALUADC(L);
	cycles += 11;break;

case 0x8e: /**** $8e:adc (hl) ****/
	ALUADC(READ8(HL()));
	cycles += 11;break;

case 0x8f: /**** $8f:adc a ****/
	ALUADC(A);
	cycles += 11;break;

case 0x90: /**** $90:sub b ****/
	ALUSUB(B);
	cycles += 11;break;

case 0x91: /**** $91:sub c ****/
	ALUSUB(C);
	cycles += 11;break;

case 0x92: /**** $92:sub d ****/
	ALUSUB(D);
	cycles += 11;break;

case 0x93: /**** $93:sub e ****/
	ALUSUB(E);
	cycles += 11;break;

case 0x94: /**** $94:sub h ****/
	ALUSUB(H);
	cycles += 11;break;

case 0x95: /**** $95:sub l ****/
	ALUSUB(L);
	cycles += 11;break;

case 0x96: /**** $96:sub (hl) ****/
	ALUSUB(READ8(HL()));
	cycles += 11;break;

case 0x97: /**** $97:sub a ****/
	ALUSUB(A);
	cycles += 11;break;

case 0x98: /**** $98:sbc b ****/
	ALUSBC(B);
	cycles += 11;break;

case 0x99: /**** $99:sbc c ****/
	ALUSBC(C);
	cycles += 11;break;

case 0x9a: /**** $9a:sbc d ****/
	ALUSBC(D);
	cycles += 11;break;

case 0x9b: /**** $9b:sbc e ****/
	ALUSBC(E);
	cycles += 11;break;

case 0x9c: /**** $9c:sbc h ****/
	ALUSBC(H);
	cycles += 11;break;

case 0x9d: /**** $9d:sbc l ****/
	ALUSBC(L);
	cycles += 11;break;

case 0x9e: /**** $9e:sbc (hl) ****/
	ALUSBC(READ8(HL()));
	cycles += 11;break;

case 0x9f: /**** $9f:sbc a ****/
	ALUSBC(A);
	cycles += 11;break;

case 0xa0: /**** $a0:and b ****/
	ALUAND(B);
	cycles += 11;break;

case 0xa1: /**** $a1:and c ****/
	ALUAND(C);
	cycles += 11;break;

case 0xa2: /**** $a2:and d ****/
	ALUAND(D);
	cycles += 11;break;

case 0xa3: /**** $a3:and e ****/
	ALUAND(E);
	cycles += 11;break;

case 0xa4: /**** $a4:and h ****/
	ALUAND(H);
	cycles += 11;break;

case 0xa5: /**** $a5:and l ****/
	ALUAND(L);
	cycles += 11;break;

case 0xa6: /**** $a6:and (hl) ****/
	ALUAND(READ8(HL()));
	cycles += 11;break;

case 0xa7: /**** $a7:and a ****/
	ALUAND(A);
	cycles += 11;break;

case 0xa8: /**** $a8:xor b ****/
	ALUXOR(B);
	cycles += 11;break;

case 0xa9: /**** $a9:xor c ****/
	ALUXOR(C);
	cycles += 11;break;

case 0xaa: /**** $aa:xor d ****/
	ALUXOR(D);
	cycles += 11;break;

case 0xab: /**** $ab:xor e ****/
	ALUXOR(E);
	cycles += 11;break;

case 0xac: /**** $ac:xor h ****/
	ALUXOR(H);
	cycles += 11;break;

case 0xad: /**** $ad:xor l ****/
	ALUXOR(L);
	cycles += 11;break;

case 0xae: /**** $ae:xor (hl) ****/
	ALUXOR(READ8(HL()));
	cycles += 11;break;

case 0xaf: /**** $af:xor a ****/
	ALUXOR(A);
	cycles += 11;break;

case 0xb0: /**** $b0:or b ****/
	ALUOR(B);
	cycles += 11;break;

case 0xb1: /**** $b1:or c ****/
	ALUOR(C);
	cycles += 11;break;

case 0xb2: /**** $b2:or d ****/
	ALUOR(D);
	cycles += 11;break;

case 0xb3: /**** $b3:or e ****/
	ALUOR(E);
	cycles += 11;break;

case 0xb4: /**** $b4:or h ****/
	ALUOR(H);
	cycles += 11;break;

case 0xb5: /**** $b5:or l ****/
	ALUOR(L);
	cycles += 11;break;

case 0xb6: /**** $b6:or (hl) ****/
	ALUOR(READ8(HL()));
	cycles += 11;break;

case 0xb7: /**** $b7:or a ****/
	ALUOR(A);
	cycles += 11;break;

case 0xb8: /**** $b8:cp b ****/
	ALUCP(B);
	cycles += 11;break;

case 0xb9: /**** $b9:cp c ****/
	ALUCP(C);
	cycles += 11;break;

case 0xba: /**** $ba:cp d ****/
	ALUCP(D);
	cycles += 11;break;

case 0xbb: /**** $bb:cp e ****/
	ALUCP(E);
	cycles += 11;break;

case 0xbc: /**** $bc:cp h ****/
	ALUCP(H);
	cycles += 11;break;

case 0xbd: /**** $bd:cp l ****/
	ALUCP(L);
	cycles += 11;break;

case 0xbe: /**** $be:cp (hl) ****/
	ALUCP(READ8(HL()));
	cycles += 11;break;

case 0xbf: /**** $bf:cp a ****/
	ALUCP(A);
	cycles += 11;break;

case 0xc0: /**** $c0:ret nz ****/
	RETURN(TESTNZ());
	cycles += 11;break;

case 0xc1: /**** $c1:pop bc ****/
	temp16 = POP();SETBC(temp16);
	cycles += 11;break;

case 0xc2: /**** $c2:jp nz,$2 ****/
	JUMP(TESTNZ());
	cycles += 11;break;

case 0xc3: /**** $c3:jp $2 ****/
	JUMP(1);
	cycles += 11;break;

case 0xc4: /**** $c4:call nz,$2 ****/
	CALL(TESTNZ());
	cycles += 11;break;

case 0xc5: /**** $c5:push bc ****/
	PUSH(BC());
	cycles += 11;break;

case 0xc6: /**** $c6:add $1 ****/
	ALUADD(FETCH8());
	cycles += 11;break;

case 0xc7: /**** $c7:rst 00_h ****/
	PUSH(PC);PC = 0x00;;
	cycles += 11;break;

case 0xc8: /**** $c8:ret z ****/
	RETURN(TESTZ());
	cycles += 11;break;

case 0xc9: /**** $c9:ret ****/
	RETURN(1);
	cycles += 11;break;

case 0xca: /**** $ca:jp z,$2 ****/
	JUMP(TESTZ());
	cycles += 11;break;

case 0xcb: /**** $cb:[cb] ****/
	ExecuteCBGroup();;
	cycles += 11;break;

case 0xcc: /**** $cc:call z,$2 ****/
	CALL(TESTZ());
	cycles += 11;break;

case 0xcd: /**** $cd:call $2 ****/
	CALL(1);
	cycles += 11;break;

case 0xce: /**** $ce:adc $1 ****/
	ALUADC(FETCH8());
	cycles += 11;break;

case 0xcf: /**** $cf:rst 08_h ****/
	PUSH(PC);PC = 0x08;;
	cycles += 11;break;

case 0xd0: /**** $d0:ret nc ****/
	RETURN(TESTNC());
	cycles += 11;break;

case 0xd1: /**** $d1:pop de ****/
	temp16 = POP();SETDE(temp16);
	cycles += 11;break;

case 0xd2: /**** $d2:jp nc,$2 ****/
	JUMP(TESTNC());
	cycles += 11;break;

case 0xd3: /**** $d3:out ($1),a ****/
	temp8 = FETCH8(); OUTPORT(temp8,A);
	cycles += 11;break;

case 0xd4: /**** $d4:call nc,$2 ****/
	CALL(TESTNC());
	cycles += 11;break;

case 0xd5: /**** $d5:push de ****/
	PUSH(DE());
	cycles += 11;break;

case 0xd6: /**** $d6:sub $1 ****/
	ALUSUB(FETCH8());
	cycles += 11;break;

case 0xd7: /**** $d7:rst 10_h ****/
	PUSH(PC);PC = 0x10;;
	cycles += 11;break;

case 0xd8: /**** $d8:ret c ****/
	RETURN(TESTC());
	cycles += 11;break;

case 0xd9: /**** $d9:exx ****/
	temp16 = BC();SETBC(BCalt);BCalt = temp16; temp16 = DE();SETDE(DEalt);DEalt = temp16; temp16 = HL();SETHL(HLalt);HLalt = temp16;;
	cycles += 11;break;

case 0xda: /**** $da:jp c,$2 ****/
	JUMP(TESTC());
	cycles += 11;break;

case 0xdb: /**** $db:in a,($1) ****/
	temp8 = FETCH8(); A = INPORT((A << 8)|temp8);
	cycles += 11;break;

case 0xdc: /**** $dc:call c,$2 ****/
	CALL(TESTC());
	cycles += 11;break;

case 0xdd: /**** $dd:[ix] ****/
	pIXY = &IX; ExecuteDDGroup();;
	cycles += 11;break;

case 0xde: /**** $de:sbc $1 ****/
	ALUSBC(FETCH8());
	cycles += 11;break;

case 0xdf: /**** $df:rst 18_h ****/
	PUSH(PC);PC = 0x18;;
	cycles += 11;break;

case 0xe0: /**** $e0:ret po ****/
	RETURN(TESTPO());
	cycles += 11;break;

case 0xe1: /**** $e1:pop hl ****/
	temp16 = POP();SETHL(temp16);
	cycles += 11;break;

case 0xe2: /**** $e2:jp po,$2 ****/
	JUMP(TESTPO());
	cycles += 11;break;

case 0xe3: /**** $e3:ex (sp),hl ****/
	temp16 = READ16(SP);temp16a = HL(); WRITE16(SP,temp16a);SETHL(temp16);;
	cycles += 11;break;

case 0xe4: /**** $e4:call po,$2 ****/
	CALL(TESTPO());
	cycles += 11;break;

case 0xe5: /**** $e5:push hl ****/
	PUSH(HL());
	cycles += 11;break;

case 0xe6: /**** $e6:and $1 ****/
	ALUAND(FETCH8());
	cycles += 11;break;

case 0xe7: /**** $e7:rst 20_h ****/
	PUSH(PC);PC = 0x20;;
	cycles += 11;break;

case 0xe8: /**** $e8:ret pe ****/
	RETURN(TESTPE());
	cycles += 11;break;

case 0xe9: /**** $e9:jp (hl) ****/
	PC = HL();
	cycles += 11;break;

case 0xea: /**** $ea:jp pe,$2 ****/
	JUMP(TESTPE());
	cycles += 11;break;

case 0xeb: /**** $eb:ex de,hl ****/
	temp16 = DE();temp16a = HL(); SETDE(temp16a);SETHL(temp16);;
	cycles += 11;break;

case 0xec: /**** $ec:call pe,$2 ****/
	CALL(TESTPE());
	cycles += 11;break;

case 0xed: /**** $ed:[ed] ****/
	ExecuteEDGroup();;
	cycles += 11;break;

case 0xee: /**** $ee:xor $1 ****/
	ALUXOR(FETCH8());
	cycles += 11;break;

case 0xef: /**** $ef:rst 28_h ****/
	PUSH(PC);PC = 0x28;;
	cycles += 11;break;

case 0xf0: /**** $f0:ret p ****/
	RETURN(TESTP());
	cycles += 11;break;

case 0xf1: /**** $f1:pop af ****/
	temp16 = POP();SETAF(temp16);
	cycles += 11;break;

case 0xf2: /**** $f2:jp p,$2 ****/
	JUMP(TESTP());
	cycles += 11;break;

case 0xf3: /**** $f3:di ****/
	intEnabled = 0;
	cycles += 11;break;

case 0xf4: /**** $f4:call p,$2 ****/
	CALL(TESTP());
	cycles += 11;break;

case 0xf5: /**** $f5:push af ****/
	PUSH(AF());
	cycles += 11;break;

case 0xf6: /**** $f6:or $1 ****/
	ALUOR(FETCH8());
	cycles += 11;break;

case 0xf7: /**** $f7:rst 30_h ****/
	PUSH(PC);PC = 0x30;;
	cycles += 11;break;

case 0xf8: /**** $f8:ret m ****/
	RETURN(TESTM());
	cycles += 11;break;

case 0xf9: /**** $f9:ld sp,hl ****/
	SETSP(HL());
	cycles += 11;break;

case 0xfa: /**** $fa:jp m,$2 ****/
	JUMP(TESTM());
	cycles += 11;break;

case 0xfb: /**** $fb:ei ****/
	intEnabled = 1;
	cycles += 11;break;

case 0xfc: /**** $fc:call m,$2 ****/
	CALL(TESTM());
	cycles += 11;break;

case 0xfd: /**** $fd:[iy] ****/
	pIXY = &IY; ExecuteDDGroup();;
	cycles += 11;break;

case 0xfe: /**** $fe:cp $1 ****/
	ALUCP(FETCH8());
	cycles += 11;break;

case 0xff: /**** $ff:rst 38_h ****/
	PUSH(PC);PC = 0x38;;
	cycles += 11;break;


