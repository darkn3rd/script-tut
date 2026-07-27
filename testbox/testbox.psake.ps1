# =============================================
# testbox.psake.ps1 - shared psake task definitions, mirroring
# testbox.rake's structure task-for-task. Each win_scripts/<lang>/
# psakefile.ps1 dot-sources this file, the same way each language's
# Rakefile does `import("../../testbox/testbox.rake")`.
#
# Every leaf task (A0, A1, ... M2) depends on Header, matching
# testbox.rake's pattern of invoking the header task at the start of
# every task - psake only runs a given task once per invocation, so this
# is safe to repeat without printing the header multiple times.
# =============================================

Import-Module (Join-Path $PSScriptRoot 'TestBox.psm1') -Force

# A task named "Default" is not allowed to have its own action in psake -
#  it must be -Depends only - so the summary gets its own trailing task.
Task Default -Depends Output, Variables, Arithmetic, Input, Branch, Looping, Arrays, Associative, Subroutine, Arguments, Parameters, Exit, Function, Flags, Environment, Summary

Task Summary {
    Show-TestBoxSummary
}

Task Header {
    Write-TestBoxHeader
}

# ================================================================
Task Output -Depends A0, A1, A2

Task A0 -Depends Header { Invoke-TestBoxTask -Task 'a0' }
Task A1 -Depends Header { Invoke-TestBoxTask -Task 'a1' }
Task A2 -Depends Header { Invoke-TestBoxTask -Task 'a2' }

# ================================================================
Task Variables -Depends B0, B1, B2, B3

Task B0 -Depends Header { Invoke-TestBoxTask -Task 'b0' }
Task B1 -Depends Header { Invoke-TestBoxTask -Task 'b1' }
Task B2 -Depends Header { Invoke-TestBoxTask -Task 'b2' }
Task B3 -Depends Header { Invoke-TestBoxTask -Task 'b3' }

# ================================================================
Task Arithmetic -Depends C0, C1, C2, C3

Task C0 -Depends Header { Invoke-TestBoxTask -Task 'c0' }
Task C1 -Depends Header { Invoke-TestBoxTask -Task 'c1' }
Task C2 -Depends Header { Invoke-TestBoxTask -Task 'c2' }
Task C3 -Depends Header { Invoke-TestBoxTask -Task 'c3' }

# ================================================================
Task Input -Depends D0, D1

Task D0 -Depends Header { Invoke-TestBoxTask -Task 'd0' }
Task D1 -Depends Header { Invoke-TestBoxTask -Task 'd1' }

# ================================================================
Task Branch -Depends E0, E1, E2, E3, E4, E5, E6

Task E0 -Depends Header { Invoke-TestBoxTask -Task 'e0' }
Task E1 -Depends Header { Invoke-TestBoxTask -Task 'e1' }
Task E2 -Depends Header { Invoke-TestBoxTask -Task 'e2' }
Task E3 -Depends Header { Invoke-TestBoxTask -Task 'e3' }
Task E4 -Depends Header { Invoke-TestBoxTask -Task 'e4' }
Task E5 -Depends Header { Invoke-TestBoxTask -Task 'e5' }
Task E6 -Depends Header { Invoke-TestBoxTask -Task 'e6' }

# ================================================================
Task Looping -Depends F0, F1, F2, F3, F4

Task F0 -Depends Header { Invoke-TestBoxTask -Task 'f0' }
Task F1 -Depends Header { Invoke-TestBoxTask -Task 'f1' }
Task F2 -Depends Header { Invoke-TestBoxTask -Task 'f2' }
Task F3 -Depends Header { Invoke-TestBoxTask -Task 'f3' }
Task F4 -Depends Header { Invoke-TestBoxTask -Task 'f4' }

# ================================================================
Task Arrays -Depends G0, G1, G2

Task G0 -Depends Header { Invoke-TestBoxTask -Task 'g0' }
Task G1 -Depends Header { Invoke-TestBoxTask -Task 'g1' }
Task G2 -Depends Header { Invoke-TestBoxTask -Task 'g2' }

# ================================================================
Task Associative -Depends H0, H1

Task H0 -Depends Header { Invoke-TestBoxTask -Task 'h0' }
Task H1 -Depends Header { Invoke-TestBoxTask -Task 'h1' }

# ================================================================
Task Subroutine -Depends I0, I1, I2

Task I0 -Depends Header { Invoke-TestBoxTask -Task 'i0' }
Task I1 -Depends Header { Invoke-TestBoxTask -Task 'i1' }
Task I2 -Depends Header { Invoke-TestBoxTask -Task 'i2' }

# ================================================================
Task Arguments -Depends J0, J1, J2

Task J0 -Depends Header { Invoke-TestBoxTask -Task 'j0' }
Task J1 -Depends Header { Invoke-TestBoxTask -Task 'j1' }
Task J2 -Depends Header { Invoke-TestBoxTask -Task 'j2' }

# ================================================================
Task Parameters -Depends K0, K1

Task K0 -Depends Header { Invoke-TestBoxTask -Task 'k0' }
Task K1 -Depends Header { Invoke-TestBoxTask -Task 'k1' }

# ================================================================
Task Exit -Depends L0

Task L0 -Depends Header { Invoke-TestBoxTask -Task 'l0' }

# ================================================================
Task Function -Depends M0, M1, M2

Task M0 -Depends Header { Invoke-TestBoxTask -Task 'm0' }
Task M1 -Depends Header { Invoke-TestBoxTask -Task 'm1' }
Task M2 -Depends Header { Invoke-TestBoxTask -Task 'm2' }

# ================================================================
Task Flags -Depends O0, O1, O2

Task O0 -Depends Header { Invoke-TestBoxTask -Task 'o0' }
Task O1 -Depends Header { Invoke-TestBoxTask -Task 'o1' }
Task O2 -Depends Header { Invoke-TestBoxTask -Task 'o2' }

# ================================================================
Task Environment -Depends N0, N1, N2

Task N0 -Depends Header { Invoke-TestBoxTask -Task 'n0' }
Task N1 -Depends Header { Invoke-TestBoxTask -Task 'n1' }
Task N2 -Depends Header { Invoke-TestBoxTask -Task 'n2' }
