class CharacterIbu {
  float x, y;
  float animTime = 0;
  
  color cSkin = color(225, 185, 150);
  color cBaju = color(100, 105, 100);
  color cKain = color(90, 75, 65);

  CharacterIbu(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    animTime += 0.025; // FIXED: Diperlambat signifikan agar gerakan menyapu kalem/slow-motion
  }

  void display() {
    pushMatrix(); translate(x, y); fill(cSkin); ellipse(0, -102, 42, 44); popMatrix();
  }

  void displayScene2() {
    // Membalik arah ayunan ke kanan depan dengan sudut halus melambat
    float sapuSwing = sin(animTime * 2.0) * radians(15); 
    float bodyBob = abs(sin(animTime * 2.0)) * 0.5;

    pushMatrix();
    translate(x, y + bodyBob);
    rotate(radians(4)); 

    // 1. TANGAN KIRI (Diam rapi memegang keranjang)
    pushMatrix();
    translate(-16, -85); rotate(radians(12)); 
    fill(cBaju); rectMode(CORNER); rect(-6, 0, 12, 38, 4); 
    fill(cSkin); rect(-4, 38, 8, 10, 2);
    
    // KERANJANG ANYAMAN (Bergelantungan di tangan kiri)
    pushMatrix();
    translate(0, 40); // Di posisi telapak tangan
    rotate(sapuSwing * 0.3); // Sedikit bergoyang mengikuti tubuh
    
    // Tali/Gagang keranjang melingkar di telapak tangan
    noFill(); stroke(100, 70, 45); strokeWeight(3);
    arc(0, 0, 18, 22, PI, TWO_PI);
    noStroke();
    
    // Keranjang Anyaman
    fill(130, 95, 65); rect(-13, 10, 26, 35, 3);
    fill(165, 125, 85); rect(-11, 10, 22, 35, 3);
    popMatrix();
    
    popMatrix();

    // 3. BADAN MAIN
    fill(cBaju); rectMode(CENTER); rect(0, -68, 36, 46, 10);
    fill(85, 75, 70); rect(8, -52, 12, 10, 2); noStroke();

    // 4. ROK KAIN
    fill(cKain); beginShape(); vertex(-18, -46); vertex(18, -46); vertex(20, -10); vertex(-20, -10); endShape(CLOSE);

    // 5. KAKI
    pushMatrix(); translate(-7, -45); fill(cKain); rectMode(CORNER); rect(-6, 0, 12, 38, 3); fill(cSkin); rect(-4, 38, 8, 22, 2); fill(cSkin); rect(-6, 58, 12, 6, 2); popMatrix();
    pushMatrix(); translate(7, -45); fill(cKain); rectMode(CORNER); rect(-6, 0, 12, 38, 3); fill(cSkin); rect(-4, 38, 8, 22, 2); fill(cSkin); rect(-6, 58, 12, 6, 2); popMatrix();

    // 6. TANGAN KANAN FIXED: POROS NYAPU SATU TANGAN KE ARAH KANAN DEPAN
    pushMatrix();
    translate(14, -85); 
    rotate(radians(-15) - sapuSwing); // Rotasi diatur berayun menyapu ke depan kanan layar
    fill(cBaju); rectMode(CORNER); rect(-7, 0, 14, 40, 5); 
    fill(cSkin); rect(-5, 40, 10, 12, 2);
    
    // ==========================================================
    // DETAIL SAPU BARU: Gagang, Lilitan Tali Ikat & Ujung Lidi Renggang
    // ==========================================================
    pushMatrix();
    translate(0, 42);
    rotate(radians(20)); // Kemiringan sapu lidi mengarah ke kanan bawah tanah
    
    // Gagang Kayu Sapu
    stroke(140, 100, 60); strokeWeight(3.5); line(0, -15, 0, 45); noStroke();
    
    // Badan Jerami Utama Sapu
    fill(205, 170, 120); triangle(0, 45, -20, 85, 20, 85); 
    
    // DETAIL: Tali Pengikat Sapu Tradisional (Cokelat Tua)
    fill(100, 70, 45);
    rectMode(CENTER);
    rect(0, 50, 16, 5, 1);
    rect(0, 57, 20, 5, 1);
    
    // DETAIL: Guratan Helai Sapu Lidi Renggang Alami di Dasar Tanah
    stroke(160, 125, 80); strokeWeight(1.5);
    line(-10, 85, -16, 95);
    line(-4, 85, -6, 96);
    line(0, 85, 0, 97);
    line(5, 85, 8, 96);
    line(11, 85, 17, 95);
    noStroke();
    
    popMatrix();
    popMatrix();

    // 7. KEPALA TUA SAYU (Menatap Lembut Ke Kanan Bawah)
    pushMatrix();
    translate(0, -102); rotate(radians(3)); 
    fill(cSkin); rectMode(CENTER); rect(0, 12, 9, 10, 2); 
    fill(cSkin); noStroke(); ellipse(0, 0, 42, 44); 

    // Mata & Kerutan Sayu
    fill(255); stroke(70, 60, 50); strokeWeight(1.2);
    beginShape(); vertex(-13, -1); bezierVertex(-10, -5, -5, -5, -3, -1); bezierVertex(-5, 2, -10, 2, -13, -1); endShape(CLOSE);
    beginShape(); vertex(3, -1); bezierVertex(5, -5, 10, -5, 13, -1); bezierVertex(10, 2, 5, 2, 3, -1); endShape(CLOSE);
    noStroke(); fill(50); ellipse(-8, -1.5, 4, 4); ellipse(8, -1.5, 4, 4);
    stroke(70, 60, 50); strokeWeight(2); noFill();
    beginShape(); vertex(-3, -1); bezierVertex(-6, -5, -11, -4, -14, -1); endShape();
    beginShape(); vertex(3, -1); bezierVertex(6, -5, 11, -4, 14, -1); endShape();
    stroke(195, 150, 115); strokeWeight(1.2); noFill(); arc(0, -7, 6, 3, PI, TWO_PI);
    line(-13, -1, -16, -2); line(12, -1, 16, -2); arc(-8, 3, 8, 3, 0, PI); arc(8, 3, 8, 3, 0, PI); noStroke();
    stroke(120, 60, 50); strokeWeight(1.8); noFill(); arc(0, 11, 7, 5, PI, TWO_PI); noStroke();

    fill(80, 78, 78); arc(0, -5, 44, 34, PI, TWO_PI); quad(-21, -5, -17, 12, -20, 14, -23, -5); quad(21, -5, 17, 12, 20, 14, 23, -5);
    fill(65, 63, 63); ellipse(-15, -14, 13, 13);
    
    stroke(60, 50, 45); strokeWeight(1.8); noFill();
    beginShape(); vertex(-3, -6); bezierVertex(-6, -8, -11, -7, -14, -3); endShape();
    beginShape(); vertex(3, -6); bezierVertex(6, -8, 11, -7, 14, -3); endShape();
    noStroke();
    popMatrix();
    popMatrix();
  }

