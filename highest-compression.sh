#!/bin/bash

tar -cf - ${@:2} | xz -9 -c - > $1.tar.xz
