#!/usr/bin/env bash
#
# Copyright (c) 2021 Autodesk, Inc.
#
# CONFIDENTIAL AND PROPRIETARY
#
# This work is provided "AS IS" and subject to the Shotgun Pipeline Toolkit
# Source Code License included in this distribution package. See LICENSE.
# By accessing, using, copying or modifying this work you indicate your
# agreement to the Shotgun Pipeline Toolkit Source Code License. All rights
# not expressly granted therein are reserved by Autodesk, Inc.

# The path to output all built .py files to:
UI_PYTHON_PATH=../python/tk_multi_breakdown2/ui

# The path to where the PySide binaries are installed
PYTHON_BASE="/Applications/Shotgun.app/Contents/Resources/Python/bin"

# Remove any problematic profiles from pngs.
for f in *.png; do mogrify $f; done

# Helper functions to build UI files
function build_qt {
    echo " > Building " $2

    # compile ui to python
    $1 $2 > $UI_PYTHON_PATH/$3.py

    # replace PySide imports with sgtk.platform.qt and remove line containing Created by date
    sed -i "" -e "s/from PySide import/from sgtk.platform.qt import/g" -e "/# Created:/d" $UI_PYTHON_PATH/$3.py
}

function build_ui {
    build_qt "${PYTHON_BASE}/python ${PYTHON_BASE}/pyside-uic --from-imports" "$1.ui" "$1"
}

function build_res {
    build_qt "${PYTHON_BASE}/pyside-rcc -py3" "$1.qrc" "$1_rc"
}


# build UI's:
echo "building user interfaces..."
build_ui dialog
build_ui file_group_widget

# build resources
echo "building resources..."
build_res resources
