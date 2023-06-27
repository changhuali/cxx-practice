	.text
Ltext0:
	.file 1 "/Users/hjmac04/Desktop/cxx-practice/gcc/output-options/test-E.c"
	.globl _a
	.data
	.align 2
_a:
	.long	1
	.cstring
lC0:
	.ascii "hello world %d\12\0"
	.text
	.globl _main
_main:
LFB1:
	.loc 1 5 40
	pushq	%rbp
LCFI0:
	movq	%rsp, %rbp
LCFI1:
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	.loc 1 6 9
	movl	_a(%rip), %eax
	movl	%eax, %esi
	leaq	lC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	_printf
	.loc 1 7 10
	movl	$0, %eax
	.loc 1 8 1
	leave
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
	.uleb128 0x10
	.uleb128 0x1
	.byte	0x10
	.byte	0xc
	.uleb128 0x7
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x1
	.align 3
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
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xd
	.uleb128 0x6
	.byte	0x4
	.set L$set$5,LCFI2-LCFI1
	.long L$set$5
	.byte	0xc
	.uleb128 0x7
	.uleb128 0x8
	.align 3
LEFDE1:
	.text
Letext0:
	.file 2 "/usr/local/Cellar/gcc/13.1.0/lib/gcc/current/gcc/x86_64-apple-darwin22/13/include-fixed/stdio.h"
	.section __DWARF,__debug_info,regular,debug
Lsection__debug_info:
Ldebug_info0:
	.long	0x22a
	.word	0x4
	.set L$set$6,Ldebug_abbrev0-Lsection__debug_abbrev
	.long L$set$6
	.byte	0x8
	.uleb128 0x1
	.ascii "GNU C++17 13.1.0 -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=13.0.0 -mtune=core2 -g\0"
	.byte	0x4
	.ascii "/Users/hjmac04/Desktop/cxx-practice/gcc/output-options/test-E.c\0"
	.ascii "/Users/hjmac04/Desktop/cxx-practice/gcc/output-options\0"
	.quad	Ltext0
	.set L$set$7,Letext0-Ltext0
	.quad L$set$7
	.set L$set$8,Ldebug_line0-Lsection__debug_line
	.long L$set$8
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.ascii "long unsigned int\0"
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.ascii "unsigned int\0"
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.ascii "signed char\0"
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.ascii "short unsigned int\0"
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.ascii "int\0"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.ascii "long long int\0"
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.ascii "long long unsigned int\0"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.ascii "long int\0"
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.ascii "char\0"
	.uleb128 0x3
	.long	0x1a2
	.uleb128 0x4
	.byte	0x8
	.long	0x1aa
	.uleb128 0x5
	.ascii "a\0"
	.byte	0x1
	.byte	0x3
	.byte	0x5
	.long	0x164
	.uleb128 0x9
	.byte	0x3
	.quad	_a
	.uleb128 0x6
	.ascii "printf\0"
	.byte	0x2
	.byte	0xbf
	.byte	0x6
	.long	0x164
	.long	0x1e3
	.uleb128 0x7
	.long	0x1af
	.uleb128 0x8
	.byte	0
	.uleb128 0x9
	.ascii "main\0"
	.byte	0x1
	.byte	0x5
	.byte	0x5
	.long	0x164
	.quad	LFB1
	.set L$set$9,LFE1-LFB1
	.quad L$set$9
	.uleb128 0x1
	.byte	0x9c
	.long	0x227
	.uleb128 0xa
	.ascii "argc\0"
	.byte	0x1
	.byte	0x5
	.byte	0xe
	.long	0x164
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xa
	.ascii "argv\0"
	.byte	0x1
	.byte	0x5
	.byte	0x20
	.long	0x227
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.uleb128 0x4
	.byte	0x8
	.long	0x1af
	.byte	0
	.section __DWARF,__debug_abbrev,regular,debug
Lsection__debug_abbrev:
Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0x8
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x1b
	.uleb128 0x8
	.uleb128 0x2134
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.section __DWARF,__debug_pubnames,regular,debug
Lsection__debug_pubnames:
	.long	0x28
	.word	0x2
	.set L$set$10,Ldebug_info0-Lsection__debug_info
	.long L$set$10
	.long	0x22e
	.long	0x1b5
	.ascii "a\0"
	.long	0x1c9
	.ascii "printf\0"
	.long	0x1e3
	.ascii "main\0"
	.long	0
	.section __DWARF,__debug_pubtypes,regular,debug
Lsection__debug_pubtypes:
	.long	0xc7
	.word	0x2
	.set L$set$11,Ldebug_info0-Lsection__debug_info
	.long L$set$11
	.long	0x22e
	.long	0xfc
	.ascii "long unsigned int\0"
	.long	0x111
	.ascii "unsigned int\0"
	.long	0x121
	.ascii "signed char\0"
	.long	0x130
	.ascii "unsigned char\0"
	.long	0x141
	.ascii "short int\0"
	.long	0x14e
	.ascii "short unsigned int\0"
	.long	0x164
	.ascii "int\0"
	.long	0x16b
	.ascii "long long int\0"
	.long	0x17c
	.ascii "long long unsigned int\0"
	.long	0x196
	.ascii "long int\0"
	.long	0x1a2
	.ascii "char\0"
	.long	0
	.section __DWARF,__debug_aranges,regular,debug
Lsection__debug_aranges:
	.long	0x2c
	.word	0x2
	.set L$set$12,Ldebug_info0-Lsection__debug_info
	.long L$set$12
	.byte	0x8
	.byte	0
	.word	0
	.word	0
	.quad	Ltext0
	.set L$set$13,Letext0-Ltext0
	.quad L$set$13
	.quad	0
	.quad	0
	.section __DWARF,__debug_line,regular,debug
Lsection__debug_line:
Ldebug_line0:
	.section __DWARF,__debug_str,regular,debug
Lsection__debug_str:
	.ident	"GCC: (Homebrew GCC 13.1.0) 13.1.0"
	.subsections_via_symbols
