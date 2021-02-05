# dotfiles

Fast setup:
```
git clone git@github.com:ransonr/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
```

Requirements can be installed in a conda environment:
```
$ conda env create -f vim-environment.yml
```

Then make sure you add the environment to your `PATH`:
```
$ export PATH="/path/to/vimenv/bin:$PATH"
```
