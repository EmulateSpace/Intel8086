obj-y += bootloader.o

$(obj)/%.o: $(obj)/%.s FORCE
	$(Q)$(AS) $(KBUILD_AFLAGS_KERNEL) -o $@ $<
