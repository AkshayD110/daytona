#!/bin/bash

source config.sh

if [ -z $db_name ] || [ -z $db_user ] || [ -z $db_password ] || [ -z $db_host ] || [ -z $db_root_pass ] || [ -z $daytona_install_dir ] || [ -z $daytona_data_dir ] || [ -z $ui_admin_pass ] || [ -z $email_user ] || [ -z $email_domain ] || [ -z $smtp_server ] || [ -z $smtp_port ]; then
  echo 'one or more variables are undefined in config.sh'
  echo 'Please configure config.sh'
  echo 'For details that are unknown, enter some dummy values'
  exit 1
fi

sudo mkdir -p $daytona_install_dir

if ! [ -d "$daytona_install_dir" ]; then
    echo "Not able to create daytona install directory"
    exit 1
fi

sudo cp config.sh $daytona_install_dir
sudo cp uninstall_daytona.sh $daytona_install_dir
echo 'rm -- "$0"' | sudo tee -a ${daytona_install_dir}/uninstall_daytona.sh > /dev/null
sudo cp daytona_backup.sh $daytona_install_dir
sudo cp daytona_restore.sh $daytona_install_dir
sudo cp ../../util/cron-backup.sh $daytona_install_dir

echo "****** Installing Daytona DB *********"
echo "**************************************"
./install_daytona_db.sh

echo "****** Installing Daytona UI*********"
echo "**************************************"
./install_daytona_ui.sh

echo "****** Installing Daytona Scheduler*****"
echo "****************************************"
sudo ./install_daytona_scheduler.sh

echo "****** Installing Daytona Agent ******"
echo "**************************************"
sudo ./install_daytona_agent.sh

echo "****** Updating IP of sample framework ******"
echo "*********************************************"
sudo ./fix_sample_framework_ip.sh
