#!/bin/bash

assignProxy() {
    PROXY_ENV="http_proxy ftp_proxy https_proxy rsync_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY"
    NO_PROXY="no_proxy NO_PROXY"
    
    for envar in $PROXY_ENV
    do
        echo "export $envar=$1"
        export $envar=$1
    done
    
    for envar in $NO_PROXY
    do
        echo "export $envar=$2"
        export $envar=$2
    done
}

clrProxy() {
    assignProxy "" "" # This is what 'unset' does.
}

myProxy() {
    #user=YourUserName
    #read -p "Password: " -s pass &&  echo -e " "
    #proxy_value="http://$user:$pass@ProxyServerAddress:Port"
    proxy_value="http://127.0.0.1:8087"
    no_proxy_value="localhost,127.0.0.1"
    assignProxy $proxy_value $no_proxy_value
}

if (( $# > 0 ))
then
    if [[ _$1 == "_set" ]]; then
        myProxy
        echo "proxy env var set"
    elif [[ _$1 == "_unset" ]]; then
        clrProxy
        echo "proxy env var unset"    
    fi
else
    echo "Usage: ./proxy.sh set|unset"
fi
