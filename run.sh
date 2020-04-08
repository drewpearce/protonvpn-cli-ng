#!/bin/bash

# Set params
while [ -n "$1" ]
do
    case "$1" in
        --user)
            PROTON_USER="$2"
            shift
            ;;
        --pass)
            PROTON_PASS="$2"
            shift
            ;;
        --tier)
            PROTON_TIER="$2"
            shift
            ;;
        -p)
            PROTON_PROTOCOL="$2"
            shift
            ;;
        --protocol)
            PROTON_PROTOCOL="$2"
            shift
            ;;
        -m)
            MODE="$2"
            shift
            ;;
        -n)
            NAME="$2"
            shift
            ;;
        -e)
            READ_ENV=TRUE;;
        *) echo "Param $1 not recognized.";;
    esac
    if [ "$READ_ENV" = TRUE ]
    then
        export $(egrep -v '^#' .env | xargs)
        break
    fi

    shift
done

function validate_exists () {
    local NAME="$1"
    local VALUE="$2"
    if [ -z $VALUE ]
    then
        echo "$NAME is a required paramter."
        exit 1
    fi
}

function validate_values () {
    if [ "$PROTON_TIER" != "Free" ] && [ "$PROTON_TIER" != "Basic" ] && [ "$PROTON_TIER" != "Plus" ] && [ "$PROTON_TIER" != "Free" ]
    then
        echo -e "Invalid value '$PROTON_TIER' for PROTON_TIER.\nMust be one of: Free, Basic, Plus, Visionary."
        exit 1
    fi

    if [ "$PROTON_PROTOCOL" != "TCP" ] && [ "$PROTON_PROTOCOL" != "UDP" ]
    then
        echo -e "Invalide value '$PROTON_PROTOCOL' for PROTON_PROTOCOL.\nMust be one of: TCP, UDP."
        exit 1
    fi
}

function validate () {
    validate_exists "PROTON_USER" $PROTON_USER
    validate_exists "PROTON_PASS" $PROTON_PASS
    validate_exists "PROTON_TIER" $PROTON_TIER
    validate_exists "PROTON_PROTOCOL" $PROTON_PROTOCOL
    validate_exists "NAME" $NAME
}

validate
validate_values

docker run -d --rm --name "$NAME" --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -v /dev/net:/dev/net:z -e PROTON_USER="$PROTON_USER" -e PROTON_PASS="$PROTON_PASS" -e PROTON_TIER="$PROTON_TIER" -e PROTON_PROTOCOL="$PROTON_PROTOCOL" -e MODE="$MODE" drewpearce/protonvpn
