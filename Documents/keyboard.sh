#!/usr/bin/env bash

# Определение файла состояния
export STATUS_FILE="$XDG_RUNTIME_DIR/keyboard.status"

# Функция для включения клавиатуры
enable_keyboard() {
    printf "true" >"$STATUS_FILE"
    #notify-send -u normal "Enabling Keyboard"
    hyprctl keyword '$LAPTOP_KB_ENABLED' "true" -r
}

# Функция для отключения клавиатуры
disable_keyboard() {
    printf "false" >"$STATUS_FILE"
    #notify-send -u normal "Disabling Keyboard"
    hyprctl keyword '$LAPTOP_KB_ENABLED' "false" -r
}

# Переключение состояния клавиатуры
toggle_keyboard() {
    if [[ -f "$STATUS_FILE" ]] && [[ "$(cat "$STATUS_FILE")" == "true" ]]; then
        disable_keyboard
    else
        enable_keyboard
    fi
}

# Если скрипт запускается для отображения, просто получить текущее состояние
if [[ $1 == "--status" ]]; then
    if [[ -f "$STATUS_FILE" ]] && [[ "$(cat "$STATUS_FILE")" == "true" ]]; then
        status="Enabled"
    else
        status="Disabled"
    fi
    echo "{\"text\": \"🎹${status}\", \"tooltip\": \"Keyboard is ${status}\", \"class\": \"kb-status-${status,,}\"}"
    exit
fi

# Вызов функции переключения состояния
toggle_keyboard

# Вывести обновленное состояние
if [[ -f "$STATUS_FILE" ]] && [[ "$(cat "$STATUS_FILE")" == "true" ]]; then
    status="Enabled"
else
    status="Disabled"
fi

echo "{\"text\": \"🎹\", \"tooltip\": \"Keyboard is ${status}\", \"class\": \"kb-status-${status,,}\"}"
