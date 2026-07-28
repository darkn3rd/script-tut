sudo apt install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
sudo apt install rbenv

sudo apt update && sudo apt install -y gpg wget apt-transport-https

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
  | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update && sudo apt install code

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc


cd ~/.rbenv/plugins/ruby-build
git pull

rbenv install 4.0.6

# macos
# brew update
# brew upgrade rbenv ruby-build

pyenv update
pyenv install 3.14.6
# fail
sudo apt update && sudo apt install -y \
  libbz2-dev \
  tk-dev \
  liblzma-dev \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libreadline-dev \
  libsqlite3-dev \
  libffi-dev

pyenv install 3.14.6


sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc https://downloads.claude.ai/claude-desktop/key.asc
echo "deb [signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list
sudo apt update && sudo apt install claude-desktop

