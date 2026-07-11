class NPCPedagang {
  float x, y;
  boolean isSpeaking = false;
  
  color cSkin = color(220, 175, 135);
  color cBaju = color(80, 90, 100); // Kain lurik kebiruan usang
  color cKain = color(70, 60, 55);
  color cCaping = color(210, 170, 110); // Warna anyaman bambu

  NPCPedagang(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {}

  void display() {
    pushMatrix();
    translate(x, y);

    // 1. TANGAN KIRI (Diarahkan ke bawah, bukan T-pose)
    pushMatrix();
    translate(-16, -85); 
    rotate(radians(15)); 
    fill(cBaju); rectMode(CORNER);
    rect(-7, 0, 14, 40, 5); 
    fill(cSkin); rect(-5, 40, 10, 10, 2);
    popMatrix();

    // 2. KAKI KIRI
    pushMatrix();
    translate(-7, -45); 
    fill(cKain); rectMode(CORNER);
    rect(-6, 0, 12, 38, 3);
    fill(cSkin); rect(-4, 38, 8, 22, 2); 
    fill(cSkin); rect(-6, 58, 12, 6, 2); 
    popMatrix();

    // 3. BADAN MAIN (Torso)
    fill(cBaju); rectMode(CENTER);
    rect(0, -68, 36, 46, 10);
    
    // Sabuk kain tradisional
    fill(40);
    rect(0, -48, 36, 6);

    // 4. CELANA/KAIN BAWAHAN
    fill(cKain);
    beginShape();
    vertex(-18, -46); vertex(18, -46);
    vertex(18, -10); vertex(-20, -10);
    endShape(CLOSE);

    // 5. KAKI KANAN
    pushMatrix();
    translate(7, -45); 
    fill(cKain); rectMode(CORNER);
    rect(-6, 0, 12, 38, 3);
    fill(cSkin); rect(-4, 38, 8, 22, 2); 
    fill(cSkin); rect(-6, 58, 12, 6, 2); 
    popMatrix();

    // 6. TANGAN KANAN (Diarahkan ke bawah, bukan T-pose)
    pushMatrix();
    translate(16, -85); 
    rotate(radians(-15)); 
    fill(cBaju); rectMode(CORNER);
    rect(-7, 0, 14, 40, 5); 
    fill(cSkin); rect(-5, 40, 10, 10, 2);
    popMatrix();

   // 7. KEPALA, JANGGUT, & CAPING BAMBU
    pushMatrix();
    translate(0, -102); 
    
    // Leher
    fill(cSkin); rectMode(CENTER);
    rect(0, 12, 9, 10, 2); 
    
    // Kepala Utama
    fill(cSkin); noStroke(); 
    ellipse(0, 0, 36, 38);
    
    // Janggut Putih Tua Desa
    fill(235, 235, 230);
    triangle(-10, 8, 10, 8, 0, 26);
    ellipse(0, 12, 18, 10);
    
    // Kumis Redup
    fill(210, 210, 200);
    ellipse(0, 5, 14, 4);
    
    // Rona pipi tua keriput
    fill(215, 130, 110, 90);
    ellipse(-10, 4, 6, 4);
    ellipse(10, 4, 6, 4);

    // Mata pedagang (menggunakan ellipse agar selalu terlihat jelas)
    fill(50); noStroke();
    ellipse(-7, -6, 4, 4);
    ellipse(7, -6, 4, 4);
    
    // Mulut sedikit terbuka bingung (animasi jika berbicara)
    fill(80, 40, 40);
    if (isSpeaking) {
      float mouthOpen = abs(sin(frameCount * 0.35)) * 6.0 + 2.0;
      ellipse(0, 10, 6, mouthOpen);
    } else {
      ellipse(0, 10, 6, 5);
    }

    // CAPING BAMBU TRADISIONAL
    fill(cCaping);
    triangle(0, -32, -26, -14, 26, -14);
    fill(180, 140, 90); 
    triangle(0, -32, -8, -26, 8, -26);
    
    popMatrix();
    popMatrix();
  }
}
