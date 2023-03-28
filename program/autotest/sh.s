# TAG = sh
	.text

	lui x30, 0x1
    sh x30, 256(x30)
    lw x31, 256(x30)


	# max_cycle 50
	# pout_start
	# 00001000
	# pout_end