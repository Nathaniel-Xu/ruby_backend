=begin
For the first program, at the end x will equal 3 because outer variables
are accessible from within a block.
For the second program, x will not print and there will be an error. This is
because x was defined within the inner scope of the block, and thus
is inaccessble outside of the block.
=end