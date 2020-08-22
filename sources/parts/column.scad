/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

include <key.scad>

ConcavityAngle = 25.713; // default concavity angle
DoubleConvexHullValue = 0;

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

module ColumnVisualKeys(column, pressed = false) {
    Column(column)
        VisualKey(column[key][rotation], pressed);
}

module ColumnParts(column) {
    last = lastIndexOf(column);
    first = firstIndexOf(column);

    for (index = [first : last]) {
        ColumnPartOffset(index, column)
            SwitchHoleInner();

        for (over = [0 : 1]) {
            ConvexHull(CaseColor, upwardOffset(over))
                ColumnPartInner(index, column, [LS, RS], over);

            if (index > first)
                ConvexHull(CaseColor, upwardOffset(over))
                    ColumnPartInner(index, column, [LTS, RTS], over);
        }
    }
}

module ColumnBridge(column1, column2, left = false, chess = false) {
    last = column1[keys] > column2[keys]
        ? lastIndexOf(column2)
        : lastIndexOf(column1);

    first = column1[keys] > column2[keys]
        ? firstIndexOf(column2)
        : firstIndexOf(column1);

    for (over = [0 : 1]) {
        for (index = [first : last])
            if (chess) ColumnChessBridgePart(
                index, column1, column2, over, left, last > index);
            else ColumnBridgePart(
                index, column1, column2, over, left, last > index);

        if (chess) {
            ColumnChessBridgePart2to3(first, column1, column2, over, left, true);
            ColumnChessBridgePart2to3(last, column1, column2, over, left, false);
        } else if (column1[keys] == 3 && column2[keys] == 4)
            ColumnBridgePart3to4(column1, column2, over, false);
        else if (column1[keys] == 4 && column2[keys] == 3)
            ColumnBridgePart3to4(column2, column1, over, true);
    }
}

module ColumnBridgePart(index, column1, column2, over, left, connector) {
    ConvexHull(PillarsColor, upwardOffset(over)) {
        ColumnPartInner(index, column1, left ? LS : RS, over);
        ColumnPartInner(index, column2, left ? RS : LS, over);
    }

    if (connector)
        ConvexHull(PillarsColor, upwardOffset(over)) {
            ColumnPartInner(index, column1, left ? LBS : RBS, over);
            ColumnPartInner(index, column2, left ? RBS : LBS, over);
        }
}

module ColumnChessBridgePart(index, column1, column2, over, left, connector) {
    ConvexHull(PillarsColor, upwardOffset(over)) {
        ColumnPartInner(index, column1, left ? RS : LS, over);
        ColumnPartInner(index, column2, left ? LBS : RBS, over);
    }

    if (connector)
        ConvexHull(PillarsColor, upwardOffset(over)) {
            ColumnPartInner(index + 1, column1, left ? RTS : LTS, over);
            ColumnPartInner(index + 1, column2, left ? LS : RS, over);
        }
}

module ColumnChessBridgePart2to3(index, column1, column2, over, left, first) {
    ConvexHull(PillarsColor, upwardOffset(over)) {
        ColumnPartInner(index + (first ? 0 : 1), column2, left ? LS : RS, over);
        if (first) ColumnPart(index, column1, left ? RT : LT, over);
        else ColumnPart(index, column1, left ? RB : LB, over);
    }
}

module ColumnBridgePart3to4(column1, column2, over, left) {
    ConvexHull(PillarsColor, upwardOffset(over)) {
        ColumnPart(lastIndexOf(column1), column1, left ? LB : RB, over);
        ColumnPartInner(lastIndexOf(column2), column2, left ? RTS : LTS, over);
        ColumnPartInner(lastIndexOf(column2), column2, left ? RS : LS, over);
    }
}

module ColumnPartInner(index, column, types, over) {
    ConvexHull(PillarsColor)
    for (type = types)
        if (type == LS) {
            ColumnPart(index, column, [LT, LB], over);
        } else if (type == LTS) {
            ColumnPart(index, column, LT, over);
            ColumnPart(index - 1, column, LB, over);
        } else if (type == LBS) {
            ColumnPart(index, column, LB, over);
            ColumnPart(index + 1, column, LT, over);
        } else if (type == RS) {
            ColumnPart(index, column, [RT, RB], over);
        } else if (type == RTS) {
            ColumnPart(index, column, RT, over);
            ColumnPart(index - 1, column, RB, over);
        } else if (type == RBS) {
            ColumnPart(index, column, RB, over);
            ColumnPart(index + 1, column, RT, over);
        } else if (type == TS) {
            ColumnPart(index, column, [LT, RT], over);
        } else if (type == BS) {
            ColumnPart(index, column, [LB, RB], over);
        }
}

module ColumnPart(index, column, corners, over = true) {
    ColumnPartOffset(index, column)
        if (over) OverKeyInner(corners, column[key][top]);
        else UnderKeyInner(corners, column[key][bottom]);
}

function getConvexHullValue(positive = true) =
    positive ? DoubleConvexHullValue : -DoubleConvexHullValue;

function upwardOffset(positive = true) =
    [0, 0, getConvexHullValue(positive)];

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