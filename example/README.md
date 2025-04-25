# Example for easy setup of monorepo

## Requirements
* alphanauten monorepo with `apps/neos-cms` and `apps/nextjs`

## Setup & Usage
Copy all files from the example folder into a project and enter it (assuming you have direnv installed). Run `direnv allow` if it asks you to.

Make sure to run the following command to accelerate the startup process:
```bash
cachix use devenv ; cachix use fossar ; cachix use shopware
```
Add the following files to the project `.gitignore` file:
- `.devenv*`
- `devenv.local.nix`
- `.direnv`
# Built in commands

| Command       | Description                                                     | Example                                 |
|---------------|-----------------------------------------------------------------|-----------------------------------------|
| `cc`          | Runs the neos cache:flush command - works in every subdirectory | `> devenv shell cc`                     |
