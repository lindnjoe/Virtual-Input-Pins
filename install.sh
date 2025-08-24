#!/bin/bash

KLIPPER_DIR="${HOME}/klipper"

VIRTUAL_INPUT_PIN_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"

if [ ! -d "$KLIPPER_DIR" ]; then
    echo "virtual_input_pin: klipper doesn't exist"
    exit 1
fi

echo "virtual_input_pin: linking klippy to virtual_input_pin.py."

if [ -e "${KLIPPER_DIR}/klippy/extras/virtual_input_pin.py" ]; then
    rm "${KLIPPER_DIR}/klippy/extras/virtual_input_pin.py"
fi
ln -s "${VIRTUAL_INPUT_PIN_DIR}/virtual_input_pin.py" "${KLIPPER_DIR}/klippy/extras/virtual_input_pin.py"

if ! grep -q "klippy/extras/virtual_input_pin.py" "${KLIPPER_DIR}/.git/info/exclude"; then
    echo "klippy/extras/virtual_input_pin.py" >> "${KLIPPER_DIR}/.git/info/exclude"
fi

read -r -p "virtual_input_pin: install auto_ams_update.py? [y/N] " AUTO_AMS_CHOICE
if [[ "${AUTO_AMS_CHOICE}" =~ ^[Yy]$ ]]; then
    echo "virtual_input_pin: linking klippy to auto_ams_update.py."
    if [ -e "${KLIPPER_DIR}/klippy/extras/auto_ams_update.py" ]; then
        rm "${KLIPPER_DIR}/klippy/extras/auto_ams_update.py"
    fi
    ln -s "${VIRTUAL_INPUT_PIN_DIR}/auto_ams_update.py" "${KLIPPER_DIR}/klippy/extras/auto_ams_update.py"

    if ! grep -q "klippy/extras/auto_ams_update.py" "${KLIPPER_DIR}/.git/info/exclude"; then
        echo "klippy/extras/auto_ams_update.py" >> "${KLIPPER_DIR}/.git/info/exclude"
    fi

    PRINTER_CFG="${HOME}/printer.cfg"
    if [ ! -f "${PRINTER_CFG}" ] && [ -f "${HOME}/printer_data/config/printer.cfg" ]; then
        PRINTER_CFG="${HOME}/printer_data/config/printer.cfg"
    fi

    if [ -f "${PRINTER_CFG}" ]; then
        if ! grep -q '^\[auto_ams_update\]' "${PRINTER_CFG}"; then
            echo "virtual_input_pin: adding [auto_ams_update] to top of ${PRINTER_CFG}."
            tmp_file="${PRINTER_CFG}.tmp"
            { echo "[auto_ams_update]"; cat "${PRINTER_CFG}"; } > "${tmp_file}"
            mv "${tmp_file}" "${PRINTER_CFG}"
        else
            echo "virtual_input_pin: [auto_ams_update] already present in printer.cfg."
        fi
    else
        echo "virtual_input_pin: printer.cfg not found, skipping config addition."
    fi
else
    echo "virtual_input_pin: skipping auto_ams_update.py."
fi

echo "virtual_input_pin: installation successful."
