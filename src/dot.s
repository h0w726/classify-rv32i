.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
# =======================================================
dot:
    # Input validation
    li t0, 1
    blt a2, t0, error_terminate  # Check element_count >= 1
    blt a3, t0, error_terminate  # Check stride0 >= 1
    blt a4, t0, error_terminate  # Check stride1 >= 1

    # Initialize variables
    li t0, 0            # Sum
    li t1, 0           # Counter i
    slli a3, a3, 2   
    slli a4, a4, 2
loop_start:
    bge t1, a2, loop_end    # if i >= element_count, exit loop
    
    # Calculate offset for first array (i * stride0 * 4)     
    li t2, 0 # t2 = i * stride0
    mv t3, a3
    mv t4 ,t1
    beqz t4, multiple_done0 
multiple_loop0:
    andi    t5, t4, 1      
    beqz    t5, shift0      
    add     t2, t2, t3     

shift0:
    slli    t3, t3, 1      
    srli    t4, t4, 1     
    bnez    t4, multiple_loop0  
multiple_done0:
    

    add t2, a0, t2      # Add base address
    lw t3, 0(t2)        # Load value from first array

    # Calculate offset for second array (i * stride1 * 4)
    li t2, 0
    mv t6, a4
    mv t4, t1
    beqz t4, multiple_done1 
multiple_loop1:
    andi    t5, t4, 1      
    beqz    t5, shift1     
    add     t2, t2, t6     

shift1:
    slli    t6, t6, 1      
    srli    t4, t4, 1     
    bnez    t4, multiple_loop1  
multiple_done1:
    
    add t2, a1, t2      # Add base address
    lw t4, 0(t2)        # Load value from second array

    # Multiply values

    li      t2, 0  
    beqz    t3, multiple_done  
    beqz    t4, multiple_done  
    
multiple_loop:
    andi    t5, t4, 1      
    beqz    t5, shift      
    add     t2, t2, t3     

shift:
    slli    t3, t3, 1      
    srli    t4, t4, 1     
    bnez    t4, multiple_loop  


multiple_done:

    # Add to running sum
    add t0, t0, t2      # Add product to sum

    # Increment counter
    addi t1, t1, 1      # i++
    j loop_start

loop_end:
    mv a0, t0           # Move result to return register
   
    jr ra
   
error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit