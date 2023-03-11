# dotfiles

## Install

```sh
./setup.sh
```

## Configuration
### Reload Dunst
```sh
killall dunst
notify-send hello-world
```

## Config Git

**~/.config/git**
```sh
config
credentials
.user-default
.user-work
```

```sh
[credential]
	helper = store

[include]
	path = .user-default
[includeIf "gitdir:~/work"]
	path = .user-work
```