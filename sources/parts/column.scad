/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

include <key.scad>

ConcavityAngle = 25.713; // default concavity angle

// column params
function columnParams(
    keys       = 0,                 // number of keys in a column
    offset     = [0, 0, 0],         // offset of column
    degrees    = [0, 0, 0],         // rotation of column
    startIndex = -1,                // the concavity is formed in a circle at 6 o'clock
    concavity  = concavityParams(), // column concavity params
    key        = keyParams()        // column key params
) = [keys, offset, degrees, startIndex, concavity, key];

// array pointers for column params
keys       = 0;
offset     = 1;
degrees    = 2;
startIndex = 3;
concavity  = 4;
key        = 5;

// column concavity params
function concavityParams(
    angle = ConcavityAngle, // tilt angle of adjacent key
    base  = KeycapSpace,    // space of keycap bottom side
) = [angle, base];

// array pointers for column concavity params
angle = 0;
base  = 1;

// column key params
function keyParams(
    top      = [0, 0, 0, 0], // top offsets of column switch place
    bottom   = [0, 0, 0, 0], // bottom offsets of column switch place
    rotation = 0             // rotation of column visual key
) = [top, bottom, rotation];

// array pointers for column key params
top      = 0;
bottom   = 1;
rotation = 2;

LS  = 0; // left side
RS  = 1; // right side
TS  = 2; // top side
BS  = 3; // bottom side
LTS = 4; // left top side
RTS = 5; // right top side
LBS = 6; // left bottom side
RBS = 7; // right bottom side

module ColumnOffset(column) {
    translate(column[offset])
    rotate(column[degrees])
    translate([0, 0, concavityHeight(column[concavity])])
        children();
}

module ColumnPartOffset(index, column) {
    ColumnOffset(column) {
        rotate([index * -column[concavity][angle], 0, 0])
        translate([0, 0, -concavityHeight(column[concavity])])
            children();
    }
}

module Column(column) {
    last = lastIndexOf(column);
    first = firstIndexOf(column);

    for (index = [first : last])
        ColumnPartOffset(index, column)
            children();
}

module ColumnFirst(column) {
    first = firstIndexOf(column);
    ColumnPartOffset(first, column)
        children();
}

module ColumnLast(column) {
    last = lastIndexOf(column);
    ColumnPartOffset(last, column)
        children();
}

module ColumnVisualKeys(column, pressed = false) {
    Column(column)
        VisualKey(column[key][rotation], pressed);
}

module ColumnSwitchHoles(column) {
    Column(column)
        SwitchHoleInner();
}

module ColumnFirstParts(column, corners, offsets, height) {
    ColumnFirst(column)
        KeyTopInner(corners, column[key][top] + parseOffsetsDefault(offsets),
            height ? height : MinimalValue);
}

module ColumnLastParts(column, corners, offsets, height) {
    ColumnLast(column)
        KeyTopInner(corners, column[key][top] + parseOffsetsDefault(offsets),
            height ? height : MinimalValue);
}

module ConvexHullColumnFirst(argsArray, offset, color = OutlinesColor) {
    ConvexHull(color, offset)
        for (args = argsArray)
            ColumnFirstParts(args[0], args[1], args[2], args[3]);
}

module ConvexHullColumnLast(argsArray, offset, color = OutlinesColor) {
    ConvexHull(color, offset)
        for (args = argsArray)
            ColumnLastParts(args[0], args[1], args[2], args[3]);
}

module ColumnParts(column, top, offset) {
    last = lastIndexOf(column);
    first = firstIndexOf(column);

    color(CaseColor)
    for (index = [first : last]) {
        ColumnPartInner(index, column, [LS, RS], top, offset);
        if (index > first)
            ColumnPartInner(index, column, [LTS, RTS], top, offset);
    }
}

module ColumnPart(index, column, notFirst, top, offset) {
    ColumnPartInner(index, column, [LS, RS], top, offset);
    if (notFirst)
        ColumnPartInner(index, column, [LTS, RTS], top, offset);
}

module ColumnBridge(column1, column2, top, left = false, chess = false, offset) {
    last = column1[keys] > column2[keys]
        ? lastIndexOf(column2)
        : lastIndexOf(column1);

    first = column1[keys] > column2[keys]
        ? firstIndexOf(column2)
        : firstIndexOf(column1);

