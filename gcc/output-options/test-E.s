	.arch armv8-a
	.text
	.globl _$1
	.data
	.align	2
_$1:
	.word	1
	.cstring
	.align	3
lC0:
	.ascii "__FILE__: %s\12\0"
	.align	3
lC1:
	.ascii "/Users/fan/Desktop/fanfan/cxx-practice/gcc/output-options/test-E.c\0"
	.align	3
lC2:
	.ascii "__LINE__: %d\12\0"
	.align	3
lC3:
	.ascii "__DATE__: %s\12\0"
	.align	3
lC4:
	.ascii "Jul  2 2023\0"
	.align	3
lC5:
	.ascii "__TIME__: %s\12\0"
	.align	3
lC6:
	.ascii "22:13:11\0"
	.align	3
lC7:
	.ascii "__STDC__: %d\12\0"
	.align	3
lC8:
	.ascii "__STDC_VERSION__: %ld\12\0"
	.align	3
lC9:
	.ascii "__STDC_HOSTED__: %d\12\0"
	.align	3
lC10:
	.ascii "__APPLE__: %d\12\0"
	.align	3
lC11:
	.ascii "__GNUC__: %d\12\0"
	.align	3
lC12:
	.ascii "__GNUC_MINOR__: %d\12\0"
	.align	3
lC13:
	.ascii "__VERSION__: %s\12\0"
	.align	3
lC14:
	.ascii "13.1.0\0"
	.text
	.align	2
	.globl _main
_main:
LFB1:
	sub	sp, sp, #48
LCFI0:
	stp	x29, x30, [sp, 16]
LCFI1:
	add	x29, sp, 16
	str	w0, [sp, 44]
	str	x1, [sp, 32]
	adrp	x0, lC1@PAGE
	add	x0, x0, lC1@PAGEOFF;momd
	str	x0, [sp]
	adrp	x0, lC0@PAGE
	add	x0, x0, lC0@PAGEOFF;momd
	bl	_printf
	mov	w0, 8
	str	w0, [sp]
	adrp	x0, lC2@PAGE
	add	x0, x0, lC2@PAGEOFF;momd
	bl	_printf
	adrp	x0, lC4@PAGE
	add	x0, x0, lC4@PAGEOFF;momd
	str	x0, [sp]
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;momd
	bl	_printf
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;momd
	str	x0, [sp]
	adrp	x0, lC5@PAGE
	add	x0, x0, lC5@PAGEOFF;momd
	bl	_printf
	mov	w0, 1
	str	w0, [sp]
	adrp	x0, lC7@PAGE
	add	x0, x0, lC7@PAGEOFF;momd
	bl	_printf
	mov	x0, 3293
	movk	x0, 0x3, lsl 16
	str	x0, [sp]
	adrp	x0, lC8@PAGE
	add	x0, x0, lC8@PAGEOFF;momd
	bl	_printf
	mov	w0, 1
	str	w0, [sp]
	adrp	x0, lC9@PAGE
	add	x0, x0, lC9@PAGEOFF;momd
	bl	_printf
	mov	w0, 1
	str	w0, [sp]
	adrp	x0, lC10@PAGE
	add	x0, x0, lC10@PAGEOFF;momd
	bl	_printf
	mov	w0, 13
	str	w0, [sp]
	adrp	x0, lC11@PAGE
	add	x0, x0, lC11@PAGEOFF;momd
	bl	_printf
	mov	w0, 1
	str	w0, [sp]
	adrp	x0, lC12@PAGE
	add	x0, x0, lC12@PAGEOFF;momd
	bl	_printf
	adrp	x0, lC14@PAGE
	add	x0, x0, lC14@PAGEOFF;momd
	str	x0, [sp]
	adrp	x0, lC13@PAGE
	add	x0, x0, lC13@PAGEOFF;momd
	bl	_printf
	mov	w0, 0
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 48
LCFI2:
	ret
LFE1:
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0
	.byte	0x3
	.ascii "zR\0"
	.uleb128 0x1
	.sleb128 -8
	.uleb128 0x1e
	.uleb128 0x1
	.byte	0x10
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LECIE1:
LSFDE1:
	.set L$set$1,LEFDE1-LASFDE1
	.long L$set$1
LASFDE1:
	.long	LASFDE1-EH_frame1
	.quad	LFB1-.
	.set L$set$2,LFE1-LFB1
	.quad L$set$2
	.uleb128 0
	.byte	0x4
	.set L$set$3,LCFI0-LFB1
	.long L$set$3
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$5,LCFI2-LCFI1
	.long L$set$5
	.byte	0xdd
	.byte	0xde
	.byte	0xe
	.uleb128 0
	.align	3
LEFDE1:
	.ident	"GCC: (Homebrew GCC 13.1.0) 13.1.0"
	.subsections_via_symbols
