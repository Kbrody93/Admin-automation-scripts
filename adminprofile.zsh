# Replace username, fullname, password -

USERNAME="********"  
FULLNAME="********"
PASSWORD="********"

echo "Checking if user '$USERNAME' exists..."

if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' exists. Removing..."
    sudo sysadminctl -deleteUser "$USERNAME" -secure
    sleep 2
fi

echo "Creating admin user '$USERNAME'..."
sudo sysadminctl -addUser "$USERNAME" -fullName "$FULLNAME" -password "$PASSWORD" -admin

if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' created successfully and added as admin."
else
    echo "Failed to create user '$USERNAME'."
    exit 1
fi
