# execute after SQL CREATE statements
system "CHGAUT OBJ('/qsys.lib/claims.lib/policy.file') USER(QWSERVICE) DTAAUT(*RWX)"
system "CHGAUT OBJ('/qsys.lib/claims.lib/vehicle.file') USER(QWSERVICE) DTAAUT(*RWX)"
