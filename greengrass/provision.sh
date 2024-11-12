#!/bin/sh

# giving the device time to boot (second)
sleep 30

# get MAC address of eth0
MAC_ADDRESS=$(cat /sys/class/net/end0/address | tr -d ':')

# install the AWS IoT Greengrass Core software and provision device on AWS
echo "************ Install the AWS IoT Greengrass Core software and provision device on AWS... ************"
# Edit configuration file
sed -i 's|ThingName: ""|ThingName: "'$MAC_ADDRESS'"|' "config.yaml"
sudo mv ./config.yaml ./GreengrassInstaller/

sudo -E java -Droot="/greengrass/v2" -Dlog.store=FILE \
  -jar ./GreengrassInstaller/lib/Greengrass.jar \
  --trusted-plugin ./GreengrassInstaller/aws.greengrass.FleetProvisioningByClaim.jar \
  --init-config ./GreengrassInstaller/config.yaml \
  --component-default-user ggc_user:ggc_group \
  --setup-system-service true
echo "Done"

sleep 60

# disable provisioning service so it does not run on next boot
# systemctl disable provision.service

# delete all unused files after provisioning
# Delete all provisioning files
# rm /greengrass/v2/claim.private.pem.key
# rm /greengrass/v2/claim.pem.crt
# rm -rf ./GreengrassInstaller