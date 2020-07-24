/*
    Copyright (c) 2020 mikhaayL

    This file is part of "keebernetic" project which is released under MIT License.
    Go to https://github.com/mikhaayL/keebernetic for full details.
*/

include <column.scad>

ShowKeys    = true;  // visual toggle
PressedKeys = false; // visual state of keycaps
ConvexHull  = true;


LittleC2       = columnParams(
    keys       = 2,
    offset     = [-59.4, -17.73, 13],
    degrees    = [-12.8565, 20, 0],
    placeSizes = [-0.5, -0.5, -0.5, -0.5],
    visualKey  = visualKeyParams(rotation = 90));

LittleC3       = columnParams(
    keys       = 3,
    offset     = [-38, -7, 8],
    placeSizes = [-0.5, -1.5, -0.5, -0.5],
    visualKey  = visualKeyParams(rotation = -90));

RingC4         = columnParams(
    keys       = 4,
    offset     = [-19, -3, 3],
    placeSizes = [-0.5, -1.5, -0.5, -0.5],
    visualKey  = visualKeyParams(rotation = -90));

MiddleC4       = columnParams(
    keys       = 4,
    placeSizes = [-0.5, -0.5, -0.5, -0.5]);

IndexC4        = columnParams(
    keys       = 4,
    offset     = [19, -3, 4],
    placeSizes = [-1.5, -0.5, -0.5, -0.5],
    visualKey  = visualKeyParams(rotation = 90));

IndexC3        = columnParams(
    keys       = 3,
    offset     = [38, -5, 6],
    placeSizes = [-1.5, -0.5, -0.5, -0.5],
    visualKey  = visualKeyParams(rotation = 90));

IndexC2        = columnParams(
    keys       = 2,
    offset     = [59.4, -15.73, 11],
    degrees    = [-12.8565, -20, 0],
    placeSizes = [-0.5, -0.5, -0.5, -0.5],
    visualKey  = visualKeyParams(rotation = -90));


ThumbC3        = columnParams(
    keys       = 3,
    placeSizes = [-0.5, -0.5, -0.5, -0.5],
    concavity  = concavityParams(base = 21));

ThumbC2        = columnParams(
    keys       = 2,
    offset     = [-22, -11.7, 5],
    degrees    = [-ConcavityAngle / 2, 20, 0],
    placeSizes = [-0.5, -0.5, -0.5, -0.5],
    concavity  = concavityParams(base = 21));


translate([0, 0, 10])
rotate([0, -5, 0])
Layout();

module Layout() {
    MainCluster();

    // translate([72, -55, -1]) {
    //     rotate([25, -7, 30]) {
    //         ThumbCluster();
    //     }
    // }
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

    LittleC2Border();
    MainClusterTS();
    MainClusterBS();
    IndexC2Border();
}

module ThumbCluster() {
    Column(ThumbC3);
    Column(ThumbC2);
    ColumnBridge(ThumbC3, ThumbC2, true, true);
}

module ConvexHull(hulling = ConvexHull, color = CaseColor) {
    if (hulling) color(color) hull() children();
    else children();
}

module MainClusterTS() {
    ConvexHull() {
        ColumnFirstBorder(LittleC3, LT);
        ColumnFirstPillars(LittleC3, LT, [0, 0, 5, 0], .1);
        ColumnFirstPillars(LittleC3, LT, [7, 0, 2, 0], 1);
    }

    ConvexHull() {
        ColumnFirstBorderIntersection(RingC4, [LT, LB], LittleC3, [LT, RT], 20);
        ColumnFirstBorder(LittleC3, LT);
        ColumnFirstBorder(RingC4, LT, height = 14.25);
    }

    ConvexHull() {
        ColumnFirstBorder(LittleC3, LT);
        ColumnFirstBorder(RingC4, LT, height = 14.25);
        ColumnFirstPillars(RingC4, LT, [0, 0, 5, 0], .1);
        ColumnFirstPillars(LittleC3, LT, [0, 0, 5, 0], .1);
    }

    ConvexHull() {
        ColumnFirstPillars(RingC4, LT, thickness = 1);
        ColumnFirstPillars(RingC4, LT, [1, 0, 2, 0], thickness = 1);
        ColumnFirstPillars(LittleC3, RT, thickness = 1);
        ColumnFirstPillars(LittleC3, RT, [0, 0, 2, 0], thickness = 1);
    }

