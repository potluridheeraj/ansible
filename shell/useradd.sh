#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Check if both username and password are provided as arguments
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <new_username> <password>"
  exit 1
fi

NEW_USER="$1"
PASSWORD="$2"

# Install sudo (if not already installed)
if ! command -v sudo &> /dev/null; then
  apt update
  apt install -y sudo
fi

# Create the new user and set the provided password
useradd --create-home --shell /bin/bash $NEW_USER
echo -e "$PASSWORD\n$PASSWORD" | passwd $NEW_USER

# Add the new user to the sudo group
usermod -aG sudo $NEW_USER

# Configure passwordless sudo for the new user
echo "$NEW_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$NEW_USER
chmod 440 /etc/sudoers.d/$NEW_USER

# Create .ssh directory and authorized_keys file
mkdir -p /home/$NEW_USER/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDxigjshp2TDv8UnU9f3C395XT6Q1THZSRwK8sy7b4MKQjvRf46VoTSn0BLsww7A3v0JuKKfyC9nq/sBzJcpmML09ZO5hCSog3FSYOtyNcils+vubls4U8h9XIk0DmFjG8Bq3sFQpwvoq98MB9qtyBnvDxjosz3VbnA5ZXe1WN2Ez3w7idFp4SJAqOOejhkSerD8y3O/8hG7YxAqPfsxJl2vmO5jPIdqs9S3ZsMXYl2I92ujpeePwzzyiysdUDU0+1Kzk1OPsMjDMNfsg2m5Wvtf9w2jzU5hO5/FmudKCbTUY1RpevOJbEINEz96sw6dtgEENVPTgXNfJiHWS8N9rgKCHGIomwZCh6wn700nBdVBJE3zD9tl32ske6YquG4SvoUUGWt9+tVOsipcbRZiJPONwt4JgWGRkccWPc1KNX5eTDn7VHlIKgLShWM7Xwh/MDIIhJvnKd8gey8lPCXa8Zo/edQNgdTcQ+STcSzijWb8K308+IPezeAc7HKunhrRtAPEfvr59LSoanFoP+k9XyUJmus2oTIBBDZ1zxDKd4j6qzeh6SbkY8u0knW5lpxcXZR2dOBA75L4ViBg66YA6SdAViToGSN9Ar4YuJhiWaoAh3BEawXDO/klhQnCHnl5As4S4zOf1/SwbvTkN5OVQjOVFBq1oSSgrAUgdhWQ4AjRw== dheerajpotluri@ansble

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDnSILivSpevm66c/FQcFndlF6U94rAGHwDfW/hpuvJv4FGfxsklS+BlL6D5O0RzTyYr7v8QZhPQ6YMZGPcKPdcHVXW8TPpqZv5altLrDumiAVWbeaFwU4P2JLGlZ/20vnPZUosUllQ5dAUVBIkc5MUNJl9D1Zzmmjrzw09EbQQ7pGDRg2eaTzaDKG8+7/Df98Q7wloB9+pUZS3jfk82vb2nCC3oofI4LRslmjWKrj3hYgYTLP7GlaLjbHt5BcwsaOrxtjtPR0JoxAhK9TFU2+R4T1bgAaV6R5i7n8obplp/0ABjMv58v3zq1IAloxznZhRyGe1XGuHYkuubSk66v54e4Ykin3dGAoGYMnb4kEwxl3myR+hz+SbMIzk7rb6zalYNsn6iSz1q+6N/uX31v4IoHTzbJFjZhJjkVLYUIiDOHoEc4eeAIb82fTsXi+UI7CD21PEEhGI4gXe6JXe2sysMrROxneCZiJNxUN/gJWiOZzXlImNhZMIZcG+QAKGuezaPE+C9qHRJakCzsTaKA8H9WslZt+QJaSYI2q5NwaEpAjmU7RgPkTW69D+KTN/tXjpjBGIL/NrPkPS8SB12rT0BFnsw8RhwsrWeZNIWM6pHl1dA0LPu3g0B36Zd1AaHO/HGsLlU9gE5tZLdM4yXcWHSMVaPvdaIAcQoBj7/jXTLQ== dheerajpotluri@pve

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCd702akTZeAaJeJ7q2qsTSq3OMGMbp514HJn5cWZR38uQYmQWx9IhiIMCn+dBA7KqbFxyfUKODNtYSvrRyQW92C//giNto5ArJTTh0IVEa3yJ/OItiZh81HvjSmRZPVXSH5r7vUXpkYBH3Ga9ZUpvtx1QthM7VRCWTfz7GIbW+Xz/XB8bGebPJXnT137OWr42x2pTNRr7+P3sXH2/7uWjujXJRIuxg87R3y7SR00okS04D0WecRciyZYDsVNDgT+wcjULfYfVn5omVE9CmJuHWz8Lz7sSIWaOL3oKQIc5dTKZxZ6JoaW1u3Jt2wdoabi5DDzA6z2k1LZudqEPuJhOnmObkKVxQ/MajBUOfF9HwmABvJIT7tv0RAf5RcdWfUHkRbgGjYgcBQq0/xt+y7mBTkhFVizu+FzI07GUbDkXIcSvBI8wyzx0tSB63BbfgGRKz+c3M+JyFB2GyEG4v5J/cFeVA+B3QtVPr/11oafABgozNzDmBBX5EyCIS231E01de/CpiFlt4qgyGGNSjyM3glLjoaZxjw8WypVjSunv06cgOKsolS5uTnX93O+ZNW70lWSp38SfFU5ySWaLsDMPy+Vgvn+kLsl3uMfEZLkBhHvQy7WbuOxklOxR3htK3VEaWXvH7JRozcWIpnhXEDfRxc2DRF7PS+fF3ljVDWSEfmQ== root@pve

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCv7HIRFV75+Bn8pxM/3wkdijtTOLit0r1iuGFkgw6/sq26oZfLandtS8tvaI7s5lj3GYz/C90/MOiEnq5A4ozr6K7cIrQZNQb1HRiPKfqcesWQFr7co79jEVyWaO8jiyTdlpWj6llatjuFWD7ABpWGlmMG07TOI6q0+MBpG1jIzMzG60oZvcZXcDedcOtmLgf8fz2a5PpPIyniwUayJ0HR4scxtyv8C0pt9oHMaEAsHlJ40uI/A9iuxD7OEG8p4msLkrdBzt2AoBtd52hVRcYcoUdYAjMN6TsiwaOwocLoy9yAxFF3B/A00kZa0IDX7A+QjhHI11Bo1bAuPFobV9a+rSpoaqrjfaiJ3xxsX+Q2Z3pU67uzh5OQj4A1QIk87vm865LT+YsvMppbM1Tb0HPmmTRjI0mR1FI23nYcfA7ALIwIbZ9EpGWqRk5DQ9nGl0P+c885jb1DDoufLU9Ly29GgkSVzXiXpb8Cz/egJEftyeRL2wxwDU4aerSLmRIg3qMs24pUI70+sThuKFsPmfG5iIP+5PluT6HtOQglrVQM+rugsS95qpt2aS/NYFm09zXPnWuNPGTrnifXcTP9Yd5iAAWp4XKXKSNR/y5Kd7vxfbepUUAWG5W/zIjua6+cUUsYof2uCPpwNsW48MBPO28DA/IRmTgPobfQEGAP9FHhLw== i853956@DWX9YWFV1Y" >> /home/$NEW_USER/.ssh/authorized_keys
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
chmod 700 /home/$NEW_USER/.ssh
chmod 600 /home/$NEW_USER/.ssh/authorized_keys

echo "User $NEW_USER has been created with sudo privileges and authorized_keys file."
