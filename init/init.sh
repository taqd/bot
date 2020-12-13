sudo apt update
sudo apt upgrade
sudo apt install vim git tmux \
  clang-11 build-essential python3-pip \
  imagemagick \
  cmake libarmadillo-dev libensmallen-dev libcereal-dev \
  libboost-all-dev \
  libcurl4-openssl-dev \
  ffmpeg

sudo ln -s /usr/bin/clang++-11 /usr/bin/clang++ 


curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

git clone http://github.com/taqd/bot

cp bot/init/.* ~/
