# TAG = bgeu
	.text

	lui x31, 0x11113
	lui x30, 0x11112
	bgeu x31, x30, ge_1	# Test vrai
	lui x31, 0xfffff
ge_1:
	lui x31, 0x12345
	lui x30, 0x12345
	bgeu x31, x30, ge_3	# Test vrai (égalité) 
ge_2:
	lui x31, 0x67890
ge_3: 
	lui x31, 0

	# max_cycle 50
	# pout_start
	# 11113000
	# 12345000
	# 00000000
	# pout_end
