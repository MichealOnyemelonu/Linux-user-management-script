#!/bin/bash

# Simple Linux User Management Script
# Usage:
# ./user_manager.sh create username group
# ./user_manager.sh delete username

CREDENTIALS_FILE="$HOME/users_created.txt"

generate_password() {
# Generate random 12-char password
openssl rand -base64 12
}

create_user() {
local USERNAME=$1
local GROUP=$2
local PASSWORD=$(generate_password)

# Create user with home directory
sudo useradd -m -s /bin/bash "$USERNAME"

# Add to group (if provided)
if [ -n "$GROUP" ]; then
sudo usermod -aG "$GROUP" "$USERNAME"
fi

# Set password
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Save credentials
echo "User: $USERNAME | Password: $PASSWORD | Group: ${GROUP:-none}" >> "$CREDENTIALS_FILE"

echo "✅ User '$USERNAME' created successfully."
}

delete_user() {
local USERNAME=$1
sudo deluser --remove-home "$USERNAME"
echo "❌ User '$USERNAME' deleted successfully."
}

if [ "$1" == "create" ]; then
create_user "$2" "$3"
elif [ "$1" == "delete" ]; then
delete_user "$2"
else
echo "Usage:"
echo " $0 create <username> [group]"
echo " $0 delete <username>"
fi