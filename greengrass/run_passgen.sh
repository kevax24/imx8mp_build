#!/bin/bash

# giving the device time to boot (second)
sleep 30

# generate and change the default root password
if ip link show | grep -q "end0"; then
    echo "Interface end0 detected"
    ./passGen_aarch64 end0
elif ip link show | grep -q "eth0"; then
    echo "Interface eth0 detected"
    ./passGen_aarch64
else
    echo "No interface detected"
    exit 1
fi

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