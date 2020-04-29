function MatrixChainOrder(dims::Array{Int64,1}) 
    n = length(dims)-1 
    # this is the number of dimensions, please note that it is number multiplication+1
    # please remark that Julia is index-1 based, i.e.
    # if the matrix multiplication is given by Aₙ ... A₂ A₁ we have that
    # size(A₁) = (dims[1], dims[2])
    # size(A₁) = (dims[2], dims[3])
    
    M = zeros(Int64, (n,n))
    # the entry M[i, j] will hold the actual minimum cost to multiply Aⱼ...Aᵢ  
    
    S = zeros(Int64, (n,n))
    # this matrix contains the splitting index, i.e. where we are putting the parenthesis when 
    # looking at Aⱼ...Aᵢ
    # is S[i, j] = k this means that we are splitting as (Aⱼ...)Aₖ(...Aᵢ)
    
    for i in 1:n
        M[i,i] = 0 #no cost involved
    end
    
    for len in 2:n # we iterate over the length, we start by multiplying 2 matrices
       for i in 1:n-len+1
            # we follow the cycle for len = 3
            # n-3+1 = n-2 so we have a length 3 grouping at the end
            j = i+len-1 # j = i+2
            # we start by looking at (A₁*A₂*A₃), (A₂*A₃*A₄), ...
            # please note that M[i, j] = typemax(Int64)
            M[i,j]= typemax(Int64)
            
            for k in i:j-1 # k varies in {i, i+1} 
                cost = M[i,k]+M[k+1,j]+dims[i]*dims[k+1]*dims[j+1]
                # we compute the cost of A(BC)
                # i.e., when k = i
                # cost = M[i, i]+M[i+1, i+2]+rows(A)*columns(A)*column(C) 
                # now, the cost of (AB)C
                # cost = M[i, i+1]+M[i+2, i+2]+rows(A)*columns(B)*column(C)                
                if cost<M[i,j]
                    M[i,j] = cost
                    S[i,j] = k
                end
            end
        end
    end
    return M, S
end

function parenthesis(S, i, j)
    if j-i == 1
        str = "A_$i A_$j"
    elseif j==i
        str = "A_$i"
    else
        str = "("*parenthesis(S, i, S[i, j])*")"*"("*parenthesis(S, S[i, j]+1, j)*")"    
    end
    return str
end