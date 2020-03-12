defmodule UserService.Access.Context do
  @enforce_keys [:guid]
  defstruct @enforce_keys
end
