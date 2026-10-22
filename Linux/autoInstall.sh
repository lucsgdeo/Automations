GREENBOLD='\e[1;32m'
TESTCOLOR='\e[1;35m'
DEFAULTCOLOR='\e[0m'

sudo apt update && sudo apt upgrade -y
sudo apt install zsh -y

echo "\n\n${GREENBOLD}Changing Shell: ${DEFAULTCOLOR}"
chsh -s $(which zsh)

echo "\n\n${GREENBOLD}Installing ZSH ${DEFAULTCOLOR}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-syntax-highlighting
echo "\n\n${GREENBOLD}Cloning zsh-syntax-highlighting ${DEFAULTCOLOR}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "\n\n${GREENBOLD}Cloning zsh-autosuggestions ${DEFAULTCOLOR}"
# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

echo "\n\n${GREENBOLD}Changing .zshrc ${DEFAULTCOLOR}"
cat ./.zshrcToCopy > ~/.zshrc

echo "\n\n${TESTCOLOR}Setup completed, copy .zshrc infos ${DEFAULTCOLOR}"