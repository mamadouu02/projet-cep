# TAG = blt
	.text

	blt x31, x0, label
    addi x31, x31, -1

label:
    addi x31, x31, 1

	# max_cycle 50
	# pout_start
	# FFFFFFFF
	# 00000000
	# pout_end
