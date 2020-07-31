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
    ColumnOffset(column) {
        rotate([index * -column[concavity][angle], 0, 0])
        translate([0, 0, -concavityHeight(column[concavity])])
            children();
    }
}

module Column(column = columnParams()) {
    length = lastIndexOf(column);

    if (column[keys] > 1)
        for (index = [firstIndexOf(column) : 1 : length]) {
            color(CaseColor)
                ColumnFramePart(index, length - index, column);

            if (column[visualKey][show])
                ColumnPartOffset(index, column)
                    VisualKey(column[visualKey][rotation],
                        column[visualKey][pressed]);
        }
}

module ColumnFramePart(index, left, column) {
    ColumnPartOffset(index, column)
        SwitchPlace(column[placeSizes]);

    ColumnPart(index, LS, column);
    ColumnPart(index, RS, column);

    if (index == firstIndexOf(column))
        ColumnPart(index, TS, column);
    if (left == 0)
        ColumnPart(index, BS, column);

    if (index > firstIndexOf(column))
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
        ? firstIndexOf(column2)
        : firstIndexOf(column1);

    color(CaseColor)
    for (index = [0 + startIndex : length])
        if (chess)
            ColumnChessBridgePart(index, column1, column2, left, length > index);
        else
            ColumnBridgePart(index, column1, column2, left, length > index);
}

module ColumnBridgePart(index, column1, column2, left = false, addsConnector = true) {
    hull() {
        ColumnPart(index, left ? LS : RS, column1);
        ColumnPart(index, left ? RS : LS, column2);
    }

    if (addsConnector)
        hull() {
            ColumnPart(index, left ? LBS : RBS, column1);
            ColumnPart(index, left ? RBS : LBS, column2);
        }
}

module ColumnChessBridgePart(index, column1, column2, left = false, addsConnector = true) {
    hull() {
        ColumnPart(index, left ? RS : LS, column1);
        ColumnPart(index, left ? LBS : RBS, column2);
    }

    if (addsConnector) {
        hull() {
            ColumnPart(index + 1, left ? RTS : LTS, column1);
            ColumnPart(index + 1, left ? LS : RS, column2);
        }
    }
}

module ColumnPart(index, type, column) {
    hull() {
        if (type == LS) {
            ColumnPartPillars(index, column, [LT, LB]);
        } else if (type == LTS) {
            ColumnPartPillars(index, column, LT);
            ColumnPartPillars(index - 1, column, LB);
        } else if (type == LBS) {
            ColumnPartPillars(index, column, LB);
            ColumnPartPillars(index + 1, column, LT);
        } else if (type == RS) {
            ColumnPartPillars(index, column, [RT, RB]);
        } else if (type == RTS) {
            ColumnPartPillars(index, column, RT);
            ColumnPartPillars(index - 1, column, RB);
        } else if (type == RBS) {
            ColumnPartPillars(index, column, RB);
            ColumnPartPillars(index + 1, column, RT);
        } else if (type == TS) {
            ColumnPartPillars(index, column, [LT, RT]);
        } else if (type == BS) {
            ColumnPartPillars(index, column, [LB, RB]);
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

module ColumnFirstBorder(column, angles, offset = [0, 0, 0, 0],
    thickness = SwitchBorderThickness, height = SwitchBorderHeight,
    space = KeycapBorderSpace, caseThickness = CaseThickness)
{
    hull()
    ColumnPartOffset(firstIndexOf(column), column)
        SwitchBorderPillars(angles, offset,
            thickness, height, space, caseThickness);
}

module ColumnLastBorder(column, angles, offset = [0, 0, 0, 0],
    thickness = SwitchBorderThickness, height = SwitchBorderHeight,
    space = KeycapBorderSpace, caseThickness = CaseThickness)
{
    hull()
    ColumnPartOffset(lastIndexOf(column), column)
        SwitchBorderPillars(angles, offset,
            thickness, height, space, caseThickness);
}

module ColumnFirstPillars(column, angles, offset = [0, 0, 0, 0],
    thickness = 1, height = CaseThickness, space = KeycapSpace)
{
    ColumnPartPillars(firstIndexOf(column), column,
        angles, offset, thickness, height, space);
}

module ColumnLastPillars(column, angles, offset = [0, 0, 0, 0],
    thickness = 1, height = CaseThickness, space = KeycapSpace)
{
    ColumnPartPillars(lastIndexOf(column), column,
        angles, offset, thickness, height, space);
}

module ColumnPartPillars(index, column, angles, offset = [0, 0, 0, 0],
    thickness = 1, height = CaseThickness, space = KeycapSpace)
{
    ColumnPartOffset(index, column)
        SwitchPlacePillars(angles, column[placeSizes] + offset,
            thickness, height, space);
}

function firstIndexOf(column) = column[startIndex];

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