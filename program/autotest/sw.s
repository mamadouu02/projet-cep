# TAG = sw
	.text

	lui x30, 0x1
    sw x30, 256(x30)
    lw x31, 256(x30)


	# max_cycle 50
	# pout_start
	# 00001000
	# pout_end