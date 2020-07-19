/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

include <key.scad>

// ShowExamples();

ShowKeys       = true;   // visual toggle
PressedKeys    = false;  // visual state of keycaps
ConcavityAngle = 25.713; // default concavity angle

// column params
function columnParams(
    keys       = 0,         // number of keys in a column
    offset     = [0, 0, 0], // offset of column
    degrees    = [0, 0, 0], // rotation of column
    startIndex = -1,        // the concavity is formed in a circle at 6 o'clock
    placeSizes = [0, 0, 0, 0],      // offset of column switch place
    concavity  = concavityParams(), // column concavity params
    visualKey  = visualKeyParams()  // column visual key params
) = [keys, offset, degrees, startIndex, placeSizes, concavity, visualKey];

// array pointers for column params
keys       = 0;
offset     = 1;
degrees    = 2;
startIndex = 3;
placeSizes = 4;
concavity  = 5;
visualKey  = 6;

// column concavity params
function concavityParams(
    angle = ConcavityAngle, // tilt angle of adjacent key
    base  = KeycapSpace,    // space of keycap bottom side
) = [base, angle];

// array pointers for column concavity params
base  = 0;
angle = 1;

// column visual key params
function visualKeyParams(
    rotation = 0,          // rotation of column key
    show     = ShowKeys,   // visual toggle to show the column keys
    pressed  = PressedKeys // visual toggle to change pressed state of the column keys
) = [rotation, show, pressed];

// array pointers for column visual key params
rotation = 0;
show     = 1;
pressed  = 2;

LS  = 1; // left side
RS  = 2; // right side
TS  = 3; // top side
BS  = 4; // bottom side
LTS = 5; // left top side
RTS = 6; // right top side
LBS = 7; // left bottom side
RBS = 8; // right bottom side

module ShowExamples() {
    Column(
        columnParams(
            keys = 5,
            offset = [8, 0, 0],
            degrees = [0, -45, 0],
            startIndex = -2,
            visualKey = visualKeyParams(-90, true, true)));

    Examples(25) {
        Column(
            columnParams(
                keys = 5,
                offset = [0, 0, 20],
                startIndex = -2,
                concavity = concavityParams(angle = 15)));
        Column(
            columnParams(
                keys = 5,
                startIndex = -2,
                offset = [0, 0, 35]));
        Column(
            columnParams(
                keys = 5,
                offset = [0, 0, 50],
                startIndex = -2,
                concavity = concavityParams(
                    angle = 40,
                    base = 21.5)));
        Column(
            columnParams(
                keys = 15,
                visualKey = visualKeyParams(show = false)));
    }
}

module ColumnOffset(column) {
    translate(column[offset])
    rotate(column[degrees])
    translate([0, 0, concavityHeight(column[concavity])])
        children();
}

module ColumnPartOffset(index, column) {
    rotate([index * -column[concavity][angle], 0, 0])
    translate([0, 0, -concavityHeight(column[concavity])])
        children();
}

module ColumnPartFirst(column) {
    ColumnOffset(column)
    ColumnPartOffset(column[startIndex], column)
        children();
}

module ColumnPartLast(column) {
    ColumnOffset(column)
    ColumnPartOffset(lastIndexOf(column), column)
        children();
}

module Column(column = columnParams()) {
    length = lastIndexOf(column);

    if (column[keys] > 1)
    ColumnOffset(column) {
        for (index = [column[startIndex] : 1 : length]) {
            color(CaseColor)
                ColumnFramePart(index, length - index, column);

            if (column[visualKey][show])
                ColumnPartOffset(index, column)
                    VisualKey(column[visualKey][rotation], column[visualKey][pressed]);
        }
    }
}

module ColumnFramePart(index, left, column) {
    ColumnPartOffset(index, column)
        SwitchPlace(column[placeSizes]);

    ColumnPart(index, LS, column);
    ColumnPart(index, RS, column);

    if (index == column[startIndex])
        ColumnPart(index, TS, column);
    if (left == 0)
        ColumnPart(index, BS, column);

    if (index > column[startIndex])
        hull() {
            ColumnPart(index, LTS, column);
            ColumnPart(index, RTS, column);
        }
}

