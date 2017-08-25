# ----------------------------------------------------------
# Bootloader.s
#
# Copyright (C) 2017 Buddy <buddy.zhang@aliyun.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
	.code16
	.global bootloader_start
	.section ".bs_text", "ax"
bootloader_start:
	# Boot from first floppy
	.equ DEVICE_NR, 0x00

	.equ SETUPLEN, 4        # nr of setup-sectors
	.equ BOOTSEG, 0x07C0    # original address of boot-sector
	.equ INITSEG, 0x9000    # we move boot here - out of the way
	.equ SETUPSEG, 0x9020   # setup starts here

	# Normalize the start address
	ljmp $BOOTSEG, $start2

start2:
	mov $BOOTSEG, %ax
	mov %ax, %ds
	mov $INITSEG, %ax
	mov %ax, %es
	mov $256, %cx
	sub %si, %si
	sub %di, %di
	rep
	movsw
	ljmp $INITSEG, $go
go:
	mov %cs, %ax
	mov %ax, %ds
	mov %ax, %es
# put stack at 0x9ff00
	mov %ax, %ss
	mov $0xFF00, %sp # arbitrary value >> 512

# load the setup-sectors directly after the bootblock
# Note that 'es' is already set up

load_setup:
	# If use hard disk, dirver is 0x80
	mov $0x0000, %dx      # head 0
	mov $DEVICE_NR, %dl   # dirve 0
	mov $0x0002, %cx   # sector 2, track 0
	mov $0x0200, %bx   # address = 512, in INITSEG
	.equ     AX, 0x200+SETUPLEN
	mov     $AX, %ax   # service 2, nr of sectors
	int $0x13          # read it
	mov %ax, %ax
	jnc ok_load_setup  # ok -continue
	mov $0x0000, %dx
	mov $DEVICE_NR, %dl
	mov $0x0000, %ax   # reset the diskette
	int $0x13
	jmp load_setup

ok_load_setup:

# Print some iname message

	mov $0x03, %ah     # read cursor pos
	xor %bh, %bh
	int $0x10

	mov $27, %cx
	mov $0x0007, %bx   # page 0, attribute 7 (normal)
	mov $msg1, %bp
	mov $0x1301, %ax
	int $0x10

# OK, now we running main.s
	ljmp $SETUPSEG, $0

msg1:
	.byte 13,10
	.ascii "Loading BiscuitOS ..."
	.byte 13,10,13,10

	.org 508
