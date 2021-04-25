ObjectA();
ObjectB();
FilletIntersection(0.6, 0.3, 0.06)
{
    ObjectA();
    ObjectB();
}


module FilletIntersection( scaleA, scaleB, step )
{
    for(i=[0:step:1])
    {
        ip = i;
        in = 1 - ip;
        
        // Linear
        //sa = 1 + (scaleA * ip);
        //sb = 1 + (scaleB * in);
        
        // Circular (puffed out)
        //sa = 1 + sin(ip*90)*scaleA;
        //sb = 1 + cos(ip*90)*scaleB;

        // Cupped (scooped out)
        sa = 1+((1 + sin(ip*90+180))*scaleA);
        sb = 1+((1 + cos(ip*90+180))*scaleB);
        
        intersection()
        {
            difference()
            {
                scale([sa,sa,sa])
                children(0);
                children(0);
            }
            difference()
            {
                scale([sb,sb,sb])
                children(1);
                children(1);
            }
        }
    }
}



module ObjectA()
{
    translate([0,0,1])
    hull()
    {
        cylinder(h=10, d=5, $fn=60);
        rotate([10,0,0])
        cylinder(h=10, d=5, $fn=60);

        rotate([0,-15,0])
        cylinder(h=10, d=3, $fn=60);

        rotate([0,15,0])
        cylinder(h=10, d=3, $fn=60);
    }
}

module ObjectB()
{
    union()
    {
        translate([-10,-10,0])
        cube([20,20,5]);

        rotate([0,-10,0])
        translate([-10,-10,0])
        cube([20,20,5]);

        rotate([0,+10,0])
        translate([-10,-10,0])
        cube([20,20,5]);
    }
}
