/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

SwitchPlaceThickness = 4; // thickness of case / switch place
SwitchTravelDistance = 4; // 4mm is the popular distance
SwitchBottomHeight   = 5; // bottom height of the switch

KeycapSpace    = 19.001; // space in which a keycap is placed
                         // default keycap sizes 18x18mm + 1mm between keycaps
KeycapTopWidth    = 14;  // top of the XDAS profile
KeycapHeight      = 8.8; // height of the XDAS profile
KeycapUpperHeight = 6.6; // upper height of the keycap above the switch place
KeycapLowerHeight = KeycapUpperHeight - SwitchTravelDistance; // and lower height

KeycapColor             = "#cb9";
SwitchColor             = "#333";
CaseColor               = "#080";
AmoebaPcbColor          = "#fff";
PcbComponentsSpaceColor = "#f0c";
PillarsColor            = "#f00";

L = 0; // left
R = 1; // right
T = 2; // top
B = 3; // bottom

LT = 0; // top left corner
RT = 1; // top right corner
LB = 2; // bottom left corner
RB = 3; // bottom right corner

// corners: corner or array of the corners
// offsets: [left, right, top, bottom]
module SwitchPlacePillars(corners, offsets, height = .001, space = KeycapSpace) {
    thickness = .001;
    halfOfSpace = (space - thickness) / 2;
    halfOfHeight = height / 2;

    cornerOffsets = getCornerOffsets(
        parseOffsets(offsets, halfOfSpace),
        halfOfHeight);

    color(PillarsColor)
    for (corner = corners)
        Pillar(thickness, height, cornerOffsets[corner]);
}

module Pillar(thickness, height, offset) {
    translate(offset)
    cube([thickness, thickness, height], true);
}

module SwitchHoleInner() {
    color(CaseColor)
    translate([0, 0, SwitchPlaceThickness / -2])
    cube([14, 14, SwitchPlaceThickness + 1], true);
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

function getCornerOffsets(offsets, height = 0) = [
    [offsets[L], offsets[T], height],
    [offsets[R], offsets[T], height],
    [offsets[L], offsets[B], height],
    [offsets[R], offsets[B], height],
];

function parseOffsets(offsets, halfOfSpace = 0) = [
   -halfOfSpace - parseValue(offsets[L]),
    halfOfSpace + parseValue(offsets[R]),
    halfOfSpace + parseValue(offsets[T]),
   -halfOfSpace - parseValue(offsets[B]),
];

function parseValue(value, default = 0) =
    is_undef(value) ? default : value;