#!/bin/bash

(setxkbmap -query | grep -q "layout:\s\+us") && setxkbmap latam || setxkbmap us
