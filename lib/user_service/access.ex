defmodule UserService.Access do
  alias UserService.Access.{Context, Token}

  def user_access_token(%UserService.Users.User{guid: guid}) do
    %Context{guid: guid}
    |> Token.sign_auth_token()
  end
end
