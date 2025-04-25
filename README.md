# alphanauten devenv for monorepo Neos/next.js projects

devenv provides a reproducible and declarative local development environment for our [Neos](https://www.neos.io/de) projects.
It uses the [Nix package system](https://nixos.org/) to provide native packages for all our required services. This environment is
tightly tailored to the needs of our team members working on various projects with Neos and Next.js.

## Notable Features:
- Overrides default mailer configuration to use [MailHog](https://github.com/mailhog/MailHog)
- Provides helper functions to clear caches
- Enables Xdebug without a performance impact when not using it
- Easily configurable PHP Version
- Inherits all default devenv features and services

## Requirements
* devenv: `v1.0.3` or higher

## Setup & Usage
Just use the example folder for easy setup

### Update
To update your devenv config to the latest version run ``devenv update``. This will update to the latest commit.

### Default values
#### MySQL
The default values for MySQL are:

| Type          | Value  |
|---------------|--------|
| User          | `neos` |
| Password      | `neos` |
| Database name | `neos` |

## More Information:
- https://devenv.sh/

## License
MIT