  void displayWalking(float walkDist) {
    float walkPhase = walkDist * 0.048; // Diperlambat 40% agar terlihat lebih natural
    float legSwing = sin(walkPhase) * radians(20); 
    float armSwing = cos(walkPhase) * radians(18); 
    float bodyBob = abs(sin(walkPhase * 2.0)) * 2.0;
    float basketSway = sin(walkPhase) * radians(12);

    pushMatrix();
    translate(x, y - bodyBob);
    rotate(radians(6)); 

    // 1. TANGAN KANAN (DI BELAKANG BADAN - Mengayun lelah)
    pushMatrix();
    translate(14, -85); 
    rotate(radians(-15) + armSwing); 
    fill(cBaju); rectMode(CORNER); rect(-7, 0, 14, 40, 5); 
    fill(cSkin); rect(-5, 40, 10, 12, 2);
    popMatrix();

    // 2. KAKI
    pushMatrix(); 
    translate(-7, -45); 
    rotate(legSwing);
    fill(cKain); rectMode(CORNER); rect(-6, 0, 12, 38, 3); 
    fill(cSkin); rect(-4, 38, 8, 22, 2); fill(cSkin); rect(-6, 58, 12, 6, 2); 
    popMatrix();
    
    pushMatrix(); 
    translate(7, -45); 
    rotate(-legSwing);
    fill(cKain); rectMode(CORNER); rect(-6, 0, 12, 38, 3); 
    fill(cSkin); rect(-4, 38, 8, 22, 2); fill(cSkin); rect(-6, 58, 12, 6, 2); 
    popMatrix();

    // 3. BADAN MAIN
    fill(cBaju); rectMode(CENTER); rect(0, -68, 36, 46, 10);
    fill(85, 75, 70); rect(8, -52, 12, 10, 2); noStroke();

    // 4. ROK KAIN
    fill(cKain); beginShape(); vertex(-18, -46); vertex(18, -46); vertex(20, -10); vertex(-20, -10); endShape(CLOSE);

    // 5. KEPALA TUA SAYU (Menatap Lembut Ke Kanan Bawah / Tunduk)
    pushMatrix();
    translate(0, -102); rotate(radians(8)); 
    fill(cSkin); rectMode(CENTER); rect(0, 12, 9, 10, 2); 
    fill(cSkin); noStroke(); ellipse(0, 0, 42, 44); 

    // Mekanisme berkedip dinamis
    boolean isBlink = (frameCount % 160 < 12);
    
    if (isBlink) {
      stroke(70, 60, 50); strokeWeight(1.8); noFill();
      arc(-6, 0, 10, 3, 0, PI);
      arc(10, 0, 10, 3, 0, PI);
      
      beginShape(); vertex(-1, -1); bezierVertex(-4, -5, -9, -4, -12, -1); endShape();
      beginShape(); vertex(5, -1); bezierVertex(8, -5, 13, -4, 16, -1); endShape();
      stroke(195, 150, 115); strokeWeight(1.2); noFill();
      line(-11, -1, -14, -2); line(14, -1, 18, -2);
      noStroke();
    } else {
      fill(255); stroke(70, 60, 50); strokeWeight(1.2);
      beginShape(); vertex(-11, -1); bezierVertex(-8, -5, -3, -5, -1, -1); bezierVertex(-3, 2, -8, 2, -11, -1); endShape(CLOSE);
      beginShape(); vertex(5, -1); bezierVertex(7, -5, 12, -5, 15, -1); bezierVertex(12, 2, 7, 2, 5, -1); endShape(CLOSE);
      
      noStroke(); fill(50); 
      ellipse(-5, -1.0, 4, 4); 
      ellipse(11, -1.0, 4, 4);
      
      stroke(70, 60, 50); strokeWeight(2); noFill();
      beginShape(); vertex(-1, -1); bezierVertex(-4, -5, -9, -4, -12, -1); endShape();
      beginShape(); vertex(5, -1); bezierVertex(8, -5, 13, -4, 16, -1); endShape();
      
      stroke(195, 150, 115); strokeWeight(1.2); noFill(); arc(2, -7, 6, 3, PI, TWO_PI);
      line(-11, -1, -14, -2); line(14, -1, 18, -2); arc(-6, 3, 8, 3, 0, PI); arc(10, 3, 8, 3, 0, PI); noStroke();
    }

    // Mulut Ibu
    stroke(120, 60, 50); strokeWeight(1.8); noFill(); arc(2, 11, 7, 5, PI, TWO_PI); noStroke();

    fill(80, 78, 78); arc(0, -5, 44, 34, PI, TWO_PI); quad(-21, -5, -17, 12, -20, 14, -23, -5); quad(21, -5, 17, 12, 20, 14, 23, -5);
    fill(65, 63, 63); ellipse(-15, -14, 13, 13);
    
    stroke(60, 50, 45); strokeWeight(1.8); noFill();
    beginShape(); vertex(-3, -6); bezierVertex(-6, -8, -11, -7, -14, -3); endShape();
    beginShape(); vertex(3, -6); bezierVertex(6, -8, 11, -7, 14, -3); endShape();
    noStroke();
    popMatrix();

    // 6. TANGAN KIRI (DI ATAS BADAN - Mengayun dengan keranjang di genggaman)
    pushMatrix();
    translate(-16, -85); 
    rotate(radians(15) - armSwing); 
    fill(cBaju); rectMode(CORNER); rect(-6, 0, 12, 38, 4); 
    fill(cSkin); rect(-4, 38, 8, 10, 2);
    
    // KERANJANG ANYAMAN
    pushMatrix();
    translate(0, 40); 
    rotate(basketSway * 0.5); 
    noFill(); stroke(100, 70, 45); strokeWeight(3);
    arc(0, 0, 18, 22, PI, TWO_PI);
    noStroke();
    fill(130, 95, 65); rect(-13, 10, 26, 35, 3);
    fill(165, 125, 85); rect(-11, 10, 22, 35, 3);
    popMatrix();
    
    popMatrix();

    popMatrix();
  }

