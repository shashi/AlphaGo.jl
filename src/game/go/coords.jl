_KGS_COLUMNS = "ABCDEFGHJKLMNOPQRST"
_SGF_COLUMNS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

# Converts from a board coordinate to a flattened coordinate
to_flat(coord, pos::GoPosition) = to_flat(coord, pos.env)
to_flat(coord, env::GoEnv) = coord == nothing ? env.N * env.N + 1 :
                                  env.N * (coord[2] - 1) + coord[1]

# Converts from a flattened coordinate to a board coordinate
from_flat(f, pos::GoPosition) = from_flat(f, pos.env)
from_flat(f, env::GoEnv) = f == env.N * env.N + 1 ? nothing :
                        tuple([i + 1 for i in reverse(divrem(f - 1, env.N))]...)

function from_sgf(sgfc)
  # Interprets coords. aa is top left corner; sa is top right corner
  if sgfc == nothing || sgfc == ""
    return nothing
  end
  return findfirst(isequal(sgfc[2]), _SGF_COLUMNS), findfirst(isequal(sgfc[1]), _SGF_COLUMNS)
end

# Converts from a board coordinate to an SGF coordinate
to_sgf(coord) =  coord ==  nothing ? "" : _SGF_COLUMNS[coord[2]] * _SGF_COLUMNS[coord[1]]

function from_kgs(kgsc, env)
  # Interprets coords. A1 is bottom left; A9 is top left.
  if kgsc == "pass"
    return nothing
  end
  kgsc = uppercase(kgsc)
  col = findfirst(isequal(kgsc[1]), _KGS_COLUMNS)
  row_from_bottom = parse(Int, kgsc[2:end])
  return env.N - row_from_bottom + 1, col
end

# Converts from a board coordinate to a KGS coordinate.
to_kgs(coord, env) = coord == nothing ? "pass" : "$(_KGS_COLUMNS[coord[2]])$(env.N - coord[1] + 1)"
