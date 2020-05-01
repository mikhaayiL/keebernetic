/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

SwitchTravelDistance = 4; // 4mm is the popular distance
SwitchBottomHeight   = 5; // bottom height of the switch

KeycapTopWidth    = 14;  // top of the XDAS profile
KeycapHeight      = 8.8; // height of the XDAS profile
KeycapUpperHeight = 6.6; // upper height of the keycap above the switch place
KeycapLowerHeight = KeycapUpperHeight - SwitchTravelDistance; // and lower height

KeycapColor             = "#b40";
SwitchColor             = "#333";
AmoebaPcbColor          = "#fff";
PcbComponentsSpaceColor = "#0a0";

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