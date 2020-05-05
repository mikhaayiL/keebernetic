/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

include <column.scad>

ShowKeys    = false; // visual toggle
PressedKeys = false; // visual state of keycaps


LittleC2 = columnParams(
    keys       = 2,
    offset     = [-59.4, -17.73, 13],
    degrees    = [-12.8565, 20, 0],
    placeSizes = [-0.5, -0.5],
    visualKey  = visualKeyParams(rotation = 90));

LittleC3 = columnParams(
    keys       = 3,
    offset     = [-38, -7, 8],
    placeSizes = [-0.5, -1.5],
    visualKey  = visualKeyParams(rotation = -90));

RingC4 = columnParams(
    keys       = 4,
    offset     = [-19, -3, 3],
    placeSizes = [-0.5, -1.5],
    visualKey  = visualKeyParams(rotation = -90));

MiddleC4 = columnParams(
    keys       = 4,
    placeSizes = [-0.5, -0.5]);

IndexC4 = columnParams(
    keys       = 4,
    offset     = [19, -3, 4],
    placeSizes = [-1.5, -0.5],
    visualKey  = visualKeyParams(rotation = 90));

IndexC3 = columnParams(
    keys       = 3,
    offset     = [38, -5, 6],
    placeSizes = [-1.5, -0.5],
    visualKey  = visualKeyParams(rotation = 90));

IndexC2 = columnParams(
    keys       = 2,
    offset     = [59.4, -15.73, 11],
    degrees    = [-12.8565, -20, 0],
    placeSizes = [-0.5, -0.5],
    visualKey  = visualKeyParams(rotation = -90));


ThumbC3 = columnParams(
    keys       = 3,
    placeSizes = [-0.5, -0.5],
    concavity  = concavityParams(base = 21));

ThumbC2 = columnParams(
    keys       = 2,
    offset     = [-22, -11.7, 5],
    degrees    = [-ConcavityAngle / 2, 20, 0],
    placeSizes = [-0.5, -0.5],
    concavity  = concavityParams(base = 21));


translate([0, 0, 10])
rotate([0, -5, 0])
Layout();

module Layout() {
    MainCluster();

    translate([72, -55, -1]) {
        rotate([25, -7, 30]) {
            ThumbCluster();
        }
    }
}

module MainCluster() {
    Column(LittleC2);
    ColumnBridge(LittleC3, LittleC2, true, true);
    Column(LittleC3);
    ColumnBridge(RingC4, LittleC3, true);
    Column(RingC4);
    ColumnBridge(MiddleC4, RingC4, true);
    Column(MiddleC4);
    ColumnBridge(MiddleC4, IndexC4);
    Column(IndexC4);
    ColumnBridge(IndexC4, IndexC3);
    Column(IndexC3);
    ColumnBridge(IndexC3, IndexC2, chess = true);
    Column(IndexC2);
}

module ThumbCluster() {
    Column(ThumbC3);
    Column(ThumbC2);
    ColumnBridge(ThumbC3, ThumbC2, true, true);
}


module ColumnBridge(column1, column2, left = false, chess = false) {
    length =
         chess && column1[keys] < column2[keys] ||
        !chess && column1[keys] > column2[keys]
            ? lastIndexOf(column2)
            : lastIndexOf(column1);

    startIndex =
         chess && column1[keys] < column2[keys] ||
        !chess && column1[keys] > column2[keys]
            ? column2[startIndex]
            : column1[startIndex];

    color(SwitchPlaceColor)
    for (index = [0 + startIndex : length])
        if (chess)
            ColumnChessBridgePart(index, column1, column2, left, index == startIndex);
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

module ColumnChessBridgePart(index, column1, column2, left = false, isFirst = false) {
    hull() {
        ColumnOffset(column1)
            ColumnPart(index, left ? LS : RS, column1);
        ColumnOffset(column2)
            ColumnPart(index, left ? RTS : LTS, column2);
    }

    if (!isFirst) {
        hull() {
            ColumnOffset(column1)
                ColumnPart(index, left ? LTS : RTS, column1);
            ColumnOffset(column2)
                ColumnPart(index - 1, left ? RS : LS, column2);
        }
    }
}