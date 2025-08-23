#!/bin/bash

KLIPPER_DIR="${HOME}/klipper"

VIRTUAL_INPUT_PIN_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

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