  void displayPraying(float prayProgress) {
    float bodyBob = sin(frameCount * 0.05) * 1.0;
    
    pushMatrix();
    // Translate down to represent kneeling/sitting on the ground
    translate(x, y + 25 * prayProgress - bodyBob);

    // 1. KAKI / POSISI TERDUDUK (Bersimpuh/Kneeling)
    if (prayProgress < 0.55) {
      // Standing legs
      pushMatrix(); translate(-7, -45); fill(cKain); rectMode(CORNER); rect(-6, 0, 12, 38, 3); fill(cSkin); rect(-4, 38, 8, 22, 2); fill(cSkin); rect(-6, 58, 12, 6, 2); popMatrix();
      pushMatrix(); translate(7, -45); fill(cKain); rectMode(CORNER); rect(-6, 0, 12, 38, 3); fill(cSkin); rect(-4, 38, 8, 22, 2); fill(cSkin); rect(-6, 58, 12, 6, 2); popMatrix();
      
      // Standing Skirt (Rok Kain)
      fill(cKain); beginShape(); vertex(-18, -46); vertex(18, -46); vertex(20, -10); vertex(-20, -10); endShape(CLOSE);
    } else {
      // Kneeling folded feet tucked behind (resting on the ground at Y = -25)
      pushMatrix();
      translate(-14, -25);
      fill(cSkin); rectMode(CORNER);
      rect(-5, -4, 10, 8, 2);
      popMatrix();
      
      pushMatrix();
      translate(10, -25);
      fill(cSkin); rectMode(CORNER);
      rect(-5, -4, 10, 8, 2);
      popMatrix();

      // Folded Kneeling Skirt (Wider resting on the ground Y = -25)
      fill(cKain); 
      beginShape(); 
      vertex(-18, -46); 
      vertex(18, -46); 
      vertex(28, -25); 
      vertex(-28, -25); 
      endShape(CLOSE);
    }

    // 2. BADAN MAIN
    fill(cBaju); rectMode(CENTER); rect(0, -68, 36, 46, 10);
    fill(85, 75, 70); rect(8, -52, 12, 10, 2); noStroke();

    // 3. TANGAN KANAN (Tetap lurus ke bawah di samping badan)
    pushMatrix();
    translate(14, -68); 
    rotate(radians(-15)); 
    fill(cBaju); rectMode(CORNER); rect(-7, 0, 14, 40, 5); 
    fill(cSkin); rect(-5, 40, 10, 12, 2);
    popMatrix();

    // 4. TANGAN KIRI (Tetap lurus ke bawah di samping badan)
    pushMatrix();
    translate(-14, -68); 
    rotate(radians(15)); 
    fill(cBaju); rectMode(CORNER); rect(-6, 0, 12, 38, 4); 
    fill(cSkin); rect(-4, 38, 8, 10, 2);
    popMatrix();

    // 5. KEPALA TUA MENUNDUK SEDIH (Bowed down but straight facing forward)
    pushMatrix();
    translate(0, -102); 
    // Straight head (no rotation)
    fill(cSkin); rectMode(CENTER); rect(0, 12, 9, 10, 2); 
    fill(cSkin); noStroke(); ellipse(0, 0, 42, 44); 

    // Mata Terpejam Sedih (Garis lengkung sedih)
    stroke(70, 60, 50); strokeWeight(2.0); noFill();
    arc(-6, 1, 10, 4, 0, PI);
    arc(10, 1, 10, 4, 0, PI);
    
    // Alis Sedih Miring ke Luar
    line(-11, -5, -3, -8);
    line(11, -5, 3, -8);
    
    // Mulut sedih cemberut
    stroke(120, 60, 50); strokeWeight(1.8);
    arc(2, 11, 7, 5, PI, TWO_PI); 
    noStroke();

    // Rambut beruban sanggul
    fill(80, 78, 78); arc(0, -5, 44, 34, PI, TWO_PI); quad(-21, -5, -17, 12, -20, 14, -23, -5); quad(21, -5, 17, 12, 20, 14, 23, -5);
    fill(65, 63, 63); ellipse(-15, -14, 13, 13);
    
    stroke(60, 50, 45); strokeWeight(1.8); noFill();
    beginShape(); vertex(-3, -6); bezierVertex(-6, -8, -11, -7, -14, -3); endShape();
    beginShape(); vertex(3, -6); bezierVertex(6, -8, 11, -7, 14, -3); endShape();
    noStroke();
    
    // EFEK AIR MATA JATUH
    if (prayProgress > 0.5) {
      fill(135, 205, 255, 200);
      float tearY1 = (frameCount * 1.5) % 25;
      float tearY2 = ((frameCount + 20) * 1.5) % 25;
      ellipse(-6, 4 + tearY1, 3, 5);
      ellipse(10, 4 + tearY2, 3, 5);
    }
    
    popMatrix();
    popMatrix();
  }
}
