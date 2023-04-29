# TAG = or
	.text

	lui x31, 0x4500
	lui x30, 0x5090
	or x31, x31, x30    # x31 = x31 or x30
	lui x30, 0x12345
	lui x31, 0x67890
	or x31, x31, x30    # x31 = x31 or x30
	lui x31, 0xfffff
	or x31, x31, x30    # x31 = x31 or x30

	# max_cycle 50
	# pout_start
	# 04500000
	# 05590000
	# 67890000
	# 77BD5000
	# fffff000
	# fffff000
	# pout_end
