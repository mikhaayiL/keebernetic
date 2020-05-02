/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

include <key.scad>

// ShowExamples();

ShowKeys    = true;  // visual toggle
PressedKeys = false; // visual state of keycaps
ConcavityAngle = 25.713;

// column concavity params
function concavityParams(
    angle      = ConcavityAngle,    // tilt angle of adjacent key
    base       = KeycapSpace,       // space of keycap bottom side
                                    // default keycap sizes 18x18mm + 1mm between keycaps
) = [base, angle];

// array pointers for column concavity params
base  = 0;
angle = 1;

module ShowExamples() {
    Column(13);
}

module ColumnPartOffset(index, concavity) {
    rotate([index * -concavity[angle], 0, 0])
    translate([0, 0, -concavityHeight(concavity)])
        children();
}

module Column(keys, concavity = concavityParams()) {
    for (index = [0 : 1 : keys]) {
        if (ShowKeys)
            ColumnPartOffset(index, concavity)
                VisualKey(pressed = PressedKeys);
    }
}

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