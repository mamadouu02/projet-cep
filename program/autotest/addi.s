# TAG = addi
	.text

    lui x30, 1028        # Chargement d'une valeur quelconque dans x30
    addi x31, x30, 1     # x31 = x30 + 1  
    lui x31, 0
    addi x31, x31, 2047  # x31 = x31 + 2047

	# max_cycle 50
	# pout_start
	# 00404001
    # 00000000
    # 000007FF
	# pout_end
