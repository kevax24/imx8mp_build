#!/bin/bash

# generate and change the default root password
./passGen_aarch64

if [ $? -eq 0 ]; then
    echo "Password generator has been run successfully."

    # disable password generator service so it does not run on next boot
    systemctl disable passgen.service
    rm /etc/systemd/system/passgen.service

    # delete passGen and self
    rm /passGen_aarch64
    rm -f /run_passgen.sh
else
    echo "Error: the password generator failed to execute. Reboot the device."
fi