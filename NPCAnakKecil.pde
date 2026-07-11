class NPCAnakKecil {
  float x, y;
  float vx = 0;
  float walkPhase = 0;
  boolean facingRight = true;
  boolean isMoving = true;
  int variation = 0;
  
  color cSkin = color(255, 220, 185);
  color cBaju = color(220, 120, 60); // Baju jingga cerah anak-anak
  color cCelana = color(60, 80, 120);
  color cRambut = color(40, 30, 20);

  NPCAnakKecil(float x, float y) {
    this.x = x;
    this.y = y;
    this.vx = random(1.5, 2.5) * (random(1) > 0.5 ? 1 : -1);
    this.facingRight = this.vx > 0;
    this.variation = int(random(3));
    
    if (variation == 1) {
      cBaju = color(95, 175, 95); // Hijau cerah
      cCelana = color(160, 60, 60); // Celana merah maroon
      cRambut = color(20, 15, 15);
    } else if (variation == 2) {
      cBaju = color(230, 195, 75); // Kuning cerah
      cCelana = color(110, 65, 150); // Celana ungu
      cRambut = color(80, 50, 35);
    }
  }

  void update() {
    if (isMoving) {
      x += vx;
      walkPhase += abs(vx) * 0.12;
      
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
    translate(x, y + 25); // Diturunkan 25px secara global agar posturnya pendek namun menapak tanah rata
    
    if (!facingRight) {
      scale(-1, 1);
    }
    
    float swing = isMoving ? sin(walkPhase) : 0;

    // 1. TANGAN KIRI (Diarahkan ke bawah, bukan T-pose)
    pushMatrix();
    translate(-12, -60); 
    rotate(radians(15) + swing * 0.35); 
    fill(cBaju); rectMode(CORNER);
    rect(-5, 0, 10, 28, 4); 
    fill(cSkin); rect(-4, 28, 8, 8, 2);
    popMatrix();

    // 2. KAKI KIRI
    pushMatrix();
    translate(-5, -30); 
    rotate(swing * 0.4);
    fill(cCelana); rectMode(CORNER);
    rect(-5, 0, 10, 25, 2);
    fill(cSkin); rect(-4, 25, 8, 12, 1);
    fill(cSkin); rect(-5, 33, 10, 4, 2); 
    popMatrix();

    // 3. BADAN MAIN (Lebih kecil)
    fill(cBaju); rectMode(CENTER);
    rect(0, -46, 26, 34, 8);

    // 4. CELANA PENDEK
    fill(cCelana);
    rect(0, -26, 26, 10);

    // 5. KAKI KANAN
    pushMatrix();
    translate(5, -30); 
    rotate(-swing * 0.4);
    fill(cCelana); rectMode(CORNER);
    rect(-5, 0, 10, 25, 2);
    fill(cSkin); rect(-4, 25, 8, 12, 1);
    fill(cSkin); rect(-5, 33, 10, 4, 2);
    popMatrix();

    // 6. TANGAN KANAN (Diarahkan ke bawah, bukan T-pose)
    pushMatrix();
    translate(12, -60); 
    rotate(radians(-15) - swing * 0.35); 
    fill(cBaju); rectMode(CORNER);
    rect(-5, 0, 10, 28, 4); 
    fill(cSkin); rect(-4, 28, 8, 8, 2);
    popMatrix();

    // 7. KEPALA BULAT
    pushMatrix();
    translate(0, -72); 
    fill(cSkin); noStroke();
    ellipse(0, 0, 34, 34); 

    // Rambut poni mangkok bocah desa
    fill(cRambut);
    arc(0, -4, 36, 28, PI, TWO_PI);
    ellipse(-15, 0, 6, 12); ellipse(15, 0, 6, 12);

    // Mata bulat besar/polos penasaran
    fill(30);
    ellipse(-6, 0, 5, 5); ellipse(6, 0, 5, 5);
    // Mulut ternganga kecil (O) melihat cermin berkilau
    fill(100, 30, 30);
    ellipse(0, 8, 4, 4);

    popMatrix();
    popMatrix();
  }
}
