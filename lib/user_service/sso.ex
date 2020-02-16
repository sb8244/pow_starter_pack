defmodule UserService.Sso do
  @moduledoc """
  SSO cookie management for the current user on login. This SSO cookie can be used
  by other domains under the same parent in order to provide server-server verified SSO session.
  """

  def plug() do
    __MODULE__.Plug
  end
end
