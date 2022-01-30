############## KITTY ##################
kitty_conf_dir='.config/kitty'
kitty_themes_dir="$kitty_conf_dir/themes"

# TODO: generate raw link from repo link
curl -o $kitty_themes_dir/nord.conf https://raw.githubusercontent.com/connorholyday/nord-kitty/master/nord.conf
curl -o $kitty_themes_dir/catppuccin.conf https://raw.githubusercontent.com/catppuccin/kitty/main/catppuccin.conf

mv ~/$kitty_conf_dir ~/.config/kitty.backup
mkdir -p ~/$kitty_conf_dir 

ln -sf $(pwd)/$kitty_conf_dir/kitty.conf ~/.config/kitty/kitty.conf
ln -sf $(pwd)/$kitty_themes_dir/catppuccin.conf ~/$kitty_conf_dir/theme.conf

############## NEOVIM ##################
mv ~/.config/nvim ~/.config/nvim.backup

git submodule add https://github.com/NvChad/NvChad
ln -s $(pwd)/NvChad/ ~/.config/nvim
nvim -c "autocmd User PackerComplete quitall" -c "PackerSync"

