[parm]:title             = 'Tatin Intro'
[parm]:leanpubExtensions = 1


# Publishing Packages

W> **Work in progress**

## API keys

Whether you want to publish to the principal Tatin server at <https://tatin.dev> or your own Tatin Server or the Tatin Server that someone in your company runs, first you need an API key. "API key" is just a fancy expression for "a password that is used by an application".

API keys are only required for publishing, not for consuming packages.

### The Server

If you want to publish on https://tatin.dev you need to ask [kai@aplteam.com](mailto:kai@aplteam.com) for an API key.

If you run your own Tatin Server we suggest that you create a UUID and use that as an API key. In order for the API key to be accepted by the Tatin Server it must be added to the file `Credentials.txt` in the Registry's root directory.

The file will most likely already exist but might be empty.

Make sure that you specify it as either

```
groupname={api-key}
```

or

```
*={api-key}
```

In the first case somebody who provides that API key may publish packages of that group.

In the second case it's a kind of master password: it allows the creating of packages with any group name.

### The Client

On the client side the API key must go into the user configuration file: the file `tatin-client.json`.

It already has an API key for every Server defined in the file.


## Publishing


...