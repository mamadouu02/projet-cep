# TAG = xor
	.text

	lui x31, 0x4500
	lui x30, 0x5090
	xor x31, x31, x30   # x31 = x31 xor x30
	lui x30, 0x12345
	lui x31, 0x67890
	xor x31, x31, x30   # x31 = x31 xor x30
	lui x31, 0xfffff
	xor x31, x31, x30   # x31 = x31 xor x30

	# max_cycle 50
	# pout_start
	# 04500000
	# 01590000
	# 67890000
	# 75BD5000
	# fffff000
	# EDCBA000
	# pout_end
