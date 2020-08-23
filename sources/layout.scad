/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

include <parts/column.scad>

LittleC2      = columnParams(
    keys      = 2,
    offset    = [-59.4, -17.73, 13],
    degrees   = [ConcavityAngle / -2, 20, 0],
    key       = keyParams(
        [-0.5, -0.5, -0.5, -0.5],
        [0, -0.5, 1, 1],
        90));

LittleC3      = columnParams(
    keys      = 3,
    offset    = [-38, -7, 8],
    key       = keyParams(
        [-0.5, -1.5, -0.5, -0.5],
        [-0.5, -2.5, 1, 1],
        -90));

RingC4        = columnParams(
    keys      = 4,
    offset    = [-19, -3, 3],
    key       = keyParams(
        [-1.5, -0.5, -0.5, -0.5],
        [1, -2.5, 1, 1],
        -90));

MiddleC4      = columnParams(
    keys      = 4,
    key       = keyParams(
        [-1, -1, -0.5, -0.5],
        [1, 1, 1, 1]));

IndexC4       = columnParams(
    keys      = 4,
    offset    = [19, -3, 4],
    key       = keyParams(
        [-0.5, -1.5, -0.5, -0.5],
        [-2.5, 0, 1, 1],
        90));

IndexC3       = columnParams(
    keys      = 3,
    offset    = [38, -5, 6],
    key       = keyParams(
        [-1, -0.5, -0.5, -0.5],
        [-2.5, -0.5, 1, 1],
        90));

IndexC2       = columnParams(
    keys      = 2,
    offset    = [59.4, -15.73, 11],
    degrees   = [ConcavityAngle / -2, -20, 0],
    key       = keyParams(
        [-0.5, -0.5, -0.5, -0.5],
        [-0.5, 0, 1, 1],
        -90));


MainCluster = [
    LittleC2,
    LittleC3,
    RingC4,
    MiddleC4,
    IndexC4,
    IndexC3,
    IndexC2
];



ThumbC3       = columnParams(
    keys      = 3,
    concavity = concavityParams(base = 21),
    key       = keyParams(
        [-0.5, -0.5, -0.5, -0.5],
        [-0.5, -0.5, -0.5, -0.5]));

ThumbC2       = columnParams(
    keys      = 2,
    offset    = [-22, -11.7, 5],
    degrees   = [-ConcavityAngle / 2, 20, 0],
    concavity = concavityParams(base = 21),
    key       = keyParams(
        [-0.5, -0.5, -0.5, -0.5],
        [-0.5, -0.5, -0.5, -0.5]));


ThumbCluster = [
    ThumbC2,
    ThumbC3
];