    ConvexHull() {
        ColumnFirstPillars(LittleC3, [LT, RT], [3, 0, 0, 0], thickness = 1);
        ColumnFirstPillars(LittleC3, [LT, RT], [3, 0, 2, 0], thickness = 1);
    }



    ConvexHull() {
        intersection() {
            ColumnFirstBorder(MiddleC4, [LT, LB], height = 20);
            ColumnFirstBorder(RingC4, [LT, RT], height = 8.9);
        }
        ColumnFirstBorder(RingC4, LT);
        ColumnFirstBorder(RingC4, LT, height = 14.25);
        ColumnFirstBorder(MiddleC4, LT, height = 12.9);
    }

    ConvexHull() {
        ColumnFirstBorder(RingC4, LT);
        ColumnFirstBorder(RingC4, LT, height = 14.25);
        ColumnFirstBorder(MiddleC4, LT, height = 12.9);
        ColumnFirstPillars(RingC4, LT, [0, 0, 5, 0], .1);
        ColumnFirstPillars(MiddleC4, RT, [0, -15, 10, 0], .1);
    }

    ConvexHull() {
        ColumnFirstPillars(MiddleC4, LT, thickness = 1);
        ColumnFirstPillars(MiddleC4, LT, [1, 0, 2, 0], thickness = 1);
        ColumnFirstPillars(RingC4, RT, thickness = 1);
        ColumnFirstPillars(RingC4, RT, [0, 0, 2, 0], thickness = 1);
    }

    ConvexHull() {
        ColumnFirstPillars(RingC4, [LT, RT], thickness = 1);
        ColumnFirstPillars(RingC4, [LT, RT], [0, 0, 2, 0], thickness = 1);
    }



    ConvexHull() {
        ColumnFirstBorder(MiddleC4, RT, [0, -15, 0, 0]);
        ColumnFirstBorder(MiddleC4, LT, height = 12.9);
        ColumnFirstPillars(MiddleC4, RT, [0, -15, 10, 0], .1);
    }

    ConvexHull() {
        ColumnFirstBorder(MiddleC4, LT, [-15, 0, 0, 0]);
        ColumnFirstBorder(MiddleC4, RT, [0, -15, 0, 0]);
        ColumnFirstPillars(MiddleC4, LT, [-15, 0, 10, 0], .1);
        ColumnFirstPillars(MiddleC4, RT, [0, -15, 10, 0], .1);
    }

    ConvexHull() {
        ColumnFirstBorder(MiddleC4, LT, [-15, 0, 0, 0]);
        ColumnFirstBorder(MiddleC4, RT, height = 12.9);
        ColumnFirstPillars(MiddleC4, LT, [-15, 0, 10, 0], .1);
    }

    ConvexHull() {
        ColumnFirstPillars(MiddleC4, [LT, RT], thickness = 1);
        ColumnFirstPillars(MiddleC4, [LT, RT], [0, 0, 2, 0], thickness = 1);
    }



    ConvexHull() {
        ColumnFirstBorderIntersection(MiddleC4, [RT, RB], IndexC4, [LT, RT], 20);
        ColumnFirstBorder(MiddleC4, RT, height = 12.9);
        ColumnFirstBorder(IndexC4, RT, height = 10.67);
    }

    ConvexHull() {
        ColumnFirstBorder(MiddleC4, RT, height = 12.9);
        ColumnFirstBorder(IndexC4, RT, height = 10.67);
        ColumnFirstPillars(IndexC4, RT, [0, 0, 5, 0], .1);
        ColumnFirstPillars(MiddleC4, LT, [-15, 0, 10, 0], .1);
    }

    ConvexHull() {
        ColumnFirstPillars(MiddleC4, RT, thickness = 1);
        ColumnFirstPillars(MiddleC4, RT, [0, 1, 2, 0], thickness = 1);
        ColumnFirstPillars(IndexC4, LT, thickness = 1);
        ColumnFirstPillars(IndexC4, LT, [0, 0, 2, 0], thickness = 1);
    }

