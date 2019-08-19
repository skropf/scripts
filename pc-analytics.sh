#!/bin/bash

sensors | awk '/Tdie/ {print $2}'
lscpu | awk '/CPU MHz/ {print $3}'
