# TAG = slli
	.text

	lui x30, 0xfffff
	addi x30, x30, 0x001
	slli x31, x30, 1
	slli x31, x31, 16
	slli x31, x31, 31

	# max_cycle 50
	# pout_start
	# ffffe002
	# e0020000
	# 00000000
	# pout_end
