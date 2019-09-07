# Colors:
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Encrypt a file with a public key
function encrypt() {
  local publicKey=$PUBLIC_KEY
  local outFile="encrypted"

  # Get Public File from argument
  if [ -e "$3" ]
  then
    publicKey=$3
  fi

  # Update output file if there is argument
  if [ "$2" != "" ]
  then
    outFile="$2.enc"
  fi

  printf "Encrypting using: %s\n" $publicKey
  openssl rsautl -encrypt -pubin -inkey $publicKey -ssl -in $1 -out $outFile
  echo "Encrypted $1 => $outFile"
}

function encryptFile() {
  local publicKey=$PUBLIC_KEY
  local outFile="encrypted"

  # Get Public File from argument
  if [ -e "$3" ]
  then
    publicKey=$3
  fi

  # Update output file if there is argument
  if [ "$2" != "" ]
  then
    outFile=$2
  fi
  printf "Encrypting using: %s\n" $publicKey
  openssl rand -base64 32 > key.bin
  encrypt key.bin key.bin.enc $publicKey

  # Encrypt Large File
  openssl enc -aes-256-cbc -salt -in $1 -out $outFile -pass file:./key.bin
  echo "Encrypted $1 => $outFile"
}

function decryptFile() {
  local privateKey=$PRIVATE_KEY
  local outFile="decrypted"

  # Get private File from argument
  if [ -e "$3" ]
  then
    privateKey=$3
  fi

  # Update output file if there is argument
  if [ "$2" != "" ]
  then
    outFile=$2
  fi
  decrypt key.bin.enc key.bin $privateKey

  # Encrypt Large File
  openssl enc -d -aes-256-cbc -in $1 -out $outFile -pass file:./key.bin
  echo "Decrypted $1 => $outFile"
}

function decrypt() {
  local privateKey=$PRIVATE_KEY
  local outFile="decrypted"

  # Get private File from argument
  if [ -e "$3" ]
  then
    privateKey=$3
  fi

  # Update output file if there is argument
  if [ "$2" != "" ]
  then
    outFile=$2
  fi

  printf "Decrypting using: %s\n" $privateKey
  openssl rsautl -decrypt -inkey $privateKey -in $1 -out $outFile
  echo "Decrypted $1 => $outFile"
}

function pruneBranches() {
  local protectedBranchesRegEx="(^\*|master|alpha|beta|omega)"
  local pruneBranches=$(git branch --merged | egrep -v $protectedBranchesRegEx)
  printf "Pruning These Branches [y/N]:\n${YELLOW}%s ${NORMAL}" $pruneBranches
  if read -q; then
    echo; 
    echo $pruneBranches | xargs git branch -d;
    git remote prune origin
  fi
  echo;
}

function clearSwp() {
  sudo swapoff -a; sudo swapon -a;
}