    for (index = [first : last])
        if (chess) ColumnChessBridgePart(
            index, column1, column2, top, left, last > index, offset);
        else ColumnBridgePart(
            index, column1, column2, top, left, last > index, offset);

    if (chess) {
        ColumnChessBridgePart2to3(first, column1, column2, top, left, true, offset);
        ColumnChessBridgePart2to3(last, column1, column2, top, left, false, offset);
    } else if (column1[keys] == 3 && column2[keys] == 4)
        ColumnBridgePart3to4(column1, column2, top, false, offset);
    else if (column1[keys] == 4 && column2[keys] == 3)
        ColumnBridgePart3to4(column2, column1, top, true, offset);
}

module ColumnBridgePart(index, column1, column2, top, left, connector, offset) {
    ConvexHull(PillarsColor) {
        ColumnPartInner(index, column1, left ? LS : RS, top, offset);
        ColumnPartInner(index, column2, left ? RS : LS, top, offset);
    }

    if (connector)
        ConvexHull(PillarsColor) {
            ColumnPartInner(index, column1, left ? LBS : RBS, top, offset);
            ColumnPartInner(index, column2, left ? RBS : LBS, top, offset);
        }
}

module ColumnChessBridgePart(index, column1, column2, top, left, connector, offset) {
    ConvexHull(PillarsColor) {
        ColumnPartInner(index, column1, left ? RS : LS, top, offset);
        ColumnPartInner(index, column2, left ? LBS : RBS, top, offset);
    }

    if (connector)
        ConvexHull(PillarsColor) {
            ColumnPartInner(index + 1, column1, left ? RTS : LTS, top, offset);
            ColumnPartInner(index + 1, column2, left ? LS : RS, top, offset);
        }
}

module ColumnChessBridgePart2to3(index, column1, column2, top, left, first, offset) {
    ConvexHull(PillarsColor, offset) {
        ColumnPartInner(index + (first ? 0 : 1), column2, left ? LS : RS, top);
        if (first) ColumnKey(index, column1, left ? RT : LT, top);
        else ColumnKey(index, column1, left ? RB : LB, top);
    }
}

module ColumnBridgePart3to4(column1, column2, top, left, offset) {
    ConvexHull(PillarsColor, offset) {
        ColumnKey(lastIndexOf(column1), column1, left ? LB : RB, top);
        ColumnPartInner(lastIndexOf(column2), column2, left ? RTS : LTS, top);
        ColumnPartInner(lastIndexOf(column2), column2, left ? RS : LS, top);
    }
}

module ColumnPartInner(index, column, types, top, offset) {
    ConvexHull(PillarsColor, offset)
    for (type = types)
        if (type == LS) {
            ColumnKey(index, column, [LT, LB], top);
        } else if (type == LTS) {
            ColumnKey(index, column, LT, top);
            ColumnKey(index - 1, column, LB, top);
        } else if (type == LBS) {
            ColumnKey(index, column, LB, top);
            ColumnKey(index + 1, column, LT, top);
        } else if (type == RS) {
            ColumnKey(index, column, [RT, RB], top);
        } else if (type == RTS) {
            ColumnKey(index, column, RT, top);
            ColumnKey(index - 1, column, RB, top);
        } else if (type == RBS) {
            ColumnKey(index, column, RB, top);
            ColumnKey(index + 1, column, RT, top);
        } else if (type == TS) {
            ColumnKey(index, column, [LT, RT], top);
        } else if (type == BS) {
            ColumnKey(index, column, [LB, RB], top);
        }
}

module ColumnKey(index, column, corners, isTop = true) {
    ColumnPartOffset(index, column)
        if (isTop) KeyTopInner(corners, column[key][top]);
        else KeyBottomInner(corners, column[key][bottom]);
}

function firstIndexOf(column) =
    column[startIndex];

function lastIndexOf(column) =
    column[keys] - 1 + firstIndexOf(column);

function concavityHeight(concavity = concavityParams()) =
    isoscelesTriangleHeight(concavity[angle], concavity[base]) + KeycapUpperHeight;

function isoscelesTriangleHeight(angle, base) =
    bisectorLength(
        hypotenuse(angle / 2, base / 2),
        angle);

function bisectorLength(hypotenuse, angle) =
    hypotenuse * cos(angle / 2);

function hypotenuse(angle, cathetus) =
    cathetus / sin(angle);