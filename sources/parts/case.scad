/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

include <column.scad>

ShowKeys    = false; // visual toggle
PressedKeys = false; // visual state of keycaps

module CaseOffset() {
    translate([-10, 5, 20])
        rotate([10, -7, 0])
            children();
}

module ThumbClusterOffset() {
    translate([69, -58, 1])
        rotate([18, -7, 23])
            children();
}

module VisualKeyLayout(columns) {
    for (column = columns)
        ColumnVisualKeys(column, PressedKeys);
}

module Layout(columns) {
    LayoutPart(columns, true, [12.5, 17.5, 100]);
    LayoutPart(columns, false, [-12.5, -17.5, -100]);

    for (column = columns)
        ColumnSwitchHoles(column);
}

module LayoutPart(columns, top, offset) {
    length = len(columns) - 1;

    for (index = [0 : length]) {
        column = columns[index];

        ColumnParts(column, top, offset);

        if (index < length - 1 || length < 2 && index == 0)
            ColumnBridge(columns[index], columns[index + 1], top, index == 0, index == 0, offset);
        else if (index < length)
            ColumnBridge(columns[index + 1], columns[index], top, chess = true, offset = offset);
    }
}

function upwardOffset() =
    [12.5, 17.5, 100];