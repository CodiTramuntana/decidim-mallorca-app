# Decidim Mallorca

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for decidim_mallorca, based on [Decidim](https://github.com/decidim/decidim).

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:
```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```
3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

## Residence verification

A new `consell_mallorca_authorization_handler` authorization is provided for Organizations to enable it.
In order for the residence verification integration to work, some things must be configured at different levels.

### Installation configuration

- The installation must have the certificates correctly placed. This is, for the production environment, CA certificates are expected at `config/certs/key.pem` and `config/certs/cert.pem`.
- Access to the INE VPN should have been configured in the client.

### System admin configuration

- A system administrator should login into the system admin panel and, for the given organization, enable the `consell_mallorca_authorization_handler` ("Census").

### Admin configuration
An organization admin will have to:

- configure the corresponding municipality code at the "Admin Panel/Census" menu option.

### Checking residence from console
A `rake` task has been implemented to check citizens residence against the INE web service. The task can be executed as follows:

```bash
bin/rake residence_verification:check[nif,00000000T,0001]
```

Note that access to the INE VPN is required.
