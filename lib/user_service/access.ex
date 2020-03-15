defmodule UserService.Access do
  alias UserService.Access.{Context, Token}

  @token_access_minutes 60

  def user_access_token(%UserService.Users.User{guid: guid}) do
    %Context{guid: guid}
    |> Token.sign_auth_token()
  end

  def token_duration_in_seconds() do
    @token_access_minutes * 60
  end
end
