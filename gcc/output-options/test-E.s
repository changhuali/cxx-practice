	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 13, 0	sdk_version 13, 1
	.globl	_main                           ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	movl	%edi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	leaq	L_.str(%rip), %rdi
	leaq	L_.str.1(%rip), %rsi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.2(%rip), %rdi
	movl	$7, %esi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.3(%rip), %rdi
	leaq	L_.str.4(%rip), %rsi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.5(%rip), %rdi
	leaq	L_.str.6(%rip), %rsi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.7(%rip), %rdi
	movl	$1, %esi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.8(%rip), %rdi
	movl	$201710, %esi                   ## imm = 0x313EE
	movb	$0, %al
	callq	_printf
	leaq	L_.str.9(%rip), %rdi
	movl	$1, %esi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.10(%rip), %rdi
	movl	$1, %esi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.11(%rip), %rdi
	movl	$4, %esi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.12(%rip), %rdi
	movl	$2, %esi
	movb	$0, %al
	callq	_printf
	leaq	L_.str.13(%rip), %rdi
	leaq	L_.str.14(%rip), %rsi
	movb	$0, %al
	callq	_printf
	xorl	%eax, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"__FILE__: %s\n"

L_.str.1:                               ## @.str.1
	.asciz	"/Users/hjmac04/Desktop/cxx-practice/gcc/output-options/test-E.c"

L_.str.2:                               ## @.str.2
	.asciz	"__LINE__: %d\n"

L_.str.3:                               ## @.str.3
	.asciz	"__DATE__: %s\n"

L_.str.4:                               ## @.str.4
	.asciz	"Jun 30 2023"

L_.str.5:                               ## @.str.5
	.asciz	"__TIME__: %s\n"

L_.str.6:                               ## @.str.6
	.asciz	"09:17:38"

L_.str.7:                               ## @.str.7
	.asciz	"__STDC__: %d\n"

L_.str.8:                               ## @.str.8
	.asciz	"__STDC_VERSION__: %ld\n"

L_.str.9:                               ## @.str.9
	.asciz	"__STDC_HOSTED__: %d\n"

L_.str.10:                              ## @.str.10
	.asciz	"__APPLE__: %d\n"

L_.str.11:                              ## @.str.11
	.asciz	"__GNUC__: %d\n"

L_.str.12:                              ## @.str.12
	.asciz	"__GNUC_MINOR__: %d\n"

L_.str.13:                              ## @.str.13
	.asciz	"__VERSION__: %s\n"

L_.str.14:                              ## @.str.14
	.asciz	"Apple LLVM 14.0.0 (clang-1400.0.29.202)"

.subsections_via_symbols
