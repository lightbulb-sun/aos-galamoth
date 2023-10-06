.gba
.open "hack.gba", 0x08000000

FREE_SPACE                      equ 0x08160000
SOUL_UNDINE                     equ 0x4000
SOUL_SCYLLA                     equ 0x8000
ABILITY_ACQUIRED_HIPPO_GALA     equ 0x02013394
BIT_ABILITY_ACQUIRED_GALAMOTH   equ 4
ABILITY_ON                      equ 0x02013396
BIT_ABILITY_ON_GALAMOTH         equ 5

.thumb

.org 0x08014acc
        bl      undine
.org 0x0801524e
        bl      scylla

.org FREE_SPACE
undine:
        push    {r2, lr}
        ; replace original instructions
        add     r0, r0, r2
        ldr     r1, [r0]
@@check:
        bl      galamoth_checks
        beq     @@end
@@activate_undine:
        ldr     r2, =SOUL_UNDINE
        orr     r1, r2
@@end:
        pop     {r2, pc}


scylla:
        push    {r2, lr}
        ; replace original instructions
        add     r0, r0, r4
        ldr     r0, [r0]
@@check:
        bl      galamoth_checks
        beq     @@end
@@activate_scylla:
        ldr     r2, =SOUL_SCYLLA
        orr     r0, r2
@@end:
        pop     {r2, pc}


galamoth_checks:
        push    {r0-r1, lr}
@@check_for_galamoth_acquisition:
        ldr     r0, =ABILITY_ACQUIRED_HIPPO_GALA
        ldr     r0, [r0]
        mov     r1, (1<<BIT_ABILITY_ACQUIRED_GALAMOTH)
        and     r0, r1
        beq     @@end
@@check_for_galamoth_activation:
        ldr     r0, =ABILITY_ON
        ldr     r0, [r0]
        mov     r1, (1<<BIT_ABILITY_ON_GALAMOTH)
        and     r0, r1
@@end:
        pop     {r0-r1,pc}

.pool

.close
