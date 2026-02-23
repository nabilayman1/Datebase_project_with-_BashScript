#!/usr/bin/bash
shopt -s extglob
dirname="$1"
firstchar=${dirname:0:1}
case ${firstchar} in
    !([a-zA-Z]) )
        exit 1
        ;; 
    *)
        case $dirname in
            +([a-zA-Z0-9" "]) )
                exit 0
            ;;    
            *)
               exit 2
            ;;
        esac
esac