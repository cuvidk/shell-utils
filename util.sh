#!/bin/sh

g_err_flag=0

setup_output() {
    WORKING_DIR="$(realpath "$(dirname "${0}")")"
    if [ -z "${OUT}" ]; then
        export OUT_REDIRECTED="$(realpath "${0}").log"
        [ -e /proc/$$/fd/1 ] && export OUT="$(realpath /proc/$$/fd/1)"
        exec 1>"${OUT_REDIRECTED}" 2>&1
    fi
}

print_msg() {
    if [ -n "${OUT}" ]; then
        echo -n -e "$1">>${OUT}
    else
        echo -n -e "$1"
    fi
}

perform_task() {
    local task=$1
    local message=$2
    [ -n "${message}" ] && print_msg "${message}\r"
    echo "#################################################"
    echo "${message}"
    echo "#################################################"
    ${task}
    local ret=$?
    echo "#################################################"
    if [ ${ret} -eq 0 ]; then
        [ -n "${message}" ] && print_msg "[ OK ] ${message}\n"
    else
        [ -n "${message}" ] && print_msg "[ FAIL ] ${message}\n"
        g_err_flag=1
    fi
    return ${ret}
}

perform_task_arg() {
    local task=$1
    local arg=$2
    local message=$3
    [ -n "${message}" ] && print_msg "${message}\r"
    echo "#################################################"
    echo "${message}"
    echo "#################################################"
    ${task} ${arg}
    local ret=$?
    echo "#################################################"
    if [ ${ret} -eq 0 ]; then
        [ -n "${message}" ] && print_msg "[ OK ] ${message}\n"
    else
        [ -n "${message}" ] && print_msg "[ FAIL ] ${message}\n"
        g_err_flag=1
    fi
    return ${ret}
}

log_file_name() {
    echo "${OUT_REDIRECTED}"
}

check_for_errors() {
    if [ ${g_err_flag} -eq 1 ]; then
        return 1
    else
        return 0
    fi
}
