clipWidth = 18;     // thickness of the wooden panel the clip will be placed on
clipLength = 20;    // haw far along the panel the clip reaches
clipDepth = 30;     // how far down the panel the clip reaches
thickness = 4;      // thickness of the material of the clip
innerRadius = 2;    // inner radius to prevent stress cracking

wireDiam =  3.2;    // diameter of the pole or wire that will be inserted into the hole

xx = (clipWidth/2)-innerRadius;

difference()
{
    union()
    {
        // Clip Body
        ClipWithHole( xx, clipDepth, innerRadius + thickness );
        
        // Fillet
        FilletIntersection([0.1,0.1,0.01], [0.2,0.2,0.1], [0,clipLength/2,-clipDepth/2], 0.025)
        {
            Clip( xx, clipDepth, innerRadius + thickness );
            WireChunk();
        }
    }

    
    // Clip Subtraction
    scale([1,1.1,1])
    translate([0,-1,0])
    Clip( xx, clipDepth+100, innerRadius );

    // Hole for wire
    translate([clipWidth/2+thickness+wireDiam,clipLength/2,1])
    rotate([180,0,0])
    cylinder(h=clipDepth-innerRadius-5, d=wireDiam, $fn=180);

    // Drain Hole
    translate([clipWidth/2+thickness+wireDiam,clipLength/2,1])
    rotate([180,0,0])
    cylinder(h=100, d=wireDiam/2, $fn=180);
}

module ClipWithHole( xx, h, r )
{
    Clip( xx, h, r );
    WireChunk();
}

module WireChunk()
{
        translate([0,clipLength/2,0])
        rotate([180,0,0])
        hull()
        {
            cylinder(h=clipDepth, d=4*wireDiam, $fn=180);
            translate([clipWidth/2+thickness+wireDiam,0,0])
            cylinder(h=clipDepth, d=4*wireDiam, $fn=180);
        }
}

module Clip( xx, h, r )
{
    hull()
    {
        Cylinder( xx, 0, r);
        Cylinder(-xx, 0, r);
        Cylinder( xx, -h, r);
        Cylinder(-xx, -h, r);
    }
}

module Cylinder( x, y, rad )
{
    translate([x, 0, y])
    rotate([-90,0,0])
    cylinder(h=clipLength, r=rad, $fn=180);
}

module FilletIntersection( scaleA, scaleB, pivot, step )
{
    for(i=[0:step:1])
    {
        ip = i;
        in = 1 - ip;
        
        // Linear
        //sa = [  1 + (scaleA[0] * ip),
        //        1 + (scaleA[1] * ip),
        //        1 + (scaleA[2] * ip)   ];
        //sb = [  1 + (scaleB[0] * in),
        //        1 + (scaleB[1] * in),
        //        1 + (scaleB[2] * in)   ];
        
        // Circular (puffed out)
        //sa = [1 + sin(ip*90)*scaleA[0],
        //      1 + sin(ip*90)*scaleA[1],
        //      1 + sin(ip*90)*scaleA[2]];
        //sb = [1 + cos(ip*90)*scaleB[0],
        //      1 + cos(ip*90)*scaleB[1],
        //      1 + cos(ip*90)*scaleB[2]];

        // Cupped (scooped out)
        sa = [  1+((1 + sin(ip*90+180))*scaleA[0]),
                1+((1 + sin(ip*90+180))*scaleA[1]),
                1+((1 + sin(ip*90+180))*scaleA[2])  ];
        sb = [  1+((1 + cos(ip*90+180))*scaleB[0]),
                1+((1 + cos(ip*90+180))*scaleB[1]),
                1+((1 + cos(ip*90+180))*scaleB[2])  ];
        
        translate(pivot)
        intersection()
        {
            difference()
            {
                scale(sa)
                translate(-pivot)
                children(0);
                translate(-pivot)
                children(0);
            }
            difference()
            {
                scale(sb)
                translate(-pivot)
                children(1);
                translate(-pivot)
                children(1);
            }
        }
    }
}
