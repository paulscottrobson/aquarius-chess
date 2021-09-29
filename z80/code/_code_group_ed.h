//
//	This file is automatically generated
//
case 0x40: /**** $40:in b,(c) ****/
	B = INPORT(C); SETNZ(B); SETHALFCARRY(0); SETPARITY(B); SETNFLAG(0);;
	break;

case 0x41: /**** $41:out (c),b ****/
	OUTPORT(C,B);
	break;

case 0x42: /**** $42:sbc hl,bc ****/
	temp16 = sbc16(HL(),BC()); SETHL(temp16);;
	break;

case 0x43: /**** $43:ld ($2),bc ****/
	temp16 = FETCH16();WRITE16(temp16,BC());
	break;

case 0x44: /**** $44:neg ****/
	temp8 = A;A = 0; ALUSUB(temp8);;
	break;

case 0x45: /**** $45:retn ****/
	RETURN(1);
	break;

case 0x46: /**** $46:im0 ****/
	{};
	break;

case 0x47: /**** $47:ld i,a ****/
	I = A;
	break;

case 0x48: /**** $48:in c,(c) ****/
	C = INPORT(C); SETNZ(C); SETHALFCARRY(0); SETPARITY(C); SETNFLAG(0);;
	break;

case 0x49: /**** $49:out (c),c ****/
	OUTPORT(C,C);
	break;

case 0x4a: /**** $4a:adc hl,bc ****/
	temp16 = adc16(HL(),BC()); SETHL(temp16);;
	break;

case 0x4b: /**** $4b:ld bc,($2) ****/
	temp16 = FETCH16();SETBC(READ16(temp16));
	break;

case 0x4d: /**** $4d:reti ****/
	RETURN(1);
	break;

case 0x4f: /**** $4f:ld r,a ****/
	R = A;
	break;

case 0x50: /**** $50:in d,(c) ****/
	D = INPORT(C); SETNZ(D); SETHALFCARRY(0); SETPARITY(D); SETNFLAG(0);;
	break;

case 0x51: /**** $51:out (c),d ****/
	OUTPORT(C,D);
	break;

case 0x52: /**** $52:sbc hl,de ****/
	temp16 = sbc16(HL(),DE()); SETHL(temp16);;
	break;

case 0x53: /**** $53:ld ($2),de ****/
	temp16 = FETCH16();WRITE16(temp16,DE());
	break;

case 0x56: /**** $56:im1 ****/
	{};
	break;

case 0x57: /**** $57:ld a,i ****/
	A = I; SETNZ(A); SETPARITY(A); SETHALFCARRY(0); SETNFLAG(0);;
	break;

case 0x58: /**** $58:in e,(c) ****/
	E = INPORT(C); SETNZ(E); SETHALFCARRY(0); SETPARITY(E); SETNFLAG(0);;
	break;

case 0x59: /**** $59:out (c),e ****/
	OUTPORT(C,E);
	break;

case 0x5a: /**** $5a:adc hl,de ****/
	temp16 = adc16(HL(),DE()); SETHL(temp16);;
	break;

case 0x5b: /**** $5b:ld de,($2) ****/
	temp16 = FETCH16();SETDE(READ16(temp16));
	break;

case 0x5e: /**** $5e:im2 ****/
	{};
	break;

case 0x5f: /**** $5f:ld a,r ****/
	A = R; SETNZ(A); SETPARITY(A); SETHALFCARRY(0); SETNFLAG(0);;
	break;

case 0x60: /**** $60:in h,(c) ****/
	H = INPORT(C); SETNZ(H); SETHALFCARRY(0); SETPARITY(H); SETNFLAG(0);;
	break;

case 0x61: /**** $61:out (c),h ****/
	OUTPORT(C,H);
	break;

case 0x62: /**** $62:sbc hl,hl ****/
	temp16 = sbc16(HL(),HL()); SETHL(temp16);;
	break;

case 0x63: /**** $63:ld ($2),hl ****/
	temp16 = FETCH16();WRITE16(temp16,HL());
	break;

case 0x68: /**** $68:in l,(c) ****/
	L = INPORT(C); SETNZ(L); SETHALFCARRY(0); SETPARITY(L); SETNFLAG(0);;
	break;

case 0x69: /**** $69:out (c),l ****/
	OUTPORT(C,L);
	break;

case 0x6a: /**** $6a:adc hl,hl ****/
	temp16 = adc16(HL(),HL()); SETHL(temp16);;
	break;

case 0x6b: /**** $6b:ld hl,($2) ****/
	temp16 = FETCH16();SETHL(READ16(temp16));
	break;

