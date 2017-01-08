user=$(whoami)
mkdir "/home/$user/Downloads/backup/"
dir_backup="/home/$user/Downloads/backup/"

dir_name=$(date +"%Y-%m-%d_%H-%M-%S")"-"$(whoami)".tar.gz"
tar -zcf $dir_name "/home/$user/"
cp $dir_name $dir_backup

scp ${diretorios_zipados[$i]} root@10.70.1.101:"/home/pi/Downloads/"