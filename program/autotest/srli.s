# TAG = srli
	.text

	lui x30, 0xfffff
	addi x30, x30, 0x001
	srli x31, x30, 1
	srli x31, x31, 16
	srli x31, x31, 31

	# max_cycle 50
	# pout_start
	# 7ffff800
	# 00007fff
	# 00000000
	# pout_end