    ConvexHull() {
        ColumnFirstPillars(IndexC4, [LT, RT], thickness = 1);
        ColumnFirstPillars(IndexC4, [LT, RT], [0, 0, 2, 0], thickness = 1);
    }



    ConvexHull() {
        ColumnFirstBorder(IndexC3, RT);
        ColumnFirstBorder(IndexC4, RT, height = 10.67);
        ColumnFirstPillars(IndexC4, RT, [0, 0, 5, 0], .1);
        ColumnFirstPillars(IndexC3, RT, [0, 0, 5, 0], .1);
    }

    ConvexHull() {
        ColumnFirstBorderIntersection(IndexC4, [RT, RB], IndexC3, [LT, RT], 20);
        ColumnFirstBorder(IndexC3, RT);
        ColumnFirstBorder(IndexC4, RT, height = 10.67);
    }

    ConvexHull() {
        ColumnFirstBorder(IndexC3, RT);
        ColumnFirstPillars(IndexC3, RT, [0, 0, 5, 0], .1);
        ColumnFirstPillars(IndexC3, RT, [0, 7, 2, 0], 1);
    }

    ConvexHull() {
        ColumnFirstPillars(IndexC4, RT, thickness = 1);
        ColumnFirstPillars(IndexC4, RT, [0, 1, 2, 0], thickness = 1);
        ColumnFirstPillars(IndexC3, LT, thickness = 1);
        ColumnFirstPillars(IndexC3, LT, [0, 0, 2, 0], thickness = 1);
    }

    ConvexHull() {
        ColumnFirstPillars(IndexC3, [LT, RT], [0, 3, 0, 0], thickness = 1);
        ColumnFirstPillars(IndexC3, [LT, RT], [0, 3, 2, 0], thickness = 1);
    }
}

module LittleC2Border() {
    LittleC2BorderLS();
    LittleC2BorderTS();
    LittleC2BorderBS();
}

module LittleC2BorderLS() {
    ConvexHull() {
        ColumnFirstBorder(LittleC2, [LT, LB], [0, 0, 0, -2]);
        hull() {
            ColumnLastBorder(LittleC2, LT, [0, 0, -2, 0]);
            ColumnFirstBorder(LittleC2, LB, [0, 0, 0, -2]);
        }

        ColumnFirstPillars(LittleC2, LT, [5, 0, -3, 0]);
        hull() {
            ColumnFirstPillars(LittleC2, LB, [1, 0, 0, 0], .1);
            ColumnLastPillars(LittleC2, LT, [1, 0, 0, 0], .1);
            ColumnFirstPillars(LittleC2, LB, [5, 0, 0, 0], .1);
            ColumnLastPillars(LittleC2, LT, [5, 0, 0, 0], .1);
        }
    }

    ConvexHull() {
        ColumnLastBorder(LittleC2, [LT, LB], [0, 0, -2, 0]);
        hull() {
            ColumnLastBorder(LittleC2, LT, [0, 0, -2, 0]);
            ColumnFirstBorder(LittleC2, LB, [0, 0, 0, -2]);
        }

        ColumnLastPillars(LittleC2, LB, [5, 0, 0, -3]);
        hull() {
            ColumnFirstPillars(LittleC2, LB, [1, 0, 0, 0], .1);
            ColumnLastPillars(LittleC2, LT, [1, 0, 0, 0], .1);
            ColumnFirstPillars(LittleC2, LB, [5, 0, 0, 0], .1);
            ColumnLastPillars(LittleC2, LT, [5, 0, 0, 0], .1);
        }
    }

    ConvexHull() {
        ColumnOffset(LittleC2)
        ColumnPart(LittleC2[startIndex], LBS, LittleC2);

        hull() {
            ColumnFirstPillars(LittleC2, LB, [5, 0, 0, 0], .1);
            ColumnLastPillars(LittleC2, LT, [5, 0, 0, 0], .1);
        }
    }

    ConvexHull() {
        ColumnOffset(LittleC2)
        ColumnPart(LittleC2[startIndex], LS, LittleC2);
        ColumnFirstPillars(LittleC2, [LT, LB], [5, 0, -3, 0], 1);
    }

    ConvexHull() {
        ColumnOffset(LittleC2)
        ColumnPart(lastIndexOf(LittleC2), LS, LittleC2);
        ColumnLastPillars(LittleC2, [LT, LB], [5, 0, 0, -3], 1);
    }
}

