# helmfileenv

[helmfile](https://github.com/roboll/helmfile) version manager.

Most of the codes are taken from below tools:

* [rbenv](https://github.com/rbenv/rbenv)
* [tfenv](https://github.com/Zordrak/tfenv)
* [kcenv](https://github.com/yuya-takeyama/kcenv)

## Installation

1. Check out helmfileenv into any path (here is `${HOME}/.helmfileenv`)

  ```sh
  $ git clone https://github.com/isindir/helmfileenv.git ~/.helmfileenv
  ```

2. Add `~/.helmfileenv/bin` to your `$PATH` any way you like

  ```sh
  $ echo 'export PATH="$HOME/.helmfileenv/bin:$PATH"' >> ~/.bash_profile
  ```

## Usage

```
Usage: helmfileenv <command> [<args>]

Some useful helmfileenv commands are:
   local       Set or show the local application-specific helmfile version
   global      Set or show the global helmfile version
   install     Install the specified version of helmfile
   uninstall   Uninstall the specified version of helmfile
   version     Show the current helmfile version and its origin
   versions    List all helmfile versions available to helmfileenv

See `helmfileenv help <command>' for information on a specific command.
For full documentation, see: https://github.com/isindir/helmfileenv#readme
```

## License

* helmfileenv
  * The MIT License
* [rbenv](https://github.com/rbenv/rbenv)
  * The MIT License
* [tfenv](https://github.com/Zordrak/tfenv)
  * The MIT License
* [kcenv](https://github.com/yuya-takeyama/kcenv)
  * The MIT License
