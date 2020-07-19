/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

// ShowExamples();

CaseThickness = 4; // thickness of case / switch place

SwitchBorderHeight    = 8; // border height which hides a switch
SwitchBorderThickness = 1; // thickness of switch border
SwitchTravelDistance  = 4; // 4mm is the popular distance
SwitchBottomHeight    = 5; // bottom height of the switch

KeycapSpace       = 19;  // space in which a keycap is placed
                         // default keycap sizes 18x18mm + 1mm between keycaps
KeycapTopWidth    = 14;  // top of the XDAS profile
KeycapHeight      = 8.8; // height of the XDAS profile
KeycapUpperHeight = 6.6; // upper height of the keycap above the switch place
KeycapLowerHeight = KeycapUpperHeight - SwitchTravelDistance; // and lower height
KeycapBorderSpace = KeycapSpace + 1; // adds an extra 1mm
                                     // to get 1mm between the border and the keycap

KeycapColor             = "#b40";
SwitchColor             = "#333";
CaseColor               = "#218";
AmoebaPcbColor          = "#fff";
PcbComponentsSpaceColor = "#0a0";
PillarsColor            = "#f00";

LT = 1; // top left pillar
RT = 2; // top right pillar
LB = 3; // bottom left pillar
RB = 4; // bottom right pillar

module ShowExamples(showParts = false) {
    Examples(showParts ? 25 : 0) {
        VisualKey(
            rotation = showParts ? 90 : 0,
            pressed = showParts);

        if (showParts) {
            SwitchPlace([1.5, 1.5, 1.5, 1.5]);
            color (CaseColor) {
                hull() SwitchBorderPillars([LT, RT]);
                hull() SwitchBorderPillars([LT, LB]);
                hull() SwitchBorderPillars([LB, RB]);
                hull() SwitchBorderPillars([RB, RT]);
            }
        }

        if (showParts) {
            SwitchPlacePillars([LT, RT, LB, RB], [-0.5, -0.5, -0.5, -0.5]);
            SwitchPlace([-1, -1, -1, -1]);
        } else {
            SwitchPlace([1.5, 1.5, 1.5, 1.5]);
            color (CaseColor) {
                hull() SwitchBorderPillars([LT, RT]);
                hull() SwitchBorderPillars([LT, LB]);
                hull() SwitchBorderPillars([LB, RB]);
                hull() SwitchBorderPillars([RB, RT]);
            }
        }
    }

    if (!showParts) ShowExamples(true);
}

module Examples(offset) {
    for (i = [0 : 1 : $children - 1])
        translate([offset * (i + 1), 0, 0]) 
        children(i);
}

module VisualKey(rotation = 0, pressed = false) {
    keycapStateHeight = pressed
        ? KeycapLowerHeight
        : KeycapUpperHeight;

    rotate([0, 0, rotation])
    translate([-9.5, -9, 0]) {
        translate([0.5, 0, keycapStateHeight]) Keycap();
        translate([1.7, 1.2, -SwitchBottomHeight]) Switch();
        translate([0, 0, -SwitchBottomHeight - 2]) AmoebaPcb();
        translate([9.5, 9, -SwitchBottomHeight - 3.3]) PcbComponentsSpace();
    }
}

// sizes: [left, right, top, bottom]
module SwitchPlace(sizes, height = CaseThickness, space = KeycapSpace) {
    color(CaseColor)
    difference() {
        hull() SwitchPlacePillars([LT, LB, RT, RB], sizes, .5, height, space);
        SwitchHoleInner();
    }
}

// angles: array of the angles
// sizes: [left, right, top, bottom]
module SwitchBorderPillars(
    angles,
    sizes = [0, 0, 0, 0],
    thickness = SwitchBorderThickness,
    height = SwitchBorderHeight,
    space = KeycapBorderSpace,
    caseThickness = CaseThickness)
{
    translate([0, 0, height])
    SwitchPlacePillars(angles, sizes, thickness,
        height + caseThickness, space + thickness * 2);
}

// angles: array of the angles
// sizes: [left, right, top, bottom]
module SwitchPlacePillars(angles, sizes, thickness = .5,
    height = CaseThickness, space = KeycapSpace)
{
    halfOfSpace = (space - thickness) / 2;

    positiveX = halfOfSpace + getValue(sizes[1]); // right
    positiveY = halfOfSpace + getValue(sizes[2]); // top

    negativeX = -halfOfSpace - getValue(sizes[0]); // left
    negativeY = -halfOfSpace - getValue(sizes[3]); // bottom

    heightValue = height / -2;

    color(PillarsColor)
    for (angle = angles)
        if (angle == LT)
            Pillar(thickness, height,
                [negativeX, positiveY, heightValue]);
        else if (angle == RT)
            Pillar(thickness, height,
                [positiveX, positiveY, heightValue]);
        else if (angle == LB)
            Pillar(thickness, height,
                [negativeX, negativeY, heightValue]);
        else if (angle == RB)
            Pillar(thickness, height,
                [positiveX, negativeY, heightValue]);
}

module Pillar(thickness, height, offset) {
    translate(offset)
    cube([thickness, thickness, height], true);
}

module SwitchHoleInner() {
    translate([0, 0, CaseThickness / -2])
    cube([14, 14, CaseThickness + 1], true);
}

module Keycap() {
    offset = (18 - KeycapTopWidth) / 2;
    points = [
        [0, 0],
        [18, 0],
        [KeycapTopWidth + offset, KeycapHeight],
        [offset, KeycapHeight]
    ];

    color(KeycapColor)
    TwoIntersectionFigure(points, 18);
}

module Switch() {
    mSwitchBottomHeight = SwitchBottomHeight + .01;
    mSwitchTopHeight = mSwitchBottomHeight + KeycapUpperHeight;

    top = [
        [15.6, SwitchBottomHeight],
        [12.8, mSwitchTopHeight],
        [2.8, mSwitchTopHeight],
        [0, SwitchBottomHeight]
    ];
    bottom = [
        [1.3, 0],
        [14.3, 0],
        [14.8, mSwitchBottomHeight],
        [0.8, mSwitchBottomHeight]
    ];

    color(SwitchColor)
    union() {
        TwoIntersectionFigure(top, 15.6);
        TwoIntersectionFigure(bottom, 15.6);
    }
}

module TwoIntersectionFigure(points, height) {
    intersection() {
        rotate([90, 0, 0])
        translate([0, 0, height * -1])
        linear_extrude(height)
            polygon(points);

        rotate([90, 0, 90])
        linear_extrude(height)
            polygon(points);
    }
}

module PcbComponentsSpace() {
    color(PcbComponentsSpaceColor)
    cylinder(3.33, 5, 5);
}

module AmoebaPcb() {
    color(AmoebaPcbColor)
    cube([19, 16.3, 1.6]);
}

function getValue(value, default = 0) =
    is_undef(value) ? default : value;