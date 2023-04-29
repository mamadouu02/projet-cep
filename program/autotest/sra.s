# TAG = sra
	.text

	addi x31, x0, 0x001
	lui x30, 0xfffff
	addi x30, x30, 0x001
	sra x31, x30, x31
	addi x30, x0, 2047
	sra x31, x31, x30

	# max_cycle 50
	# pout_start
	# 00000001
	# fffff800
	# ffffffff
	# pout_end
