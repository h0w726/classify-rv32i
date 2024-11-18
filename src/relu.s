.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    bge t1, a1, loop_end  # If i >= length, exit loop
    
    # Calculate current address
    slli t2, t1, 2        # t2 = i * 4 (byte offset)
    add t2, a0, t2        # t2 = base + offset
    
    # Load value
    lw t3, 0(t2)          # t3 = array[i]
    
    # Check if value is negative
    bge t3, zero, skip  # If value >= 0, skip update
    
    # If negative, replace with 0
    li t4,0
    sw t4, 0(t2)        # array[i] = 0
    
skip:
    addi t1, t1, 1        # i++
    j loop_start
loop_end:
    jr ra                 # Return
error:
    li a0, 36          
    j exit          
