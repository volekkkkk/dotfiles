kitty_conf_dir='.config/kitty'
kitty_themes_dir="$kitty_conf_dir/themes"
mkdir -p $kitty_themes_dir

# TODO: generate raw link from repo link
curl -o $kitty_themes_dir/nord.conf https://raw.githubusercontent.com/connorholyday/nord-kitty/master/nord.conf
curl -o $kitty_themes_dir/catppuccin.conf https://raw.githubusercontent.com/catppuccin/kitty/main/catppuccin.conf

ln -s $(pwd)/$kitty_conf_dir/kitty.conf ~/.config/kitty/kitty.conf
ln -s $(pwd)/$kitty_themes_dir/nord.conf $kitty_conf_dir/theme.conf

