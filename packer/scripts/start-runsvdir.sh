#!/bin/bash

set -ex

/usr/sbin/runsvdir-start <&- >/dev/null 2>&1 &
