#!/bin/bash

# Укажите адрес для пинга
target_address="8.8.8.8"  # Заданный адрес для пинга

# Параметры
max_ping_time_ms=100
max_failures=3
failures=0

while true; do
    # Выполнение пинга (1 пакет)
    ping_result=$(ping -c 1 "$target_address" | grep 'icmp_seq')
    
    # Извлечение времени пинга
    ping_time=$(echo "$ping_result" | awk -F'=' '{print $4}' | awk '{print $1}' | awk -F'.' '{print $1}')

    # Проверка времени пинга
    if [ -n "$ping_time" ] && [ "$ping_time" -gt "$max_ping_time_ms" ]; then
        echo "Пинг $target_address превышает $max_ping_time_ms мс: $ping_time мс."
    fi

    # Проверка на успешность пинга
    if [ -z "$ping_time" ]; then
        echo "Пинг $target_address не удался."
        ((failures++))  # Увеличиваем счетчик неудач
    else
        echo "Пинг $target_address успешен: $ping_time мс."
        failures=0  # Сбрасываем счетчик неудач
    fi

    # Проверка на 3 последовательные неудачи
    if [ "$failures" -ge "$max_failures" ]; then
        echo "Превышено максимальное количество неудачных попыток."
        break  # Выход из цикла
    fi

    # Задержка 1 секунда
    sleep 1
done