module LittleC2BorderTS() {
    ConvexHull() {
        ColumnFirstBorderIntersection(LittleC2, [LT, RT], LittleC3, [LT, LB], 10);
        ColumnFirstBorder(LittleC3, LT);
        ColumnFirstPillars(LittleC2, LT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(LittleC3, LT, [7, 0, 2, 0], 1);
    }

    ConvexHull() {
        ColumnFirstBorderIntersection(LittleC2, [LT, RT], LittleC3, [LT, LB], 10);
        ColumnFirstBorder(LittleC2, LT);
        ColumnFirstPillars(LittleC2, LT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(LittleC3, LT, [7, 0, 0, 0], 1, 1);
    }

    ConvexHull() {
        ColumnFirstBorder(LittleC2, LT);
        ColumnFirstPillars(LittleC2, LT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(LittleC2, LT, [5, 0, -3, 0], 1);
    }

    ConvexHull() {
        ColumnFirstPillars(LittleC2, LT, [0, 0, 0, 0], 1);
        ColumnFirstPillars(LittleC2, LT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(LittleC2, LT, [5, 0, -3, 0], 1);
    }

    ConvexHull() {
        ColumnOffset(LittleC2)
        ColumnPart(LittleC2[startIndex], TS, LittleC2);
        ColumnFirstPillars(LittleC2, LT, [0, 0, 7, 0], 1);
    }

    ConvexHull() {
        ColumnFirstPillars(LittleC2, RT, [0, 0, 0, 0], 1);
        ColumnFirstPillars(LittleC2, LT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(LittleC3, LT, [7, 0, 2, 0], 1);
    }

    ConvexHull() {
        ColumnFirstPillars(LittleC2, RT, [0, 0, 0, 0], 1);

        ColumnOffset(LittleC3)
        ColumnPart(LittleC3[startIndex], LS, LittleC3);
        ColumnFirstPillars(LittleC3, LT, [7, 0, 2, 0], 1);
    }
}

module LittleC2BorderBS() {
    ConvexHull() {
        ColumnLastBorderIntersection(LittleC2, [LB, RB], LittleC3, [LT, LB], 10);
        ColumnLastBorder(LittleC3, LB);
        ColumnLastPillars(LittleC2, LB, [0, 0, 0, 7], 1);
        ColumnLastPillars(LittleC3, LB, [7, 0, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastBorderIntersection(LittleC2, [LB, RB], LittleC3, [LT, LB], 10);
        ColumnLastBorder(LittleC2, LB);
        ColumnLastPillars(LittleC2, LB, [0, 0, 0, 7], 1);
        ColumnLastPillars(LittleC3, LB, [7, 0, 0, 0], 1, 1);
    }

    ConvexHull() {
        ColumnLastBorder(LittleC2, LB);
        ColumnLastPillars(LittleC2, LB, [0, 0, 0, 7], 1);
        ColumnLastPillars(LittleC2, LB, [5, 0, 0, -3], 1);
    }

    ConvexHull() {
        ColumnLastPillars(LittleC2, LB, [0, 0, 0, 0], 1);
        ColumnLastPillars(LittleC2, LB, [0, 0, 0, 7], 1);
        ColumnLastPillars(LittleC2, LB, [5, 0, 0, -3], 1);
    }

    ConvexHull() {
        ColumnOffset(LittleC2)
        ColumnPart(lastIndexOf(LittleC2), BS, LittleC2);
        ColumnLastPillars(LittleC2, LB, [0, 0, 0, 7], 1);
    }

    ConvexHull() {
        ColumnLastPillars(LittleC2, RB, [0, 0, 0, 0], 1);
        ColumnLastPillars(LittleC2, LB, [0, 0, 0, 7], 1);
        ColumnLastPillars(LittleC3, LB, [7, 0, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastPillars(LittleC2, RB, [0, 0, 0, 0], 1);

        ColumnOffset(LittleC3)
        ColumnPart(lastIndexOf(LittleC3), LS, LittleC3);
        ColumnLastPillars(LittleC3, LB, [7, 0, 0, 2], 1);
    }
}

module IndexC2Border() {
    IndexC2BorderRS();
    IndexC2BorderTS();
    IndexC2BorderBS();
}

module IndexC2BorderRS() {
    ConvexHull() {
        ColumnFirstBorder(IndexC2, [RT, RB], [0, 0, 0, -2]);
        hull() {
            ColumnLastBorder(IndexC2, RT, [0, 0, -2, 0]);
            ColumnFirstBorder(IndexC2, RB, [0, 0, 0, -2]);
        }

        ColumnFirstPillars(IndexC2, RT, [0, 5, -3, 0]);
        hull() {
            ColumnFirstPillars(IndexC2, RB, [0, 1, 0, 0], .1);
            ColumnLastPillars(IndexC2, RT, [0, 1, 0, 0], .1);
            ColumnFirstPillars(IndexC2, RB, [0, 5, 0, 0], .1);
            ColumnLastPillars(IndexC2, RT, [0, 5, 0, 0], .1);
        }
    }

    ConvexHull() {
        ColumnLastBorder(IndexC2, [RT, RB], [0, 0, -2, 0]);
        hull() {
            ColumnLastBorder(IndexC2, RT, [0, 0, -2, 0]);
            ColumnFirstBorder(IndexC2, RB, [0, 0, 0, -2]);
        }

        ColumnLastPillars(IndexC2, RB, [0, 5, 0, -3]);
        hull() {
            ColumnFirstPillars(IndexC2, RB, [0, 1, 0, 0], .1);
            ColumnLastPillars(IndexC2, RT, [0, 1, 0, 0], .1);
            ColumnFirstPillars(IndexC2, RB, [0, 5, 0, 0], .1);
            ColumnLastPillars(IndexC2, RT, [0, 5, 0, 0], .1);
        }
    }

    ConvexHull() {
        ColumnOffset(IndexC2)
        ColumnPart(IndexC2[startIndex], RBS, IndexC2);

        hull() {
            ColumnFirstPillars(IndexC2, RB, [0, 5, 0, 0], .1);
            ColumnLastPillars(IndexC2, RT, [0, 5, 0, 0], .1);
        }
    }

    ConvexHull() {
        ColumnOffset(IndexC2)
        ColumnPart(IndexC2[startIndex], RS, IndexC2);
        ColumnFirstPillars(IndexC2, [RT, RB], [0, 5, -3, 0], 1);
    }

    ConvexHull() {
        ColumnOffset(IndexC2)
        ColumnPart(lastIndexOf(IndexC2), RS, IndexC2);
        ColumnLastPillars(IndexC2, [RT, RB], [0, 5, 0, -3], 1);
    }
}

module IndexC2BorderTS() {
    ConvexHull() {
        ColumnFirstBorderIntersection(IndexC2, [LT, RT], IndexC3, [RT, RB], 10);
        ColumnFirstBorder(IndexC3, RT);
        ColumnFirstPillars(IndexC2, RT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(IndexC3, RT, [0, 7, 2, 0], 1);
    }

    ConvexHull() {
        ColumnFirstBorderIntersection(IndexC2, [LT, RT], IndexC3, [RT, RB], 10);
        ColumnFirstBorder(IndexC2, RT);
        ColumnFirstPillars(IndexC2, RT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(IndexC3, RT, [0, 7, 0, 0], 1, 1);
    }

    ConvexHull() {
        ColumnFirstBorder(IndexC2, RT);
        ColumnFirstPillars(IndexC2, RT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(IndexC2, RT, [0, 5, -3, 0], 1);
    }

    ConvexHull() {
        ColumnFirstPillars(IndexC2, RT, [0, 0, 0, 0], 1);
        ColumnFirstPillars(IndexC2, RT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(IndexC2, RT, [0, 5, -3, 0], 1);
    }

    ConvexHull() {
        ColumnOffset(IndexC2)
        ColumnPart(IndexC2[startIndex], TS, IndexC2);
        ColumnFirstPillars(IndexC2, RT, [0, 0, 7, 0], 1);
    }

    ConvexHull() {
        ColumnFirstPillars(IndexC2, LT, [0, 0, 0, 0], 1);
        ColumnFirstPillars(IndexC2, RT, [0, 0, 7, 0], 1);
        ColumnFirstPillars(IndexC3, RT, [0, 7, 2, 0], 1);
    }

    ConvexHull() {
        ColumnFirstPillars(IndexC2, LT, [0, 0, 0, 0], 1);

        ColumnOffset(IndexC3)
        ColumnPart(IndexC3[startIndex], RS, IndexC3);
        ColumnFirstPillars(IndexC3, RT, [0, 7, 2, 0], 1);
    }
}

module IndexC2BorderBS() {
    ConvexHull() {
        ColumnLastBorderIntersection(IndexC2, [LB, RB], IndexC3, [RT, RB], 10);
        ColumnLastBorder(IndexC3, RB);
        ColumnLastPillars(IndexC2, RB, [0, 0, 0, 7], 1);
        ColumnLastPillars(IndexC3, RB, [0, 7, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastBorderIntersection(IndexC2, [LB, RB], IndexC3, [RT, RB], 10);
        ColumnLastBorder(IndexC2, RB);
        ColumnLastPillars(IndexC2, RB, [0, 0, 0, 7], 1);
        ColumnLastPillars(IndexC3, RB, [0, 7, 0, 0], 1, 1);
    }

    ConvexHull() {
        ColumnLastBorder(IndexC2, RB);
        ColumnLastPillars(IndexC2, RB, [0, 0, 0, 7], 1);
        ColumnLastPillars(IndexC2, RB, [0, 5, 0, -3], 1);
    }

    ConvexHull() {
        ColumnLastPillars(IndexC2, RB, [0, 0, 0, 0], 1);
        ColumnLastPillars(IndexC2, RB, [0, 0, 0, 7], 1);
        ColumnLastPillars(IndexC2, RB, [0, 5, 0, -3], 1);
    }

    ConvexHull() {
        ColumnOffset(IndexC2)
        ColumnPart(lastIndexOf(IndexC2), BS, IndexC2);
        ColumnLastPillars(IndexC2, RB, [0, 0, 0, 7], 1);
    }

    ConvexHull() {
        ColumnLastPillars(IndexC2, LB, [0, 0, 0, 0], 1);
        ColumnLastPillars(IndexC2, RB, [0, 0, 0, 7], 1);
        ColumnLastPillars(IndexC3, RB, [0, 7, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastPillars(IndexC2, LB, [0, 0, 0, 0], 1);

        ColumnOffset(IndexC3)
        ColumnPart(lastIndexOf(IndexC3), RS, IndexC3);
        ColumnLastPillars(IndexC3, RB, [0, 7, 0, 2], 1);
    }
}

module MainClusterBS() {
    ConvexHull() {
        ColumnLastBorder(LittleC3, LB);
        ColumnLastBorderIntersection(LittleC3, [LB, RB], RingC4, [LT, LB], 10);
        ColumnLastPillars(LittleC3, LB, [0, 0, 0, 7], 1);
        ColumnLastPillars(MiddleC4, LB, [20, 0, 0, 12], .1);
    }

    ConvexHull() {
        ColumnLastBorderIntersection(LittleC3, [LB, RB], RingC4, [LT, LB], 10);
        ColumnLastBorder(MiddleC4, LB, [19, -19, 0, 4.22]);
        ColumnLastBorder(MiddleC4, LB, [19, -19, 0, 5]);
        ColumnLastPillars(MiddleC4, LB, [20, 0, 0, 12], .1);
        ColumnLastPillars(LittleC3, LB, [0, 0, 0, 7], 1);
    }

    ConvexHull() {
        ColumnLastBorder(LittleC3, LB);
        ColumnLastPillars(LittleC3, LB, [0, 0, 0, 7], 1);
        ColumnLastPillars(LittleC3, LB, [7, 0, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastPillars(LittleC3, [LB, RB], [3, 0, 0, 0], 1);
        ColumnLastPillars(LittleC3, LB, [0, 0, 0, 7], 1);
        ColumnLastPillars(LittleC3, RB, [0, 0, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastPillars(RingC4, [LT, LB], [0, 0, 0, 0], 1);
        ColumnLastPillars(MiddleC4, LB, [20, 0, 0, 12], .1);
        ColumnLastPillars(LittleC3, RB, [0, 0, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastPillars(LittleC3, RB, [0, 0, 0, 2], 1);
        ColumnLastPillars(LittleC3, RB, [0, 0, 0, 0], 1);
        ColumnOffset(RingC4)
            ColumnPart(lastIndexOf(RingC4) - 1, LBS, RingC4);
    }



    ConvexHull() {
        ColumnLastBorder(MiddleC4, [LB, RB], [19, -19, 0, 4.22]);
        ColumnLastBorder(MiddleC4, [LB, RB], [19, -19, 0, 5]);
        ColumnLastPillars(MiddleC4, [LB, RB], [20, 0, 0, 12], 1);
    }

    ConvexHull() {
        ColumnLastPillars(MiddleC4, LB, [0, 0, 0, 12], 1);
        ColumnLastPillars(MiddleC4, LB, [20, 0, 0, 12], 1);
        ColumnLastPillars(RingC4, [LB, RB], [0, 0, 0, 0], 1);
    }



    ConvexHull() {
        ColumnLastBorder(MiddleC4, [LB, RB], [-2, -2, 0, 0]);
        ColumnLastBorder(MiddleC4, [LB, RB], [-2, -2, 0, 5]);
        ColumnLastPillars(MiddleC4, [LB, RB], [0, 0, 0, 12], 1);
    }

    ConvexHull() {
        ColumnLastPillars(MiddleC4, [LB, RB], [0, 0, 0, 0], 1);
        ColumnLastPillars(MiddleC4, [LB, RB], [0, 0, 0, 12], 1);
        ColumnLastPillars(IndexC4, LB, [0, 0, 0, 0], 1);
        ColumnLastPillars(RingC4, RB, [0, 0, 0, 0], 1);
    }



    ConvexHull() {
        ColumnLastBorder(MiddleC4, [LB, RB], [-19, 19, 0, 5]);
        ColumnLastPillars(MiddleC4, [LB, RB], [0, 20, 0, 12], 1);
    }

    ConvexHull() {
        ColumnLastBorder(MiddleC4, [LB, RB], [-19, 19, 0, 5], 0);
        ColumnLastPillars(MiddleC4, RB, [0, 0, 0, 12], 1);
        ColumnLastPillars(IndexC4, [LB, RB], [0, 0, 0, 0], 1);
        ColumnLastPillars(IndexC4, RB, [0, 0, 0, 5], 1);
    }



    ConvexHull() {
        ColumnLastBorder(IndexC3, RB);
        ColumnLastBorderIntersection(IndexC3, [LB, RB], IndexC4, [RT, RB], 10);
        ColumnLastPillars(IndexC3, RB, [0, 0, 0, 7], 1);
        ColumnLastPillars(MiddleC4, RB, [0, 20, 0, 12], .1);
    }

    ConvexHull() {
        ColumnLastBorderIntersection(IndexC3, [LB, RB], IndexC4, [RT, RB], 10);
        ColumnLastBorder(MiddleC4, RB, [-19, 19, 0, 4.22]);
        ColumnLastBorder(MiddleC4, RB, [-19, 19, 0, 5]);
        ColumnLastPillars(MiddleC4, RB, [0, 20, 0, 12], .1);
        ColumnLastPillars(IndexC3, RB, [0, 0, 0, 7], 1);
    }

    ConvexHull() {
        ColumnLastBorder(IndexC3, RB);
        ColumnLastPillars(IndexC3, RB, [0, 0, 0, 7], 1);
        ColumnLastPillars(IndexC3, RB, [0, 7, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastPillars(IndexC3, [LB, RB], [0, 2, 0, 0], 1);
        ColumnLastPillars(IndexC3, RB, [0, 0, 0, 7], 1);
        ColumnLastPillars(IndexC3, LB, [0, 0, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastPillars(IndexC4, [RT, RB], [0, 0, 0, 0], 1);
        ColumnLastPillars(MiddleC4, RB, [0, 20, 0, 12], .1);
        ColumnLastPillars(IndexC3, LB, [0, 0, 0, 2], 1);
    }

    ConvexHull() {
        ColumnLastPillars(IndexC3, LB, [1, 0, 0, 2], 1);
        ColumnLastPillars(IndexC3, LB, [0, 0, 0, 0], 1);
        ColumnOffset(IndexC4)
            ColumnPart(lastIndexOf(IndexC4) - 1, RBS, IndexC4);
    }
}