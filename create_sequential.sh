# sets up linear architecture
# takes in a container name to set up architecture
homepath=/var/lib/lxc/"$1"/rootfs
sudo mkdir $homepath/"B&B Customers"
sudo mkdir $homepath/"B&B Customers"/Names
sudo cp /home/student/fake_data/names.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/Names
sudo mkdir $homepath/"B&B Customers"/Names/Emails
sudo cp /home/student/fake_data/emails.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/Names/Emails
sudo mkdir $homepath/"B&B Customers"/Names/Emails/"Account Balances"
sudo cp /home/student/fake_data/account_balances.csv
/var/lib/lxc/$1/rootfs/"B&B Customers"/Names/Emails/"Account Balances"
sudo mkdir $homepath/"B&B Customers"/Names/Emails/"Account Balances"/Addresses
sudo cp /home/student/fake_data/addresses.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/Names/Emails/"Account Balances"/Addresses
sudo mkdir $homepath/"B&B Customers"/Names/Emails/"Account
Balances"/Addresses/Transactions
sudo cp /home/student/fake_data/transactions.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/Names/Emails/"Account Balances"/Addresses/Transactions
sudo mkdir $homepath/"B&B Customers"/Names/Emails/"Account
Balances"/Addresses/Transactions/"Username and Passwords"
sudo cp /home/student/fake_data/usernames_passwords.csv
/var/lib/lxc/$1/rootfs/"B&B Customers"/Names/Emails/"Account
Balances"/Addresses/Transactions/"Username and Passwords"