case 0x72: /**** $72:sbc hl,sp ****/
	temp16 = sbc16(HL(),SP()); SETHL(temp16);;
	break;

case 0x73: /**** $73:ld ($2),sp ****/
	temp16 = FETCH16();WRITE16(temp16,SP());
	break;

case 0x78: /**** $78:in a,(c) ****/
	A = INPORT(C); SETNZ(A); SETHALFCARRY(0); SETPARITY(A); SETNFLAG(0);;
	break;

case 0x79: /**** $79:out (c),a ****/
	OUTPORT(C,A);
	break;

case 0x7a: /**** $7a:adc hl,sp ****/
	temp16 = adc16(HL(),SP()); SETHL(temp16);;
	break;

case 0x7b: /**** $7b:ld sp,($2) ****/
	temp16 = FETCH16();SETSP(READ16(temp16));
	break;

case 0xa0: /**** $a0:ldi ****/
	WRITE8(DE(),READ8(HL())); INCDE(); INCHL(); DECBC(); SETOVERFLOW(BC() != 0); SETHALFCARRY(0); SETNFLAG(0);;
	break;

case 0xa1: /**** $a1:cpi ****/
	oldCarry = c_Flag; ALUCP(READ8(HL())); c_Flag = oldCarry; INCHL(); DECBC() SETOVERFLOW(BC() != 0);;
	break;

case 0xa2: /**** $a2:ini ****/
	WRITE8(HL(),INPORT(C)); B--; INCHL(); SETNZ(B); SETNFLAG(1);;
	break;

case 0xa3: /**** $a3:outi ****/
	OUTPORT(C,READ8(HL())); B--; INCHL(); SETNZ(B); SETNFLAG(1);;
	break;

case 0xa8: /**** $a8:ldd ****/
	WRITE8(DE(),READ8(HL())); DECDE(); DECHL(); DECBC(); SETOVERFLOW(BC() != 0); SETHALFCARRY(0); SETNFLAG(0);;
	break;

case 0xa9: /**** $a9:cpd ****/
	oldCarry = c_Flag; ALUCP(READ8(HL())); c_Flag = oldCarry; DECHL(); DECBC() SETOVERFLOW(BC() != 0);;
	break;

case 0xaa: /**** $aa:ind ****/
	WRITE8(HL(),INPORT(C)); B--; DECHL(); SETNZ(B); SETNFLAG(1);;
	break;

case 0xab: /**** $ab:outd ****/
	OUTPORT(C,READ8(HL())); B--; DECHL(); SETNZ(B); SETNFLAG(1);;
	break;

case 0xb0: /**** $b0:ldir ****/
	do { WRITE8(DE(),READ8(HL())); INCDE(); INCHL(); DECBC(); SETOVERFLOW(BC() != 0); } while (BC() != 0); SETHALFCARRY(0); SETNFLAG(0);;
	break;

case 0xb1: /**** $b1:cpir ****/
	do { oldCarry = c_Flag; ALUCP(READ8(HL())); c_Flag = oldCarry; INCHL(); DECBC() SETOVERFLOW(BC() != 0); } while( (BC()!= 0) && (z_Flag == 0) );;
	break;

case 0xb2: /**** $b2:inir ****/
	do { WRITE8(HL(),INPORT(C)); B--; INCHL(); SETNZ(B); SETNFLAG(1); } while (B != 0);;
	break;

case 0xb3: /**** $b3:otir ****/
	do { OUTPORT(C,READ8(HL())); B--; INCHL(); SETNZ(B); SETNFLAG(1); } while (B != 0);;
	break;

case 0xb8: /**** $b8:lddr ****/
	do { WRITE8(DE(),READ8(HL())); DECDE(); DECHL(); DECBC(); SETOVERFLOW(BC() != 0); } while (BC() != 0); SETHALFCARRY(0); SETNFLAG(0);;
	break;

case 0xb9: /**** $b9:cpdr ****/
	do { oldCarry = c_Flag; ALUCP(READ8(HL())); c_Flag = oldCarry; DECHL(); DECBC() SETOVERFLOW(BC() != 0); } while( (BC()!= 0) && (z_Flag == 0) );;
	break;

case 0xba: /**** $ba:indr ****/
	do { WRITE8(HL(),INPORT(C)); B--; DECHL(); SETNZ(B); SETNFLAG(1); } while (B != 0);;
	break;

case 0xbb: /**** $bb:otdr ****/
	do { OUTPORT(C,READ8(HL())); B--; DECHL(); SETNZ(B); SETNFLAG(1); } while (B != 0);;
	break;


