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

# Tests
- [ ] Redis Cache Tests
- [ ] IDP tests
