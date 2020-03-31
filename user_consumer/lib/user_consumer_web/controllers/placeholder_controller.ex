defmodule UserConsumerWeb.PlaceholderController do
  use UserConsumerWeb, :controller

  def show(conn, _params) do
    user = conn.private[:sso_user]
    html(conn, EEx.eval_string(template(), user: user, logout_url: logout_url()))
  end

  defp template() do
    """
    <h2>Logged in as</h2>
    <pre><%= inspect user %></pre>

    <h2>Options</h2>

    <a href="<%= logout_url %>">Logout</a>

    <script type="text/javascript">
      const IDP_BASE = 'http://idp.localhost.development:4000'

      // Once the subject is established, we should never allow a different one in this memory space
      let establishedSubject = null

      // Internal for keeping track
      let currToken = null
      let getTokenPromise = null

      getToken()

      setInterval(() => {
        if (currToken && currToken.isTimeToRefresh()) {
          getTokenPromise = null
          currToken = null

          getToken()
        }
      }, 5000)

      // Public interface to get a token
      function getToken() {
        if (!getTokenPromise || currToken && currToken.isTimeToRefresh()) {
          console.debug('grabbing token')

          getTokenPromise = fetch(`${IDP_BASE}/api/tokens`, { credentials: "include", method: "POST" })
            .then(resp => {
              if (!resp.ok) {
                // There are an error in the web request, don't cache it
                getTokenPromise = null
                throw resp
              } else {
                return resp.json()
              }
            })
            .then(token => {
              // We can never allow the user to log out / log in to a different window with a different subject
              // Allowing this would allow for cross contamination
              if (establishedSubject && token.subject !== establishedSubject) {
                throw new Error('Subject has changed! Consider user logged out')
              }

              currToken = token
              establishedSubject = token.subject

              token.expiration_local_seconds = calculateNextExpiration(token)
              token.isTimeToRefresh = () => isTimeToRefresh(token)

              return currToken
            })
        }

        return getTokenPromise
      }

      /*
       * We cannot use the token expiration time, because our local clock may be offset from that.
       * Let's assume that the network had a minimal overhead, and calculate the token expiration time
       * based on the duration of the token + the user's current time.
       */
      function calculateNextExpiration(token) {
        const localNow = Math.floor(new Date() / 1000)

        // Jitter from 15 seconds to 10% of the duration, to avoid thundering herd
        const maxJitter = Math.floor(token.duration_in_seconds * .1)
        const minJitter = 15

        const jitterRandTop = Math.max(maxJitter, maxJitter - minJitter)
        const jitter = Math.floor(Math.random() * jitterRandTop) + minJitter

        return localNow + token.duration_in_seconds - jitter
      }

      function isTimeToRefresh(token) {
        return new Date() >= (token.expiration_local_seconds * 1000)
      }
    </script>
    """
  end

  defp logout_url() do
    UserConsumerWeb.Plug.SsoUserConsumer.sso_logout_url()
  end
end
