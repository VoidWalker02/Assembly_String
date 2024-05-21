        .data
quote:  .asciiz "\""
eoln:   .asciiz "\n"

wordName: .asciiz "word = "
lineName: .asciiz "line = "

sentinel: .asciiz "done"

firstPrompt: .asciiz "Next line: "
line: .space 100
word: .space 100
##########################################################################

        .text
        .globl main
# ========================================================================
# main(char ** argv, int argc)
# ========================================================================
# Ignores its parameters.
#
# Performs the following (approximately)
#   while (true) {
# _main_prompt:
#     char  *  line = promptReadAndChomp("Next line: ", line, 100);
#     char  * word;
#
#     if    (strcmp(line, "done") == 0)
#       break ;
#
#     char  * space; // location of leftmost ' ' in line
# _main_next_word:
#     while ((space = strchr(line, ' ')) != NULL) {
#       word  = substring(word, line, 0, space - line);
#       line  = substring(line, line, (space - line) + 1, 100);
#       println (word);
        #     }
# _main_no_more_spaces:
#     if    (strlen(line) > 0)
#       println (line); // whatever is leftover
# _main_line_now_empty:
#   }
# _main_epilogue:
#   exit();
#
# $t0 - used to calculate space-line (temp)
#       temp is pushed onto the stack for safekeeping
main:
_main_prologue:
        # space for temp value (space - line)
        addi  $sp, $sp, -4

_main_prompt:
        la    $a0, firstPrompt
        la    $a1, line
        li    $a2, 100
        jal   promptReadAndChomp

        # strcmp(line, "done")
        la    $a0, line
        la    $a1, sentinel
        jal   strcmp

        # if == 0, break
        beqz  $v0, _main_epilogue

_main_next_word:
        # get pointer to first contained space
        # space = strchr(line, ' ')
        la    $a0, line
        li    $a1, ' '
        jal   strchr

        # break if (space == NULL)
        beqz  $v0, _main_no_more_spaces

        # save temp = space - line
        la    $t0, line
        sub   $t0, $v0, $t0
        sw    $t0, 4($sp)

        # word = substring(word, line, 0, space - line)
        la    $a0, word
        la    $a1, line
        move  $a2, $zero
        lw    $a3, 4($sp)         # temp (space - line)
        jal   substring

        # substring(line, line, (space - line) + 1, 100)
        la    $a0, line
        la    $a1, line
        lw    $a2, 4($sp)         # temp (space - line)
        addi  $a2, $a2, 1         # temp + 1
        li    $a3, 100
        jal   substring

# debugging prints left but commented out; uncomment
# watch word/line change through the loop
#        la    $a0, wordName
#        li    $v0, 4
#        syscall

        la    $a0, word
        jal   println

#        la    $a0, lineName
#        li    $v0, 4
#        syscall

#        la    $a0, line
#        jal   println

        b     _main_next_word

_main_no_more_spaces:
        la    $a0, line
        jal   strlen
        beqz  $v0, _main_line_now_empty
        la    $a0, line
        jal   println

_main_line_now_empty:
        b     _main_prompt

_main_epilogue:
        # clean up the stack
        addi  $sp, $sp, 4
        li    $v0,10
        syscall

        .globl println
# ========================================================================
# void println(char * line)
# ========================================================================
#   $a0 - pointer to string to print - non-NULL
#
# Print line between quotes and then start a new line.
println:
_println_prologue:
        addi  $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $a0, 8($sp)         # line

        la    $a0, quote
        li    $v0, 4
        syscall

        lw    $a0, 8($sp)         # line
        li    $v0, 4
        syscall

        la    $a0, quote
        li    $v0, 4
        syscall

        la    $a0, eoln
        li    $v0, 4
        syscall

_println_epilogue:
        lw    $ra, 4($sp)
        addi  $sp, $sp, 8
        jr    $ra
# ------------------------------------------------------------------------


        .globlpromptReadAndChomp
# ========================================================================
# char * promptReadAndChomp (char * prompt, char * destination, int maxCh)
# char * promptReadAndChomp (address $a0, address $a1, int $a2)
# ========================================================================
#
# Print prompt (w/o eoln), then read user input into destination. Finally,
# before returning destination, use chomp to remove unprintables from
# the string read into buffer.
#
#   $a0 - pointer to prompt string to display; cannot be NULL
#   $a1 - pointer to destination buffer; cannot be NULL
#   $a2 - size of destination; maximum characters to read
#   $v0 - returns destination
promptReadAndChomp:
_promptReadAndChomp_prologue:
        addi  $sp, $sp, -12
        sw    $ra, 4($sp)
        sw    $a1, 8($sp)         # destination
        sw    $a2, 12($sp)        # maxch

        # print the prompt (pointer already in $a0)
        li    $v0, 4
        syscall

        # setup and read string into destination
        lw    $a0, 8($sp)         # destination
        lw    $a1, 12($sp)        # maxch
        li    $v0, 8
        syscall

        # setup and call chomp
        lw    $a0, 8($sp)         # destination
        jal   chomp

        # chomp puts address of the string in $v0
_promptReadAndChomp_epilogue:
        lw    $ra, 4($sp)
        lw    $v0, 8($sp)
        addi  $sp, $sp, 12

        jr    $ra
# ------------------------------------------------------------------------
