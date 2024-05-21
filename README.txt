Str_Lib provides functions from the C String Library.

Str_Lib is a file that provides several functions for operations using Strings present in the C String library, such as length, copy, chomp, substring and others
availabe for use by assembly functions in other files, all programmed in MIPS Assembly.



Problem statement: Str_Lib needs to implement a number of different functions from C's String Library, to be used by a client file that performs numerous operations
on Strings passed by the user. This client file must be able to use the functions of Str_Lib to flawlessly execute its operations.

Compiling instructions: Load into MARS and use Assemble button.
 

Running instructions: After Assembling, click the run button.

Testing: A Main function and a kill function were created inside the Str_Lib file and were the basis for my testing during the course of the programming, creating
a function such as strlen, loading the appropruate values on main and testing the output compared to what the correct output ought to be. This was repeated for 
every function until it was assured they were working. After, I changed the functions to .globl and called that same main from a separate file, ensuring it 
would assemble even in this situation. Finally, I assembled and ran the client file, testing it against a myriad of Strings. After this point, testing was deemed done.