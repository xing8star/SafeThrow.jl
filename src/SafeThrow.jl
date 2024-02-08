module SafeThrow
export @safefunction
export @add_safefunction

safethrow(_)=false
function safethrow(x::Expr)
    if x.head==:call && x.args[1]==:throw
        # println("find throw")
        x.head=:return
        x.args=[x.args[2]]
        return true
    else
        maximum(map(safethrow,x.args))
    end
end
function safefunction!(x::Expr)
    if safethrow(x.args[2])
        if x.head==:function && x.args[1].head==:call
            insert!(x.args[1].args,2,Expr(:(::),Expr(:curly,:Val,QuoteNode(:safe))))
        end
        return true
    end
    false
end


macro safefunction(x)
    originexpr =copy(esc(x)) 
    if safefunction!(x)
        return esc(x)
    end
    originexpr
end
macro add_safefunction(x)
    originexpr =copy(esc(x)) 
    if safefunction!(x)
        fdefs =Array{Expr}(undef, 2)
        fdefs[1]=originexpr
        fdefs[2] = esc(x)
        return Expr(:block, fdefs...)
    end
    originexpr
end


end # module SafeThrow
