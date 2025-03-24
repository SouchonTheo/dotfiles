# dotfiles

This repository contains configuration files (dotfiles) for various tools and applications. It is designed to be used with [GNU Stow](https://www.gnu.org/software/stow/), a symlink manager, to simplify the process of managing and deploying dotfiles across systems.

## Prerequisites

- Install GNU Stow:

  ```bash
  sudo apt install stow # For Debian/Ubuntu
  brew install stow     # For macOS
  ```

  Refer to your package manager's documentation for other systems.

## Usage

1. Clone this repository into your home directory or a directory of your choice:

   ```bash
   git clone https://github.com/SouchonTheo/dotfiles.git ~/dotfiles
   ```

2. Navigate to the repository:

   ```bash
   cd ~/dotfiles
   ```

3. Use GNU Stow to create symlinks for the desired configuration. For example, to deploy the `nvim` configuration:

   ```bash
   stow nvim
   ```

   This will create symlinks in your home directory pointing to the corresponding files in the `nvim` folder.

4. To remove symlinks, use the `-D` flag:

   ```bash
   stow -D nvim
   ```

## Directory Structure

Organize your dotfiles into subdirectories named after the application or tool they belong to. For example:

```
dotfiles/
├── vim/
│   ├── .vimrc
│   └── .vim/
├── git/
│   ├── .gitconfig
│   └── .gitignore
└── zsh/
    ├── .zshrc
    └── .zshenv
```

Each subdirectory should mirror the structure of your home directory for the files it contains.

## Notes

- Ensure that existing configuration files in your home directory are backed up or removed before running `stow` to avoid conflicts.
- Customize the repository to suit your specific needs and preferences.

For more information on GNU Stow, refer to its [documentation](https://www.gnu.org/software/stow/manual/stow.html).
