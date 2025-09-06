#!/bin/bash
# Force script to exit if an error occurs
set -e

KLIPPER_PATH="${HOME}/klipper"
KLIPPER_SERVICE_NAME=klipper
SYSTEMDDIR="/etc/systemd/system"
MOONRAKER_CONFIG_DIR="${HOME}/printer_data/config"

# Fall back to old directory for configuration as default
if [ ! -d "${MOONRAKER_CONFIG_DIR}" ]; then
    echo "\"$MOONRAKER_CONFIG_DIR\" does not exist. Falling back to \"${HOME}/klipper_config\" as default."
    MOONRAKER_CONFIG_DIR="${HOME}/klipper_config"
fi

usage(){ echo "Usage: $0 [-k <klipper path>] [-s <klipper service name>] [-c <configuration path>] [-u]" 1>&2; exit 1; }
# Parse command line arguments
while getopts "k:s:c:uh" arg; do
    case $arg in
        k) KLIPPER_PATH=$OPTARG;;
        s) KLIPPER_SERVICE_NAME=$OPTARG;;
        c) MOONRAKER_CONFIG_DIR=$OPTARG;;
        u) UNINSTALL=1;;
        h) usage;;
    esac
done

# Find SRCDIR from the pathname of this script
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/src/ && pwd )"
SCRIPTSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/scripts/ && pwd )"

# Verify Klipper has been installed
check_klipper()
{
    if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F "$KLIPPER_SERVICE_NAME.service")" ]; then
        echo "Klipper service found with name \"$KLIPPER_SERVICE_NAME\"."
    else
        echo "[ERROR] Klipper service with name \"$KLIPPER_SERVICE_NAME\" not found, please install Klipper first or specify name with -s."
        exit -1
    fi
}

check_folders()
{
    if [ ! -d "$KLIPPER_PATH/klippy/extras/" ]; then
        echo "[ERROR] Klipper installation not found in directory \"$KLIPPER_PATH\". Exiting."
        exit -1
    fi
    echo "Klipper installation found at $KLIPPER_PATH"

    if [ ! -f "${MOONRAKER_CONFIG_DIR}/moonraker.conf" ]; then
        echo "[ERROR] Moonraker configuration not found in directory \"$MOONRAKER_CONFIG_DIR\". Exiting."
        exit -1
    fi
    echo "Moonraker configuration found at $MOONRAKER_CONFIG_DIR"
}

# Link extension to Klipper
link_extension()
{
    echo -n "Linking OpenAMS extension to Klipper... "
    for file in "${SRCDIR}"/*.py; do
        ln -sf "${file}" "${KLIPPER_PATH}/klippy/extras/"
    done
    echo "[OK]"
}

link_scripts()
{
    echo -n "Linking OpenAMS scripts to Klipper... "
    for file in "${SRCDIR}"/scripts/*.py; do
        ln -sf "${file}" "${KLIPPER_PATH}/scripts/"
    done
    echo "[OK]"
}

# Restart moonraker
restart_moonraker()
{
    echo -n "Restarting Moonraker... "
    sudo systemctl restart moonraker
    echo "[OK]"
}

# Add updater for OpenAMS to moonraker.conf
add_updater()
{
    echo -e -n "Adding update manager to moonraker.conf... "

    update_section=$(grep -c '\[update_manager openams\]' ${MOONRAKER_CONFIG_DIR}/moonraker.conf || true)
    if [ "${update_section}" -eq 0 ]; then
        echo -e "\n" >> ${MOONRAKER_CONFIG_DIR}/moonraker.conf
        while read -r line; do
            echo -e "${line}" >> ${MOONRAKER_CONFIG_DIR}/moonraker.conf
        done < "$PWD/file_templates/moonraker_update.txt"
        echo -e "\n" >> ${MOONRAKER_CONFIG_DIR}/moonraker.conf
        echo "[OK]"
        restart_moonraker
    else
        echo -e "[update_manager openams] already exists in moonraker.conf [SKIPPED]"
    fi
}

# in the same fashion as add_update create a new function to add the contents of file_templates HDC1080.cfg to ~/klipper/klippy/extras/temperature_sensors.cfg
add_hdc1080()
{
    echo -e -n "Adding HDC1080 sensor to temperature_sensors.cfg... "

    echo -e "\n" >> ${KLIPPER_PATH}/klippy/extras/temperature_sensors.cfg
    while read -r line; do
        echo -e "${line}" >> ${KLIPPER_PATH}/klippy/extras/temperature_sensors.cfg
    done < "$PWD/file_templates/HDC1080.cfg"
    echo -e "\n" >> ${KLIPPER_PATH}/klippy/extras/temperature_sensors.cfg
    echo "[OK]"
}

restart_klipper()
{
    echo -n "Restarting Klipper... "
    sudo systemctl restart $KLIPPER_SERVICE_NAME
    echo "[OK]"
}

start_klipper()
{
    echo -n "Starting Klipper... "
    sudo systemctl start $KLIPPER_SERVICE_NAME
    echo "[OK]"
}

stop_klipper()
{
    echo -n "Stopping Klipper... "
    sudo systemctl stop $KLIPPER_SERVICE_NAME
    echo "[OK]"
}

uninstall()
{
    if [ -f "${KLIPPER_PATH}/klippy/extras/oams.py" ]; then
        echo -n "Uninstalling OpenAMS... "
        for file in "${SRCDIR}"/*.py; do
            unlink "${KLIPPER_PATH}/klippy/extras/$(basename $file)"
        done
        for file in "${SCRIPTSDIR}"/*.py; do
            unlink "${KLIPPER_PATH}/scripts/$(basename $file)"
        done
        echo "[OK]"
        echo "You can now remove the [update_manager openams] section in your moonraker.conf and delete this directory. Also remove all OpenAMS configurations from your Klipper configuration."
        echo "You may also want to remove the HDC1080 sensor from temperature_sensors.cfg"
    else
        echo "oams.py not found in \"${KLIPPER_PATH}/klippy/extras/\". Is it installed?"
        echo "[FAILED]"
    fi
}

# Helper functions
verify_ready()
{
    if [ "$EUID" -eq 0 ]; then
        echo "[ERROR] This script must not run as root. Exiting."
        exit -1
    fi
}

# Run steps
verify_ready
check_klipper
check_folders
stop_klipper
if [ ! $UNINSTALL ]; then
    link_extension
    link_scripts
    add_updater
    add_hdc1080
else
    uninstall
fi
start_klipper