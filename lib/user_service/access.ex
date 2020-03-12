defmodule UserService.Access do
  alias UserService.Access.{Context, Token}

  def user_access_token(%UserService.Users.User{id: id}) do
    %Context{guid: id}
    |> Token.sign_auth_token()
  end
end
