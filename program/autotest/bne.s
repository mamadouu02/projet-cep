# TAG = bne
	.text

	bne x31, x0, label
	addi x31, x31, -1

label:
	addi x31, x31, 1
	lui x8, 0

	# max_cycle 50
	# pout_start
	# FFFFFFFF
	# 00000000
	# pout_end
