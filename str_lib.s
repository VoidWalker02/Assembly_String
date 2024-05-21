.data

.text
main:


############################################################################################################################

#Strlen calculates the length of any given string passed by from a0
#a0 contains string address
#v0 returns length of string
.globl strlen
strlen:

move $t0, $a0 #load string address to t0.


body:
lb $t1, 0($t0) #grab first byte from address
beqz $t1, after #if byte is 0, done counting
addi $v0, $v0, 1
addi $t0, $t0, 1 #add one to string length and one to string address
j body



after:
jr $ra

############################################################################################################################
.globl strchr
strchr:


body_search:
lb $a2, 0($a0)
beqz $a2, after_fail
beq $a2, $a1, after_success
addi $a0, $a0, 1

j body_search

after_fail:
li $v0, 0
jr $ra

after_success:
move $v0, $a0
jr $ra

############################################################################################################################
.globl strcpy
strcpy:
    # t0 is the destination pointer (where the string should be pasted)
    # t1 is the source pointer (string to be copied)
    
    move $t0, $a0
    move $t1, $a1

body_copy:
    lb $t2, 0($t1)       # Load the character at the current position of the source string
    beqz $t2, after_copy # Check if the character is null, if so, terminate copying

    sb $t2, 0($t0)       # Store the character in the destination string
    addi $t0, $t0, 1     # Move to the next position in the destination string
    addi $t1, $t1, 1     # Move to the next character in the source string

    j body_copy          # Repeat the loop

after_copy:
    # Null-terminate the copied string
    sb $zero, 0($t0)     # Store the null terminator at the end of the destination string

    move $v0, $a0
    jr $ra               # Return


############################################################################################################################
.globl strcat
strcat:


    sw $ra, 0($sp)
    addi $sp, $sp, -4
    sw $a0, 0($sp)
    addi $sp, $sp, -4

    # Move to the end of hee
    jal Str_End
    move $a0, $v0

    # Copy source to the end of hee
paste:
    jal strcpy
    
    
    
    lw $ra, 8($sp)    
    lw $v0, 4($sp) 
    addi $sp, $sp, 8
    jr $ra



############################################################################################################################

.globl chomp
chomp:

sw $ra, 0($sp)
addi $sp, $sp, -4
sw $a0, 0($sp)
addi $sp, $sp, -4

jal Str_End
move $t0, $v0
li $t2, 0
li $t4, 32

body_chomp:
lb $t3, 0($t0)
bgt $t3, $t4, after_chomp
sb $t2, 0($t0)
subi $t0, $t0, 1
j body_chomp


after_chomp:

lw $ra, 8($sp)    
lw $v0, 4($sp) 
addi $sp, $sp, 8
jr $ra

############################################################################################################################

.globl Str_End
Str_End:

move $t0, $a0

End_body:
lb $t1, 0($t0)
beqz $t1, End_after
addi $t0, $t0, 1
j End_body



End_after:
move $v0, $t0
jr $ra

############################################################################################################################
.globl strcmp
strcmp:

move $t1, $a0
move $t2, $a1


Cmp_Body:
lb $t3, 0($t1)
lb $t4, 0($t2)
beqz $t3, cmp_equal
beqz $t4, cmp_equal
sub $t5, $t3, $t4
bgtz  $t5, cmp_greater
bltz  $t5, cmp_lesser
addi $t1, $t1, 1
addi $t2, $t2, 1
j Cmp_Body

cmp_greater:
li $v0, 1
jr $ra

cmp_lesser:
li $v0, -1
jr $ra

cmp_equal:
li $v0, 0
jr $ra

############################################################################################################################
.globl strncpy
strncpy:
    # t0 is the destination pointer (where the string should be pasted)
    # t1 is the source pointer (string to be copied)
    # a2is the number of characters to be copied from source
    # t3 is the counter of how many chars have been copied
    move $t0, $a0
    move $t1, $a1
    li $t3, 0
    
body_copyn:
    lb $t2, 0($t1)       # Load the character at the current position of the source string
    beqz $t2, after_copyn # Check if the character is null, if so, terminate copying
    beq $t3, $a2, after_copyn		

    sb $t2, 0($t0)       # Store the character in the destination string
    addi $t0, $t0, 1     # Move to the next position in the destination string
    addi $t1, $t1, 1     # Move to the next character in the source string
    addi $t3, $t3, 1

    j body_copyn         # Repeat the loop

after_copyn:
    # Null-terminate the copied string
    sb $zero, 0($t0)     # Store the null terminator at the end of the destination string
    move $v0, $a0
    jr $ra               # Return


############################################################################################################################


.globl strncat
strncat:

    sw $ra, 0($sp)
    addi $sp, $sp, -4
    sw $a0, 0($sp)
    addi $sp, $sp, -4


      # Move to the end of hee
    jal Str_End
    move $a0, $v0

    # Copy source to the end of hee
pasten:
    jal strncpy# Copy the source string to the end of hee
    
    
    
    lw $ra, 8($sp)    
    lw $v0, 4($sp) 
    addi $sp, $sp, 8
    jr $ra



############################################################################################################################
.globl substring
substring:

# a2 contains left cutoff
# a3 contains right cutoff

    sw $ra, 0($sp)
    addi $sp, $sp, -4
    sw $a0, 0($sp)
    addi $sp, $sp, -4

jal Str_GetN

move $a1, $v0
move $a2, $a3

jal strncpy

    lw $ra, 8($sp)    
    lw $v0, 4($sp) 
    addi $sp, $sp, 8
    jr $ra


############################################################################################################################


.globl Str_GetN
Str_GetN:

move $t0, $a1
li $t2, 0

Get_body:
lb $t1, 0($t0)
beqz $t1, Get_after
beq $t2, $a2, Get_after
addi $t0, $t0, 1
addi $t2, $t2, 1
j Get_body

Get_after:
move $v0, $t0
jr $ra


############################################################################################################################


.globl kill
kill:

li $v0, 10
syscall










