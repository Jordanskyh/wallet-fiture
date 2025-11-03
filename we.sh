############ Install Bittensor SDK & BTCLI with UV ############

### Dependencies
clear
    echo "wutwutwut"
    sleep 10

# sudo apt update && sudo apt upgrade -y

### Install NodeJS dan NPM
sudo apt install nodejs npm -y
sudo npm install -g pm2
pm2 startup

### Install UV (Ultra-fast Python package manager)
echo "Installing UV..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env

### Install Bittensor SDK
echo "Installing Bittensor SDK..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/opentensor/bittensor/master/scripts/install.sh)"

### Create Python project with UV
echo "Creating Python environment with UV..."
mkdir -p ~/bittensor-project
cd ~/bittensor-project

# Initialize UV project
uv init
uv add bittensor

### Install BTCLI with UV
echo "Installing BTCLI..."
git clone https://github.com/opentensor/btcli.git
cd btcli

# Install dependencies with UV
uv sync
uv pip install .

clear

### Setup Wallet
while true; do
    echo "Setup Wallet"
    echo "Pilih opsi untuk coldkey:"
    echo "1. Buat Coldkey baru"
    echo "2. Regenerate Coldkey dari mnemonic"
    read -p "Masukkan pilihan (1 atau 2): " coldkey_choice

    if [[ $coldkey_choice == "1" ]]; then
        read -p "Masukkan nama cold wallet (atau tekan Enter untuk 'default'): " coldkey_name
        coldkey_name=${coldkey_name:-default}  # Gunakan 'default' jika tidak ada input
        uv run btcli wallet new_coldkey --wallet.name $coldkey_name
        echo "Simpan mnemonic yang ada! Proses akan lanjut dalam 7 detik. "
        sleep 7
        break
    elif [[ $coldkey_choice == "2" ]]; then
        read -p "Masukkan mnemonic untuk regenerate coldkey: " mnemonic_coldkey
        uv run btcli w regen_coldkey --mnemonic "$mnemonic_coldkey"
        break
    else
        echo "Pilihan tidak valid. Silakan coba lagi."
    fi
done

### Setup Hotkey
while true; do
    echo "Pilih opsi untuk hotkey:"
    echo "1. Buat Hotkey baru"
    echo "2. Regenerate Hotkey dari mnemonic"
    read -p "Masukkan pilihan (1 atau 2): " hotkey_choice

    if [[ $hotkey_choice == "1" ]]; then
        read -p "Masukkan nama cold wallet (untuk hotkey): " coldkey_name
        read -p "Masukkan nama hotkey (atau tekan Enter untuk 'default'): " hotkey_name
        hotkey_name=${hotkey_name:-default}  # Gunakan 'default' jika tidak ada input
        uv run btcli wallet new_hotkey --wallet.name $coldkey_name --wallet.hotkey $hotkey_name
        echo "Simpan mnemonic yang ada! Proses akan lanjut dalam 7 detik. "
        sleep 7
        break
    elif [[ $hotkey_choice == "2" ]]; then
        read -p "Masukkan mnemonic untuk regenerate hotkey: " mnemonic_hotkey
        uv run btcli w regen_hotkey --mnemonic "$mnemonic_hotkey"
        break
    else
        echo "Pilihan tidak valid. Silakan coba lagi."
    fi
done

### Done
clear

echo "
✅ Instalasi Bittensor SDK dan BTCLI dengan UV sudah selesai!

📁 Project directory: ~/bittensor-project
🚀 Untuk menjalankan btcli: cd ~/bittensor-project && uv run btcli <command>
⚡ UV provides ultra-fast dependency resolution and installation

📋 Useful commands:
   - uv run btcli --help
   - uv run btcli wallet list
   - uv run btcli subnet list
   - uv add <package>  # Add new Python packages
   - uv sync           # Sync dependencies

🎯 Next steps:
   1. Register your hotkey to a subnet
   2. Start mining or validating
   3. Monitor your performance

Happy mining! 🎉
"

read -p "Tekan Enter untuk keluar..."
