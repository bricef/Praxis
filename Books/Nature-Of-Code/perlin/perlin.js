
var defaults = {
        xoff: 0.05,
        yoff: 0.05,
        xvel: 0.0,
        yvel: 0.0,
        octaves: 4,
        falloff: 0.5,
        speed: 0.01,
        mag: 50
    };

var options = $.extend({}, defaults);

$("#xoff").val(options.xoff);
$("#yoff").val(options.yoff);
$("#xvel").val(options.xoff);
$("#yvel").val(options.yoff);
$("#octaves").val(options.octaves);
$("#falloff").val(options.falloff);
$("#speed").val(options.speed);
$("#mag").val(options.mag);

$("#noisecontrol input").change(function(){
    var xoff = parseFloat($("#xoff").val()),
        yoff = parseFloat($("#yoff").val()),
        xvel = parseFloat($("#xvel").val()),
        yvel = parseFloat($("#yvel").val()),
        octaves = parseFloat($("#octaves").val()),
        falloff = parseFloat($("#falloff").val()),
        speed = parseFloat($("#speed").val()),
        mag = parseFloat($("#mag").val());
    options.xoff = xoff?xoff:defaults.xoff;
    options.yoff = yoff?yoff:defaults.yoff;
    options.xvel = (xvel || (xvel == 0.0))?xvel:defaults.xvel;
    options.yvel = (yvel || (yvel == 0.0))?yvel:defaults.yvel;
    options.octaves = octaves?octaves:defaults.octaves;
    options.falloff = falloff?falloff:defaults.falloff;
    options.speed = (speed || (speed == 0.0))?speed:defaults.speed;
    options.mag = mag?mag:defaults.mag;
});

var t = 0.0;
var xpos = 0;
var ypos = 0;


function PerlinSketch(p){
    var width = 100;
    var height = 100;
    

    function perlin(p, t){
    p.loadPixels();
    for(var x = 0; x<width; x++){
        for(var y = 0; y<height; y++){
            var noise = p.noise(x*options.xoff+xpos,y*options.yoff+ypos, t);
            var g = p.map(noise, 0, 1, 0, 255);
            var color = p.color(g);
            p.set(x,y, color);
         }
     }
     p.updatePixels();
}

    // Attach functions to processing object
    p.setup = function () {
        p.size(width, height);
        p.noiseDetail(options.octaves, options.falloff);
        perlin(p, 0.0);   
    };
    
    p.draw = function () {
        p.noiseDetail(options.octaves, options.falloff);
        perlin(p, t);
        t+=options.speed;
        xpos += options.xvel;
        ypos += options.yvel;
    };
}

function LandscapeSketch(p){
    var width = 400;
    var height = 400;
    
    function perlinheight(x,y,t){
        var n = p.noise(x*options.xoff+xpos,y*options.yoff+ypos,t);
        var h = p.map(n, 0, 1, -options.mag, options.mag); 
        //console.log(x*options.xoff,y*options.yoff,t,n,h);
        return h;
    }

    function vertex(x,y,p,t){
        p.vertex(x,y,perlinheight(x,y,t));
    }

    function heightmap(p,t){
        var w = 5;
        //p.translate(width/2, 0.8*height, 50);
        p.translate(0,0.8*height,100);
        p.rotateX(p.radians(-145));
        p.stroke(0,125,0);
        p.beginShape(p.LINES);
        for(var x = 0; x<width; x+=w){
            for(var y = 0; y<height; y+=w){
                vertex(x, y, p, t);
                vertex(x+w, y, p, t);

                vertex(x, y, p, t);
                vertex(x, y+w, p, t);
            }
            vertex(x, y, p, t);
            vertex(x+w, y, p, t);
        }
        for(var y = 0; y<height; y+=w){
            vertex(x, y, p, t);
            vertex(x, y+w, p, t);
        }
        p.endShape(); 
    }

    // Attach functions to processing object
    p.setup = function () {
        p.size(width, height, p.OPENGL);
        p.noiseDetail(options.octaves, options.falloff);
        heightmap(p,t);
    };
    
    p.draw = function () {
        p.background(200);
        p.noiseDetail(options.octaves, options.falloff);
        heightmap(p,t);

    };
}

var canvas = document.getElementById("sketch");
var processingInstance = new Processing(canvas, PerlinSketch);


var landscape = document.getElementById("landscape");
var processingInstance = new Processing(landscape, LandscapeSketch);
