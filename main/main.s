# ----------------------------------------------------------
# main.s
#
# Copyright (C) 2017 Buddy <buddy.zhang@aliyun.com>
#
# Main entry
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
	.code16

	.global main_start
	.equ SETUPSEG, 0x9020   # this is the current segment
	.section ".main_text", "ax"

	ljmp $SETUPSEG, $main_start
main_start:
	mov %cs, %ax
	mov %ax, %fs
	mov %ax, %ds
	mov %ax, %es
	/* Running your assembly code */
	nop
	nop
