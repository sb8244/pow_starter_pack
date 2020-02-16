defmodule UserService.Users do
  def get_user(id) do
    UserService.Repo.get(UserService.Users.User, id)
  end
end
