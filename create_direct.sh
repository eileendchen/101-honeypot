# sets up direct architecture
# takes in a container name to set up architecture
homepath=/var/lib/lxc/"$1"/rootfs
sudo mkdir $homepath/"B&B Customers"
sudo mkdir $homepath/"B&B Customers"/Names
sudo cp /home/student/fake_data/names.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/Names
sudo mkdir $homepath/"B&B Customers"/Emails
sudo cp /home/student/fake_data/emails.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/Emails
sudo mkdir $homepath/"B&B Customers"/"Account Balances"
sudo cp /home/student/fake_data/account_balances.csv
/var/lib/lxc/$1/rootfs/"B&B Customers"/"Account Balances"
sudo mkdir $homepath/"B&B Customers"/Addresses
sudo cp /home/student/fake_data/addresses.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/Addresses
sudo mkdir $homepath/"B&B Customers"/Transactions
sudo cp /home/student/fake_data/transactions.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/Transactions
sudo mkdir $homepath/"B&B Customers"/"Usernames and Passwords"
sudo cp /home/student/fake_data/usernames_passwords.csv
/var/lib/lxc/$1/rootfs/"B&B Customers"/"Usernames and Passwords"