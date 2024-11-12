#!/bin/sh

# download certificates to the device
echo "************ Download certificates to the device... ************"
mkdir -p /greengrass/v2
chmod 755 /greengrass
mv ./claim.pem.crt /greengrass/v2
mv ./claim.private.pem.key /greengrass/v2
curl -o /greengrass/v2/AmazonRootCA1.pem https://www.amazontrust.com/repository/AmazonRootCA1.pem
echo "Done"

# set up the device environment
echo "************ Set up the device environment... ************"
apt update

mount -t proc /proc /proc
apt -y install default-jdk
umount /proc

useradd --system --create-home ggc_user
groupadd --system ggc_group
sed -i 's|root.*|root    ALL=(ALL:ALL) ALL|' "/etc/sudoers"
echo "Done"

# download the AWS IoT Greengrass Core software
echo "************ Download the AWS IoT Greengrass Core software... ************"
curl -s https://d2s8p88vqu9w66.cloudfront.net/releases/greengrass-2.13.0.zip > greengrass-2.13.0.zip
if ! command -v unzip &> /dev/null; then
    echo "unzip is not installed. Installing unzip..."
    apt -y install unzip
fi
unzip greengrass-2.13.0.zip -d GreengrassInstaller && rm greengrass-2.13.0.zip
echo "Done"

# download the AWS IoT fleet provisioning plugin
echo "************ Download the AWS IoT fleet provisioning plugin... ************"
curl -s https://d2s8p88vqu9w66.cloudfront.net/releases/aws-greengrass-FleetProvisioningByClaim/fleetprovisioningbyclaim-1.2.1.jar > GreengrassInstaller/aws.greengrass.FleetProvisioningByClaim.jar
echo "Done"