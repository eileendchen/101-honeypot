# sets up binary architecture
# takes in a container name to set up architecture
homepath=/var/lib/lxc/"$1"/rootfs
sudo mkdir $homepath/"B&B Customers"
sudo mkdir $homepath/"B&B Customers"/"Personal Information"
sudo mkdir $homepath/"B&B Customers"/"Financial Information"
sudo mkdir $homepath/"B&B Customers"/"Personal Information"/Addresses
sudo cp /home/student/fake_data/addresses.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/"Personal Information"/Addresses
sudo mkdir $homepath/"B&B Customers"/"Personal Information"/Names
sudo cp /home/student/fake_data/names.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/"Personal Information"/Names
sudo mkdir $homepath/"B&B Customers"/"Personal Information"/Names/Emails
sudo cp /home/student/fake_data/emails.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/"Personal Information"/Names/Emails
sudo mkdir $homepath/"B&B Customers"/"Financial Information"/Transactions
sudo cp /home/student/fake_data/transactions.csv /var/lib/lxc/$1/rootfs/"B&B
Customers"/"Financial Information"/Transactions
sudo mkdir $homepath/"B&B Customers"/"Financial
Information"/Transactions/"Account Balances"
sudo cp /home/student/fake_data/account_balances.csv
/var/lib/lxc/$1/rootfs/"B&B Customers"/"Financial
Information"/Transactions/"Account Balances"
sudo mkdir $homepath/"B&B Customers"/"Financial Information"/"Usernames and
Passwords"
sudo cp /home/student/fake_data/usernames_passwords.csv
/var/lib/lxc/$1/rootfs/"B&B