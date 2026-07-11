class NPCWarga {
  float x, y;
  float vx = 0;
  float walkPhase = 0;
  boolean facingRight = true;
  boolean isMoving = true;
  boolean isSpeaking = false;
  int variation = 0;
  
  color cSkin = color(245, 205, 170);
  color cBaju = color(70, 130, 120); // Hijau toska sederhana
  color cKain = color(100, 70, 60);
  color cHijab = color(210, 190, 180); // Kerudung kain lilit desa

  NPCWarga(float x, float y) {
    this.x = x;
    this.y = y;
    this.vx = random(1.2, 2.0) * (random(1) > 0.5 ? 1 : -1);
    this.facingRight = this.vx > 0;
    this.variation = int(random(3));
    
    if (variation == 1) {
      cBaju = color(165, 55, 75); // Kebaya merah marun
      cHijab = color(230, 195, 80); // Hijab kuning kunyit
      cKain = color(60, 45, 40);
    } else if (variation == 2) {
      cBaju = color(55, 85, 140); // Kebaya biru tua
      cHijab = color(225, 170, 185); // Hijab dusty pink
      cKain = color(80, 60, 50);
    }
  }

  void update() {
    if (isMoving) {
      x += vx;
      walkPhase += abs(vx) * 0.1;
      
      // Batasan layar pasar
      if (x < 60) {
        x = 60;
        vx = -vx;
        facingRight = vx > 0;
      } else if (x > width - 60) {
        x = width - 60;
        vx = -vx;
        facingRight = vx > 0;
      }
      
      // Balik arah acak
      if (random(1) < 0.005) {
        vx = -vx;
        facingRight = vx > 0;
      }
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);

    if (!facingRight) {
      scale(-1, 1);
    }

    float swing = isMoving ? sin(walkPhase) : 0;

    // 1. TANGAN KIRI (Diarahkan ke bawah, bukan T-pose)
    pushMatrix();
    translate(-16, -85); 
    rotate(radians(15) + swing * 0.3); 
    fill(cBaju); rectMode(CORNER);
    rect(-7, 0, 14, 40, 5); 
    fill(cSkin); rect(-5, 40, 10, 10, 2);
    popMatrix();

    // 2. KAKI KIRI
    pushMatrix();
    translate(-8, -45); 
    rotate(swing * 0.35);
    fill(cKain); rectMode(CORNER);
    rect(-7, 0, 14, 38, 3);
    fill(cSkin); rect(-5, 38, 10, 22, 2);
    fill(cSkin); rect(-7, 56, 14, 6, 3);
    popMatrix();

    // 3. BADAN MAIN
    fill(cBaju); rectMode(CENTER);
    rect(0, -68, 36, 46, 10);

    // 4. ROK KAIN
    fill(cKain);
    beginShape();
    vertex(-18, -46); vertex(18, -46);
    vertex(22, -10); vertex(-22, -10);
    endShape(CLOSE);

    // 5. KAKI KANAN
    pushMatrix();
    translate(8, -45); 
    rotate(-swing * 0.35);
    fill(cKain); rectMode(CORNER);
    rect(-7, 0, 14, 38, 3);
    fill(cSkin); rect(-5, 38, 10, 22, 2);
    fill(cSkin); rect(-7, 56, 14, 6, 3);
    popMatrix();

    // 6. TANGAN KANAN (Diarahkan ke bawah, bukan T-pose)
    pushMatrix();
    translate(16, -85); 
    rotate(radians(-15) - swing * 0.3); 
    fill(cBaju); rectMode(CORNER);
    rect(-7, 0, 14, 40, 5); 
    fill(cSkin); rect(-5, 40, 10, 10, 2);
    popMatrix();

    // 7. KEPALA DENGAN KERUDUNG DESA
    pushMatrix();
    translate(0, -102); 
    
    // Kain kerudung belakang
    fill(cHijab);
    ellipse(0, -2, 46, 48);

    fill(cSkin); noStroke();
    ellipse(0, 0, 38, 40); // Wajah dibikin agak kecil karena tertutup kain

    // Mata terpukau/melihat kecantikan
    fill(40);
    ellipse(-7, -2, 5, 5); ellipse(7, -2, 5, 5);
    
    // Mulut (Bisa berbicara jika isSpeaking aktif)
    if (isSpeaking) {
      float mouthOpen = abs(sin(frameCount * 0.35)) * 6.0 + 2.0;
      fill(80, 30, 30);
      ellipse(0, 8, 6, mouthOpen);
    } else {
      stroke(40); strokeWeight(1.5); noFill();
      arc(0, 8, 8, 4, 0, PI); // Mulut tersenyum kecil terpukau
      noStroke();
    }

    // Lilitan kerudung bagian depan atas dahi
    fill(cHijab);
    arc(0, -10, 42, 25, PI, TWO_PI);
    // Kain hijab menjuntai ke pundak kiri
    rectMode(CORNER);
    rect(-21, 0, 8, 30, 4);

    popMatrix();
    popMatrix();
  }
}
