# MatrixChainMultiplication.jl

Simple implementation of the Matrix Chain Multiplication algorithms from 
[Wikipedia Matrix Chain Multiplication](https://en.m.wikipedia.org/wiki/Matrix_chain_multiplication)
and beyond.

Given a chain multiplication of matrices A_1 A_2 ... A_n with different shapes, the algorithm gives us the optimal 
multiplication order to minimize operation count.

As an example, if A is a 10 × 30 matrix, B is a 30 × 5 matrix, and C is a 5 × 60 matrix, then
* computing (AB)C needs (10×30×5) + (10×5×60) = 1500 + 3000 = 4500 operations
* computing A(BC) needs (30×5×60) + (10×30×60) = 9000 + 18000 = 27000 operations

(the example above is from the wikipedia page)

## Usage

Only one function is exported by the package, that uses dynamical programming to compute the minimum. A bare implementation of another algorithm
is contained 
```julia
MatrixChainOrder(dims)
```
where dims is an Array of integers which contains the number dimensions, please note that its length is number multiplication+1.
Julia is index-1 based, i.e. if the matrix multiplication is given by Aₙ ... A₂ A₁ we have that
```julia
 size(A₁) = (dims[1], dims[2])
 size(A₂) = (dims[2], dims[3])
 ```
the function returns M, S where M[i, j] holds the actual minimum cost to multiply Aⱼ...Aᵢ and S[i, j] contains the splitting index, i.e. where we are putting the parenthesis when looking at Aⱼ...Aᵢ is S[i, j] = k this means that we are splitting as (Aⱼ...)Aₖ(...Aᵢ).

The function 
```julia
parenthesis(S, i, j)
```
outputs the optimal parenthesis disposition between i and j in string format.
