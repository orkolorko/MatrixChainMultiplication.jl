WeightedVertex = Tuple{Int64, Int64}
WeightedSide = Tuple{WeightedVertex, WeightedVertex}

WeightedPolygon = Vector{WeightedVertex} #First entry is the index of the matrix, second entry the weight

BuildPolygon(weights::Vector{Int64}) = WeightedPolygon([(weights[i], i) for i in 1:length(weights)])

function exists_large(Pol, w_min)
    there_is_large = false
    if length(Pol)<=3
        return false
    else
        for i in 2:length(Pol)-1
            # we check if Pol[i] is a large vertex
            w_A = Float64(w_min)
            w_C = Float64(Pol[i][1])
            w_B = Float64(Pol[i-1][1])
            w_D = Float64(Pol[i+1][1])
            
            if (1/w_B+1/w_D<1/w_A+1/w_C)
                there_is_large = true
            end
        end
    end
    return there_is_large
end         

function ChingHuShing(Pol::WeightedPolygon)
    VertexStack = WeightedPolygon()
    S = Set{WeightedSide}()
    
    w_min = minimum([weight for (weight, i) in Pol])
    println(w_min)
    
    while exists_large(Pol, w_min)    
        for Vₙ in Pol
            if length(VertexStack) <2
                push!(VertexStack, Vₙ)
            elseif length(VertexStack) >= 2
                Vₜ = VertexStack[end]
                Vₘ = VertexStack[end-1] # V_{t-1} in the article
                if (1.0/Vₙ[1]+1.0/Vₘ[1]<1/Vₜ[1]+1/w_min) #if Vₜ is large
                    push!(S, (Vₙ, Vₘ) )
                    pop!(VertexStack)
                end
                push!(VertexStack, Vₙ)
            end
        end
        Pol=VertexStack
    end
    
    sort!(Pol)
    V₁=Pol[1]
    while length(Pol)>3 
        push!(S, (V₁, pop!(Pol)) )
    end
    return S
end


#### This function is used to get potential h-segments in the optimal algorithm
### WIP
function one_sweep(Pol::WeightedPolygon)
    VertexStack = Vector{WeightedVertex}()
    S = Set{WeightedSide}()
    Pol = sort!(Pol)
    for Vₙ in Pol #V_c in the article
        if length(VertexStack) <2
            push!(VertexStack, Vₙ)
        elseif length(VertexStack) >= 2
            Vₜ = VertexStack[end]
            Vₘ = VertexStack[end-1] # V_{t-1} in the article
            if (Vₙ[1]<Vₜ[1]) #w_t>w_c
                push!(S, (Vₙ, Vₘ) )
                pop!(VertexStack)
            else
                push!(VertexStack, Vₙ)
            end
        end
        println(VertexStack)
    end
    
    V₁=Pol[1]
    while length(VertexStack)>3 
        Vₘ = VertexStack[end-1] # V_{t-1} in the article
        push!(S, (V₁, Vₘ) )
        pop!(VertexStack)
    end
    return S
end      