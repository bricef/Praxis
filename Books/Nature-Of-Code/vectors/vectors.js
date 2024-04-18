
var speed = 0.1;
var t = 0.0;

var boxsize = 50;

function Box(size){
    this.w = size/2;
}

Box.prototype.draw = function(p){
    var w = this.w;
    p.beginShape(p.LINES);
    
    p.vertex(-w,-w,-w);
    p.vertex(+w,-w,-w);

    p.vertex(-w,-w,-w);
    p.vertex(-w,+w,-w);

    p.vertex(-w,-w,-w);
    p.vertex(-w,-w,+w);

    p.vertex(+w,+w,+w);
    p.vertex(-w,+w,+w);

    p.vertex(+w,+w,+w);
    p.vertex(+w,-w,+w);

    p.vertex(+w,+w,+w);
    p.vertex(+w,+w,-w);

    p.vertex(-w,+w,-w);
    p.vertex(+w,+w,-w);

    p.vertex(+w,+w,-w);
    p.vertex(+w,-w,-w);

    p.vertex(+w,-w,-w);
    p.vertex(+w,-w,+w);

    p.vertex(-w,+w,-w);
    p.vertex(-w,+w,+w);

    p.vertex(-w,+w,+w);
    p.vertex(-w,-w,+w);

    p.vertex(-w,-w,+w);
    p.vertex(+w,-w,+w);


    p.endShape();
}


function BounceSketch(p){
    var width = 400;
    var height = 400;

    var boxwidth = 50;
    var ballradius = 3;

    var pos = new p.PVector(0, 0, 0);
    var vel = new p.PVector(10, 5, 2.5);

    var t = 0.0;

    // Attach functions to processing object
    p.setup = function () {
        p.size(width, height, p.OPENGL);
    };
    
    p.draw = function () {
        p.background(125,125,125);
        p.noFill();
        p.translate(width/2, width/2, 0); 
        p.rotateY(0.5*t);
        p.rotateX(0.5*t);
        pos.add(vel);
        if (pos.x > boxwidth){
            vel.x = vel.x * -1;
        }
        if(pos.x < -boxwidth){
            vel.x = vel.x * -1;
        }
        if(pos.y > boxwidth){
            vel.y = vel.y * -1;
        }
        if(pos.y < -boxwidth){
            vel.y = vel.y * -1;
        }
        if(pos.z > boxwidth){
            vel.z = vel.z * -1;
        }
        if(pos.z < -boxwidth){
            vel.z = vel.z * -1;
        }
        p.stroke(0,0,0);
        p.box(boxwidth*2);
        p.translate(pos.x, pos.y, pos.z);
        p.stroke(125,255,125);
        p.sphere(ballradius);
        
        t += 0.01;
    };
}


var canvas = document.getElementById("sketch");
var processingInstance = new Processing(canvas, BounceSketch);
