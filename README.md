## Overview
Avoid to use try/catch in Julia
## Installation

```julia-repl
(@v1.10) pkg> add https://gitee.com/abaraba/safethrow.jjl
```

## Example
```julia
julia> using SafeThrow
julia> @safefunction function abc(a::Int,c)
    local d=1
    if true
        throw(c)
    end
    return a
end
abc (generic function with 1 method)

julia> abc(Val(:safe),1,2)
2
```


