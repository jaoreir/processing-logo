void onKeyPressed() {
    if (key == ESC) {
        exit();
    }
}

enum BlobType{
    Rings,
    Ellipse,
    Rect,
    Spikes,
}

float rad2Deg = 2 * PI / 360.0f;

class Blob {
    public BlobType type = BlobType.Rings;
    public float x, y;
    public float w;
    public float h;
    public float phase;
    public float rotation = 0;
    public float sizeMod = 100;
    public float freq = 2;
    public color fillColor = color(0,0,0);
    public float fillAlpha = 0;
    public float transMod = 12;
    public float angleVelo = 0;
    
    public Blob(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        phase = random(0, 2 * PI);
        angleVelo = random(5,10);
    }
    
    float BR(float amp) {
        return random( -amp, amp);
    }
    float R(float amp) {
        return random(0.0f, amp);
    }
    
    public void Draw() {
        pushMatrix();
        translate(x, y);
        rotate(rotation + millis() * 0.001 * angleVelo);
        
        int repeatCount = 1 + floor(mouseY / 1024.0f * 7);
        for (int i = 0; i < repeatCount; ++i) {
            translate(BR(transMod), BR(transMod));
            strokeWeight(1 + R(4));
            stroke(0);
            fill(fillColor, fillAlpha);
            float ww = w + sizeMod * cos(millis() * 0.001 * freq + phase) + BR(sizeMod * 0.1);
            float hh = h + sizeMod * sin(millis() * 0.001 * freq + phase) + BR(sizeMod * 0.1);
            
            switch(type)
            {
                case Rings:
                    float m = 0.5f + mouseY / 1024.0f * 0.5f;
                    for (int j = 0; j < 6; ++j) {
                        ellipse(0,0,ww,hh);
                        float mm = m + BR(0.03f);
                        ww *= mm;
                        hh *= mm;
                    }
                    break;
                case Ellipse:
                    ellipse(0,0,ww,hh);
                    break;
                case Rect:
                    rectMode(CENTER);
                    rect(0,0,ww,hh);
                    break;
                case Spikes:
                    ww /=  2;
                    hh /=  2;
                    int steps = floor(12 + mouseY / 1024.0f * 8);
                    for (int k = 0; k < steps; ++k)
                    {
                        pushMatrix();
                        rotate(2 * PI * k / (float)steps);
                        translate(hh, 0);
                        rectMode(CENTER);
                        rect(0,0, ww * mouseY / 1024.0f, 1 * (5 + hh * (1 - mouseY / 1024.0f)));
                        popMatrix();
                    }
            }
        }
        popMatrix();
    }
}


Blob[] blobs = new Blob[6];
Blob cursor = new Blob(0,0, 16,16);
float eye_x=400;
float eye_y=500;

void setup() {
    size(1024,1024);
    frameRate(24);
    
    cursor.transMod = 1;
    cursor.sizeMod = 1;
    
    
    blobs[0] = new Blob(300, 300, 360, 256);
    blobs[1] = new Blob(700, 400, 360, 256);
    blobs[2] = new Blob(600, 700, 360, 256);
    
    
    Blob eye1 = new Blob(eye_x, eye_y, 150, 150);
    eye1.type = BlobType.Ellipse;
    eye1.sizeMod = 0;
    eye1.transMod = 4;
    eye1.fillColor = color(255);
    eye1.fillAlpha = 255;
    blobs[3] = eye1;
    
    Blob eye2 = new Blob(eye_x, eye_y, 72, 72);
    eye2.type = BlobType.Ellipse;
    eye2.sizeMod = 0;
    eye2.transMod = 3;
    eye2.fillAlpha = 255;
    blobs[4] = eye2;
    
    
    Blob line = new Blob(550, 512, 64, 800);
    line.type = BlobType.Rect;
    line.sizeMod = 6;
    line.fillColor = color(255);
    line.fillAlpha = 255;
    line.angleVelo = 0;
    line.rotation = 8 * rad2Deg;
    blobs[5] = line;
}


void draw() {
    background(255);
    
    BlobType t;
    
    if (mouseX > 512) {
        t = BlobType.Spikes;
    }
    else {
        t = BlobType.Rings;
    }
    for (int i = 0; i < 3; ++i) {
        blobs[i].type = t;
    }
    cursor.type = t;

    float dir_x = mouseX - eye_x;
    float dir_y = mouseY - eye_y;
    float lookAmp = 20;
    float no = lookAmp/ sqrt(dir_x * dir_x + dir_y * dir_y);
    dir_x *= no;
    dir_y *= no;
    blobs[4].x = eye_x + dir_x;
    blobs[4].y = eye_y + dir_y;

    
    for (int i = 0; i < blobs.length; ++i) {
        blobs[i].Draw();
    }
    
    cursor.x = mouseX;
    cursor.y = mouseY;
    cursor.Draw();
}