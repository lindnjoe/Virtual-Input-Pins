# OpenAMS for Klipper  
OpenAMS Klipper Plugin

## Installation

### Automatic Installation  

Install OpenAMS using the provided script:  

```bash  
cd ~  
git clone https://github.com/OpenAMSOrg/klipper_openams.git  
cd klipper_openams  
./install-openams.sh
```

If your directory structure differs, you can configure the installation script with additional parameters:

```bash  
./install-openams.sh [-k <klipper path>] [-s <klipper service name>] [-c <configuration path>]
```

## AFC Integration

To relay OpenAMS sensor states into the [AFC Klipper Add-On](../AFC-Klipper-Add-On-direct_update),
add the following section to your printer configuration:

```cfg
[afc_openams]
```


Additional options such as the polling `interval` or extra `oams` instances can
be specified if required.

## Credits

This project was made by knight.rad_iant on Discord.

---