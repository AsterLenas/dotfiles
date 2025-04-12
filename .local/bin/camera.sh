#!/usr/bin/env bash

v4l2-ctl -c focus_automatic_continuous=0
v4l2-ctl -c focus_absolute=0
v4l2-ctl -c brightness=-64
