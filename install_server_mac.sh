
# Path to the vagrant folder
path="./webserver"
# virtualbox specific vagrantfile (default)
vagrantfile="./Vagrantfiles/Vagrantfile_vb"
# vagrantfile with ssh user
ssh_file="./resources/ssh_files/Vagrantfile_vb_ssh"

printf "starting script ...\n"

cd $path

# # select vm provider
# user_input=-1
# while (( $user_input < 1 || $user_input > 2))
# do
# printf "\n1) VirtualBox [Ubuntu18] 2) VirtualBox [Ubuntu20]\n\n"
# printf "Select a provider: "
# read user_input
# done

# # choose Vagrantfile
# case $user_input in
#     1) 
#         vagrantfile="./Vagrantfiles/Vagrantfile_vb"
#         ssh_file="./resources/ssh_files/Vagrantfile_vb_ssh"
#         ;;
#     2)
#         vagrantfile="./Vagrantfiles/Vagrantfile_vb_20"
#         ssh_file="./resources/ssh_files/Vagrantfile_vb_ssh_20"
#         ;;
#     *)
#         echo "Error: No valid provider"
#         exit 
#         ;;
# esac

# overwrite existing Vagrantfile if necessary
printf "checking if 'Vagrantfile' already exists ...\n"

if [ -e ./Vagrantfile ] 
then

    printf "\n### CAUTION: existing Vagrantfiles will be deleted!\n\n"
    printf "deleting Vagrantfile ...\n"
    rm ./Vagrantfile
    printf "creating new Vagrantfile ...\n"
    cp $vagrantfile ./Vagrantfile

else 
    printf "creating Vagrantfile ...\n"
    cp $vagrantfile ./Vagrantfile

fi


# check if Vagrantfile was succesfully created
if [ ! -e ./Vagrantfile ]
then
    printf "file creation failed!\ncheck the files in '/Vagrantfiles' \n"
    cd .. # return to script location
    exit 1

else 
    printf "continue with 'vagrant up' command ...\n"
fi


# set up the vm with vagrant
printf "\n######## VAGRANT UP ########\n\n"

vagrant up

printf "waiting 120 seconds for the machine to reboot ...\n"
sleep 20
printf "waiting 100 seconds for the machine to reboot ...\n"
sleep 20
printf "waiting  80 seconds for the machine to reboot ...\n"
sleep 20
printf "waiting  60 seconds for the machine to reboot ...\n"
sleep 20
printf "waiting  40 seconds for the machine to reboot ...\n"
sleep 20
printf "waiting  20 seconds for the machine to reboot ...\n"
sleep 15
printf "waiting   5 seconds for the machine to reboot ...\n"
sleep 5

printf "\n####### VM SUCESSFULL INITIALIZED #######\n\n"

printf "changing ssh user to websec ...\n"

rm ./Vagrantfile
cp $ssh_file ./Vagrantfile

printf "starting first ssh session ..."
vagrant ssh
