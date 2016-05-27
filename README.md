# TL;DR
- RELEASENOTE Generator
- pull-request message based

# SETUP
- requirement github access_token

```
  ## Setting -> Applications -> Personal Access Tokens -> Generate new token
   Selected scopes:
    * repo
    * public_repo
    * repo:status
    * read:org
  # Generate token -> copy token and paste to ".env"
```

- set github access_token to ```.env```

# How

```
ruby ./cli.rb gen --org_name=ORG_NAME --repository=REPOSITORY_NAME
```


# Author

Takumi Kanzaki tkm.knzk@gmail.com

# License

RELEASENOTE Generator is available under the MIT license. See the LICENSE file for more info.

