# Pow Exploration Project - User Service

I setup this project to explore how Pow works, and to configure an instance of how I might want to run Pow. This allows me to
freely judge the project, and determine if I'd ever use it.

I'm quite happy with Pow so far. I've been able to keep control over my user flow, and have even gone so far as to implement
SSO flows on top of Pow. The flexibility has been good, while still giving me everything I need to be successful.

This project is still a WIP, until the checklist at the bottom is fully completed.

# Running the Project

You can startup this project with the following commands:

```bash
mix deps.get && npm install --prefix assets && mix ecto.setup
mix phx.server
```

This starts on port 4000, but expects to run via http://idp.localhost.development:4000. You can set this up in your `/etc/hosts` file
as:

```
127.0.0.1 idp.localhost.development test.localhost.development
```

You should also startup the user consumer if you want to see the SSO flow in action.

## Sent Emails

You can view sent emails (in-memory only) at http://idp.localhost.development:4000/sent_emails. Use this to confirm any created users.

## OAuth Login

You can create a GitHub app to test out OAuth connection. The SalesLoft one is just there to see how Assent works with custom OAuth providers.
Update `config/dev.secret.exs` to include your sensitive environment variables. It's not version-controlled.

## TOTP

I setup a basic TOTP implementation as a pow extension to see what writing a custom extension was like. I don't think I'm going to finish
it at the moment, but it can be found on the branch `pow-totp`.

You can find the extension (not finished) at https://github.com/sb8244/pow_totp.

# User Consumer

There is an included sub-project that implements the consumer side of SSO. It has code for both server-server
and client-server SSO. Start it via:

```bash
cd user_consumer
mix deps.get
mix phx.server
```

It starts on port 4001, but expects to run via http://test.localhost.development:4001 for local testing purposes. This
allows it to be on a different domain than the IDP, which proves that it is working correctly. You can use the `/etc/hosts`
setup in the previous section.

# TODO

- [x] Setup Redis cache store with namespace
- [x] Make cookie live longer than session (possibly persistent extension)
- [x] Sign in with redirection
- [x] SSO API server
- [x] Review all messages (Pow.Phoenix.Messages, [Pow Extension].Phoenix.Messages)
- [x] Setup mailer (local)
- [x] SSO API server auth (JWT token auth)
  - [x] Add GUID to user for reference
  - [x] CORS
- [x] Do not store the full user in the session
- [x] UI
  - [x] Bulma to BS4?
- [x] Capture user name on registration
- [x] Social login
  - [ ] Logging on all failure (like add-user-id triggering)
- [x] 2FA
- [ ] invites
  - [ ] Attach arbitrary attributes to the invite (is Pow okay for this?)
- [ ] Admin interface to manage users
  - [ ] Manually confirm emails
  - [ ] View user information
  - [ ] Send reset password link

## Tests
- [ ] Redis Cache Tests
- [ ] IDP tests