module ColumnBridge(column1, column2, left = false, chess = false) {
    length = column1[keys] > column2[keys]
        ? lastIndexOf(column2)
        : lastIndexOf(column1);

    startIndex = column1[keys] > column2[keys]
        ? column2[startIndex]
        : column1[startIndex];

    color(CaseColor)
    for (index = [0 + startIndex : length])
        if (chess)
            ColumnChessBridgePart(index + 1, column1, column2, left, length > index);
        else
            ColumnBridgePart(index, column1, column2, left, length > index);
}

module ColumnBridgePart(index, column1, column2, left = false, addsConnector = true) {
    hull() {
        ColumnOffset(column1)
            ColumnPart(index, left ? LS : RS, column1);

        ColumnOffset(column2)
            ColumnPart(index, left ? RS : LS, column2);
    }

    if (addsConnector)
        hull() {
            ColumnOffset(column1)
                ColumnPart(index, left ? LBS : RBS, column1);

            ColumnOffset(column2)
                ColumnPart(index, left ? RBS : LBS, column2);
        }
}

module ColumnChessBridgePart(index, column1, column2, left = false, addsConnector = true) {
    hull() {
        ColumnOffset(column1)
            ColumnPart(index, left ? LTS : RTS, column1);
        ColumnOffset(column2)
            ColumnPart(index - 1, left ? RS : LS, column2);
    }

    if (addsConnector) {
        hull() {
            ColumnOffset(column1)
                ColumnPart(index, left ? LS : RS, column1);
            ColumnOffset(column2)
                ColumnPart(index, left ? RTS : LTS, column2);
        }
    }
}

module ColumnPart(index, type, column) {
    hull() {
        if (type == LS) {
            ColumnPartPillars(index, [LT, LB], column);
        } else if (type == LTS) {
            ColumnPartPillars(index, LT, column);
            ColumnPartPillars(index - 1, LB, column);
        } else if (type == LBS) {
            ColumnPartPillars(index, LB, column);
            ColumnPartPillars(index + 1, LT, column);
        } else if (type == RS) {
            ColumnPartPillars(index, [RT, RB], column);
        } else if (type == RTS) {
            ColumnPartPillars(index, RT, column);
            ColumnPartPillars(index - 1, RB, column);
        } else if (type == RBS) {
            ColumnPartPillars(index, RB, column);
            ColumnPartPillars(index + 1, RT, column);
        } else if (type == TS) {
            ColumnPartPillars(index, [LT, RT], column);
        } else if (type == BS) {
            ColumnPartPillars(index, [LB, RB], column);
        }
    }
}

module ColumnFirstBorderIntersection(
    column1, angles1, column2, angles2, height1)
{
    intersection() {
        ColumnFirstBorder(column1, angles1, height = height1);
        ColumnFirstBorder(column2, angles2);
    }
}

module ColumnLastBorderIntersection(
    column1, angles1, column2, angles2, height1)
{
    intersection() {
        ColumnLastBorder(column1, angles1, height = height1);
        ColumnLastBorder(column2, angles2);
    }
}

module ColumnFirstBorder(column, angles, offset, height = SwitchBorderHeight) {
    hull()
    ColumnPartFirst(column)
        SwitchBorderPillars(angles, offset, height = height);
}

module ColumnLastBorder(column, angles, offset, height = SwitchBorderHeight) {
    hull()
    ColumnPartLast(column)
        SwitchBorderPillars(angles, offset, height = height);
}

module ColumnFirstPillars(column, angles, offset = [0, 0, 0, 0],
    thickness = CaseThickness, height = CaseThickness)
{
    ColumnPartFirst(column)
        SwitchPlacePillars(
            angles, column[placeSizes] + offset, thickness, height);
}

module ColumnLastPillars(column, angles, offset = [0, 0, 0, 0],
    thickness = CaseThickness, height = CaseThickness)
{
    ColumnPartLast(column)
        SwitchPlacePillars(
            angles, column[placeSizes] + offset, thickness, height);
}

module ColumnPartPillars(index, angles, column) {
    ColumnPartOffset(index, column)
        SwitchPlacePillars(angles, column[placeSizes], 1);
}

function lastIndexOf(column) =
    column[keys] - 1 + column[startIndex];

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