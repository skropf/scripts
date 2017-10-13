#!/bin/bash
say() { local IFS=+;/usr/bin/mpv "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$*&tl=en"; }
say $*
