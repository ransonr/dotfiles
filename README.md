# dotfiles

## Setup

Fast setup:
```
git clone git@github.com:ransonr/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
```

Core requirements assumed to be available are:
- vim/neovim
- ag
- conda
- tmux

Additional requirements can be installed in a conda environment:
```
$ conda env create -f vim-environment.yml
```

Then make sure you add the environment to your `PATH`:
```
$ export PATH="/path/to/vimenv/bin:$PATH"
```

## Vim Cheatsheet

Handful of mappings/keystrokes that I should remember:

Mode | Mapping | Description | Source
---- | ------- | ----------- | ------
n | \[g | Move to the next linter error | vimrc
n | \]g | Move to the previous linter error | vimrc
n | gd | Go to definition of item under the cursor in a vsplit | vimrc
n | gr | Display references to item under the cursor in a vsplit | vimrc
n | \<leader\>q | Close the current buffer | vimrc
n | \<leader\>l | Move to the next buffer | vimrc
n | \<leader\>h | Move to the previous buffer | vimrc
n | \<leader\>rtw | Removes trailing whitespace in the current buffer | vimrc
n | \<C-p\> | Display git-tracked files with fzf | vimrc
n | \<leader\>f | Search in files with fzf using ag | vimrc
n | ]] | Jump to beginning of next Python function/class |
n | \[\[ | Jump to beginning of current/previous Python function/class |
\* | :Vex | Open netrw in a vertical split | netrw
