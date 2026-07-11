class CharacterAnak {
  float x, y;
  float animTime = 0;
  
  color cSkin = color(255, 225, 195);
  color cKebaya = color(235, 60, 120);
  color cKain = color(120, 50, 35);
  color cGold = color(245, 190, 40);

  CharacterAnak(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    animTime += 0.05; 
  }

  void display() {}

  void displayScene2() {
    float idleBob = sin(animTime) * 2.2; 
    float mirrorSway = sin(animTime * 1.2) * radians(4); 

    pushMatrix();
    translate(x, y + idleBob);

    // 1. RAMBUT BELAKANG
    fill(20, 18, 18); rectMode(CENTER); rect(0, -85, 42, 55, 15, 15, 5, 5); triangle(-21, -65, 21, -65, 0, -35);

    // 2. TANGAN KIRI (Lurus, Di belakang)
    pushMatrix(); 
    translate(-16, -85); 
    rotate(radians(10)); 
    fill(cKebaya); rectMode(CORNER); rect(-6, 0, 12, 40, 4); 
    fill(cSkin); rect(-5, 40, 10, 10, 2); 
    popMatrix();

    // 3. KAKI KIRI & KAKI KANAN (DIPINDAH KE SINI: Digambar di bawah layer rok)
    pushMatrix(); 
    translate(-8, -45); 
    fill(cKain); rectMode(CORNER); rect(-7, 0, 14, 38, 3); 
    fill(cSkin); rect(-5, 38, 10, 22, 2); fill(cGold); rect(-7, 56, 14, 6, 3); 
    popMatrix();
    
    pushMatrix(); 
    translate(8, -45); 
    fill(cKain); rectMode(CORNER); rect(-7, 0, 14, 38, 3); 
    fill(cSkin); rect(-5, 38, 10, 22, 2); fill(cGold); rect(-7, 56, 14, 6, 3); 
    popMatrix();

    // 4. SELENDANG
    fill(240, 210, 60, 220); 
    beginShape(); vertex(-14, -85); bezierVertex(-30, -60, -25, -20, -30, 20); vertex(-22, 20); bezierVertex(-18, -20, -22, -60, -10, -75); endShape(CLOSE);

    // 5. BADAN
    fill(cKebaya); rectMode(CENTER); rect(0, -68, 36, 46, 10); 
    fill(cGold); rect(-16, -68, 3, 40); rect(16, -68, 3, 40); fill(250, 230, 180); rect(0, -80, 12, 14, 2); fill(cGold); ellipse(0, -82, 6, 6); ellipse(0, -76, 6, 6);

    // 6. ROK (DI ATAS KAKI, menutupi paha/bagian atas kaki)
    fill(cKain); 
    beginShape(); vertex(-18, -44); vertex(18, -44); vertex(23, -10); vertex(-23, -10); endShape(CLOSE);
    
    stroke(cGold, 180); strokeWeight(1.8); 
    line(-15, -44, -19, -10); 
    line(-8, -44, -10, -10);  
    line(0, -44, 0, -10);     
    line(8, -44, 10, -10);    
    line(15, -44, 19, -10);   
    noStroke();

    // 7. TANGAN KANAN FIXED: Membentang Ke Kanan, Cermin Ke Atas
    pushMatrix(); 
    translate(14, -85); 
    rotate(radians(-90) + mirrorSway); 
    fill(cKebaya); rectMode(CORNER); rect(-7, 0, 14, 40, 5); 
    fill(cGold); rect(-8, 32, 16, 3, 1); 
    fill(cSkin); rect(-5, 40, 10, 12, 2);
    
    // Posisi Cermin
    pushMatrix(); 
    translate(0, 46); 
    rotate(radians(-90)); 
    fill(cGold); rect(-1.5, 0, 3, 12, 1); 
    stroke(cGold); strokeWeight(2); ellipse(0, 18, 18, 22); noStroke(); 
    fill(210, 245, 255); ellipse(0, 18, 14, 18); 
    popMatrix(); 
    popMatrix();

    // 8. WAJAH SIMPEL JUTEK
    pushMatrix();
    translate(0, -102); 
    
    fill(cGold); rectMode(CENTER); rect(0, 13, 10, 10, 3); 
    fill(cSkin); noStroke(); ellipse(0, 0, 42, 44); 
    
    fill(245, 140, 140, 90); ellipse(-12, 7, 7, 4); ellipse(12, 7, 7, 4); 

    stroke(30); strokeWeight(1.5); fill(255);
    arc(-8, 0, 14, 9, 0, PI, CHORD); 
    arc(8, 0, 14, 9, 0, PI, CHORD);
    
    fill(30); noStroke();
    ellipse(-8, 1, 4, 4); 
    ellipse(8, 1, 4, 4); 

    stroke(30); strokeWeight(2); noFill();
    line(-15, -6, -4, -2);
    line(15, -6, 4, -2);

    stroke(180, 40, 50); strokeWeight(1.5); noFill();
    arc(1, 11, 10, 4, PI, TWO_PI); 
    noStroke();

    fill(20, 18, 18); arc(0, -8, 44, 34, PI, TWO_PI); 
    quad(-21, -8, -16, 16, -20, 20, -23, -8); quad(21, -8, 16, 16, 20, 20, 23, -8);
    fill(cGold); triangle(0, -22, -10, -17, 10, -17); ellipse(0, -24, 4, 4); 
    popMatrix();
    
    popMatrix();
  }

  void displayWalking(float walkDist) {
    float walkPhase = walkDist * 0.048; 
    float legSwing = sin(walkPhase) * radians(28); 
    float armSwing = cos(walkPhase) * radians(24);
    float bodyBob = abs(sin(walkPhase * 2.0)) * 2.8;

    pushMatrix();
    translate(x, y - bodyBob);

    // 1. TANGAN KANAN (DI BELAKANG BADAN - Memegang Cermin diarahkan ke depan)
    pushMatrix(); 
    translate(14, -85); 
    rotate(radians(-80) + armSwing * 0.1); 
    fill(cKebaya); rectMode(CORNER); rect(-7, 0, 14, 40, 5); 
    fill(cGold); rect(-8, 32, 16, 3, 1); 
    fill(cSkin); rect(-5, 40, 10, 12, 2);
    
    // Posisi Cermin
    pushMatrix(); 
    translate(0, 46); 
    rotate(radians(-90)); 
    fill(cGold); rect(-1.5, 0, 3, 12, 1); 
    stroke(cGold); strokeWeight(2); ellipse(0, 18, 18, 22); noStroke(); 
    fill(210, 245, 255); ellipse(0, 18, 14, 18); 
    popMatrix(); 
    popMatrix();

    // 2. RAMBUT BELAKANG
    fill(20, 18, 18); rectMode(CENTER); rect(0, -85, 42, 55, 15, 15, 5, 5); triangle(-21, -65, 21, -65, 0, -35);

    // 3. KAKI KIRI & KAKI KANAN (Digambar di bawah layer rok)
    pushMatrix(); 
    translate(-8, -45); 
    rotate(legSwing);
    fill(cKain); rectMode(CORNER); rect(-7, 0, 14, 38, 3); 
    fill(cSkin); rect(-5, 38, 10, 22, 2); fill(cGold); rect(-7, 56, 14, 6, 3); 
    popMatrix();

    pushMatrix(); 
    translate(8, -45); 
    rotate(-legSwing);
    fill(cKain); rectMode(CORNER); rect(-7, 0, 14, 38, 3); 
    fill(cSkin); rect(-5, 38, 10, 22, 2); fill(cGold); rect(-7, 56, 14, 6, 3); 
    popMatrix();

    // 4. SELENDANG
    float selendangSway = sin(walkPhase) * radians(8);
    fill(240, 210, 60, 220); 
    beginShape(); 
    vertex(-14, -85); 
    bezierVertex(-30 + selendangSway*20, -60, -25 + selendangSway*40, -20, -30 + selendangSway*60, 20); 
    vertex(-22 + selendangSway*60, 20); 
    bezierVertex(-18 + selendangSway*40, -20, -22 + selendangSway*20, -60, -10, -75); 
    endShape(CLOSE);

    // 5. BADAN
    fill(cKebaya); rectMode(CENTER); rect(0, -68, 36, 46, 10); 
    fill(cGold); rect(-16, -68, 3, 40); rect(16, -68, 3, 40); fill(250, 230, 180); rect(0, -80, 12, 14, 2); fill(cGold); ellipse(0, -82, 6, 6); ellipse(0, -76, 6, 6);

    // 6. ROK (DI ATAS KAKI, menutupi paha/bagian atas kaki)
    fill(cKain); 
    beginShape(); vertex(-18, -44); vertex(18, -44); vertex(23, -10); vertex(-23, -10); endShape(CLOSE);
    
    stroke(cGold, 180); strokeWeight(1.8); 
    line(-15, -44, -19, -10); 
    line(-8, -44, -10, -10);  
    line(0, -44, 0, -10);     
    line(8, -44, 10, -10);    
    line(15, -44, 19, -10);   
    noStroke();

    // 7. WAJAH SIMPEL JUTEK
    pushMatrix();
    translate(0, -102); 
    
    fill(cGold); rectMode(CENTER); rect(0, 13, 10, 10, 3); 
    fill(cSkin); noStroke(); ellipse(0, 0, 42, 44); 
    
    fill(245, 140, 140, 90); ellipse(-10, 7, 7, 4); ellipse(14, 7, 7, 4); 

    boolean isBlink = (frameCount % 150 < 10);
    
    if (isBlink) {
      stroke(30); strokeWeight(2.0); noFill();
      arc(-6, 2, 12, 4, 0, PI);
      arc(10, 2, 12, 4, 0, PI);
      noStroke();
    } else {
      stroke(30); strokeWeight(1.5); fill(255);
      arc(-6, 0, 14, 9, 0, PI, CHORD); 
      arc(10, 0, 14, 9, 0, PI, CHORD);
      
      fill(30); noStroke();
      ellipse(-4, 1, 4, 4); 
      ellipse(12, 1, 4, 4); 
    }

    stroke(30); strokeWeight(2); noFill();
    line(-13, -6, -2, -2);
    line(17, -6, 6, -2);

    stroke(180, 40, 50); strokeWeight(1.5); noFill();
    arc(3, 11, 10, 4, PI, TWO_PI); 
    noStroke();

    fill(20, 18, 18); arc(0, -8, 44, 34, PI, TWO_PI); 
    quad(-21, -8, -16, 16, -20, 20, -23, -8); quad(21, -8, 16, 16, 20, 20, 23, -8);
    fill(cGold); triangle(0, -22, -10, -17, 10, -17); ellipse(0, -24, 4, 4); 
    popMatrix();

    // 8. TANGAN KIRI (DI ATAS BADAN - mengayun bebas)
    pushMatrix(); 
    translate(-14, -85); 
    rotate(radians(10) - armSwing); 
    fill(cKebaya); rectMode(CORNER); rect(-6, 0, 12, 40, 4);    noStroke(); fill(cSkin); rect(-5, 40, 10, 10, 2); 
    popMatrix();

    popMatrix();
  }

  void displayStoning(float progress) {
    float bodyBob = sin(frameCount * 0.05) * 0.8;
    
    // Lerp colors to stone gray
    color cSkinLeg = lerpColor(cSkin, color(110, 110, 110), constrain(progress * 2.0, 0, 1));
    color cKainRok = lerpColor(cKain, color(100, 100, 100), constrain(progress * 1.8, 0, 1));
    color cKebayaTorso = lerpColor(cKebaya, color(120, 120, 120), constrain(progress * 1.5, 0, 1));
    color cSkinHead = lerpColor(cSkin, color(110, 110, 110), constrain(progress * 1.2, 0, 1));
    color cGoldBros = lerpColor(cGold, color(135, 135, 135), progress);
    color cRambutHead = lerpColor(color(20, 18, 18), color(90, 90, 90), progress);
    
    pushMatrix();
    translate(x, y - bodyBob);

    // 1. RAMBUT BELAKANG
    fill(cRambutHead); rectMode(CENTER); rect(0, -85, 42, 55, 15, 15, 5, 5); triangle(-21, -65, 21, -65, 0, -35);

    // 2. TANGAN KANAN (Rileks di samping)
    pushMatrix(); 
    translate(14, -85); 
    rotate(radians(15)); 
    fill(cKebayaTorso); rectMode(CORNER); rect(-7, 0, 14, 40, 5); 
    fill(cGoldBros); rect(-8, 32, 16, 3, 1); 
    fill(cSkinHead); rect(-5, 40, 10, 10, 2); 
    popMatrix();

    // 3. KAKI KIRI & KAKI KANAN
    pushMatrix(); 
    translate(-8, -45); 
    fill(cKainRok); rectMode(CORNER); rect(-7, 0, 14, 38, 3); 
    fill(cSkinLeg); rect(-5, 38, 10, 22, 2); fill(cGoldBros); rect(-7, 56, 14, 6, 3); 
    popMatrix();
    
    pushMatrix(); 
    translate(8, -45); 
    fill(cKainRok); rectMode(CORNER); rect(-7, 0, 14, 38, 3); 
    fill(cSkinLeg); rect(-5, 38, 10, 22, 2); fill(cGoldBros); rect(-7, 56, 14, 6, 3); 
    popMatrix();

    // 4. SELENDANG
    fill(lerpColor(color(240, 210, 60, 220), color(125, 125, 125, 220), progress)); 
    beginShape(); vertex(-14, -85); bezierVertex(-30, -60, -25, -20, -30, 20); vertex(-22, 20); bezierVertex(-18, -20, -22, -60, -10, -75); endShape(CLOSE);

    // 5. BADAN
    fill(cKebayaTorso); rectMode(CENTER); rect(0, -68, 36, 46, 10); 
    fill(cGoldBros); rect(-16, -68, 3, 40); rect(16, -68, 3, 40); 
    fill(lerpColor(color(250, 230, 180), color(130, 130, 130), progress)); rect(0, -80, 12, 14, 2); 
    fill(cGoldBros); ellipse(0, -82, 6, 6); ellipse(0, -76, 6, 6);

    // 6. ROK (DI ATAS KAKI)
    fill(cKainRok); 
    beginShape(); vertex(-18, -44); vertex(18, -44); vertex(23, -10); vertex(-23, -10); endShape(CLOSE);
    
    stroke(cGoldBros, 180); strokeWeight(1.8); 
    line(-15, -44, -19, -10); 
    line(-8, -44, -10, -10);  
    line(0, -44, 0, -10);     
    line(8, -44, 10, -10);    
    line(15, -44, 19, -10);   
    noStroke();

    // 7. WAJAH PANIK TERKEJUT
    pushMatrix();
    translate(0, -102); 
    fill(cGoldBros); rectMode(CENTER); rect(0, 13, 10, 10, 3); 
    fill(cSkinHead); noStroke(); ellipse(0, 0, 42, 44); 
    
    // Rona pipi pudar seiring jadi batu
    fill(245, 140, 140, map(progress, 0, 1, 90, 0)); 
    ellipse(-12, 7, 7, 4); ellipse(12, 7, 7, 4); 

    // Mata Bulat Shocked Besar
    stroke(30); strokeWeight(1.8); fill(255);
    ellipse(-7, 0, 13, 13); 
    ellipse(9, 0, 13, 13);
    fill(30); noStroke();
    ellipse(-6, 0, 5, 5); 
    ellipse(10, 0, 5, 5); 

    // Alis Panik Miring ke Atas
    stroke(30); strokeWeight(2.2); noFill();
    line(-13, -7, -3, -11);
    line(15, -7, 5, -11);
    
    // Mulut Terbuka Panik (O-shape)
    noStroke();
    fill(80, 25, 25);
    ellipse(1, 12, 9, 11);

    // Rambut Depan
    fill(cRambutHead); arc(0, -8, 44, 34, PI, TWO_PI); 
    quad(-21, -8, -16, 16, -20, 20, -23, -8); quad(21, -8, 16, 16, 20, 20, 23, -8);
    fill(cGoldBros); triangle(0, -22, -10, -17, 10, -17); ellipse(0, -24, 4, 4); 
    popMatrix();

    // 8. TANGAN KIRI (Menolak panik / Terangkat sedikit)
    pushMatrix(); 
    translate(-14, -85); 
    rotate(radians(-45) * (1.0 - progress) + radians(-15) * progress); // drops down as she solidifies
    fill(cKebayaTorso); rectMode(CORNER); rect(-6, 0, 12, 40, 4); 
    fill(cSkinHead); rect(-5, 40, 10, 10, 2); 
    popMatrix();

    // RETAKAN BATU JAGED (Terbentuk perlahan)
    if (progress > 0.2) {
      stroke(35, 210); strokeWeight(1.4); noFill();
      // Retakan di kaki
      line(-8, 5, -5, 12); line(-5, 12, -10, 22);
      
      if (progress > 0.5) {
        // Retakan di rok
        line(12, -25, 5, -18); line(5, -18, 10, -8);
      }
      if (progress > 0.8) {
        // Retakan di dada & wajah
        line(-8, -60, -3, -54); line(-3, -54, -6, -48);
        line(2, -92, 6, -88);
      }
      noStroke();
    }

    // AIR MATA PENYESALAN MENGALIR DARi BATU (Selalu Mengalir)
    if (progress > 0.1) {
      fill(135, 205, 255, 220); noStroke();
      float tearY = (frameCount * 1.3) % 24;
      ellipse(-6, -102 + tearY, 2.5, 4.5);
      ellipse(10, -102 + tearY, 2.5, 4.5);
    }

    popMatrix();
  }
}
