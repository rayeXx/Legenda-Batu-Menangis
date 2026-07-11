// Variabel internal khusus Scene 1
float titleAlpha = 0;
float sunYPosition;
float noiseOffset = 0;
float birdTime = 0;

// Variabel Awan Dinamis
float[] cloudX = { 150, 650, 1150, 400, 950 };
float[] cloudY = { 90, 150, 110, 70, 130 };

void setupScene1() {
  sunYPosition = height - 150;
}

void displayScene1() {
  // ==========================================================
  // 1. LANGIT GRADASI FAJAR ANIME (LEBIH GELAP / EARLY DAWN)
  // ==========================================================
  for (int i = 0; i < height - 150; i++) {
    float inter = map(i, 0, height - 150, 0, 1);
    color cLangit;
    if (inter < 0.6) {
      // Biru langit malam memudar ke biru abu-abu
      cLangit = lerpColor(color(35, 65, 105), color(90, 125, 160), inter / 0.6);
    } else {
      // Biru abu-abu ke oranye redup khas fajar
      cLangit = lerpColor(color(90, 125, 160), color(210, 135, 85), (inter - 0.6) / 0.4);
    }
    stroke(cLangit);
    line(0, i, width, i);
  }
  noStroke();

  // ==========================================================
  // 1.5 STARS FADE OUT (TWINKLING STARS)
  // ==========================================================
  float starAlpha = map(globalTime, 0, 8.0, 255, 0); // Memudar seiring pagi tiba
  if (starAlpha > 0) {
    randomSeed(12345);
    for (int i = 0; i < 45; i++) {
      float sx = random(width);
      float sy = random(0, 260);
      float twinkle = sin(frameCount * 0.05 + i) * 60 + 195;
      fill(255, 255, 255, starAlpha * (twinkle / 255.0));
      ellipse(sx, sy, random(1.5, 3.5), random(1.5, 3.5));
    }
  }

  // ==========================================================
  // TAMBAHAN: AWAN RAKSASA BACKGROUND (WARNA LEBIH DIM/GELAP)
  // ==========================================================
  // --- AWAN KIRI ---
  pushMatrix();
  translate(sin(frameCount * 0.01) * 8, 0); // Efek melayang sangat pelan
  // Shadow Biru Tua
  fill(55, 75, 110, 240); ellipse(100, height - 280, 450, 350); ellipse(280, height - 220, 350, 250); 
  // Mid Oranye Redup
  fill(200, 115, 80, 240); ellipse(80, height - 320, 400, 300); ellipse(250, height - 250, 320, 200); 
  // Highlight Peach Redup
  fill(220, 165, 115, 240); ellipse(50, height - 360, 350, 250); ellipse(200, height - 290, 280, 180); 
  popMatrix();

  // --- AWAN KANAN ---
  pushMatrix();
  translate(cos(frameCount * 0.01) * 8, 0);
  // Shadow Biru Tua
  fill(60, 80, 115, 240); ellipse(width - 120, height - 270, 480, 380); ellipse(width - 320, height - 200, 380, 220); 
  // Mid Oranye Redup
  fill(205, 120, 85, 240); ellipse(width - 90, height - 310, 420, 320); ellipse(width - 290, height - 240, 350, 190); 
  // Highlight Peach Redup
  fill(225, 170, 120, 240); ellipse(width - 60, height - 360, 380, 290); ellipse(width - 250, height - 280, 300, 160); 
  popMatrix();

  // 2. MATAHARI TERBIT DENGAN SOFT RADIAL GLOW (DIKAPITALISASI 2 DETIK LEBIH CEPAT)
  if (sunYPosition > height - 380) {
    sunYPosition -= 0.95; // Kecepatan dinaikkan agar terbit lebih awal
  }
  for (int r = 300; r > 100; r -= 20) {
    fill(255, 200, 120, map(r, 100, 300, 35, 0));
    ellipse(width/2 - 120, sunYPosition, r, r);
  }
  fill(255, 240, 180);
  ellipse(width/2 - 120, sunYPosition, 100, 100);

  // 3. AWAN VECTOR MINIMALIS (Awan kecil bawaan awalmu)
  fill(255, 255, 255, 110);
  for (int i = 0; i < cloudX.length; i++) {
    cloudX[i] -= (0.4 + (i * 0.1));
    if (cloudX[i] < -250) cloudX[i] = width + 250;
    
    ellipse(cloudX[i], cloudY[i], 160, 35);
    ellipse(cloudX[i] + 30, cloudY[i] - 5, 100, 30);
    ellipse(cloudX[i] - 40, cloudY[i] + 5, 80, 25);
  }

  // --- GUNUNG 1: SEBELAH KIRI (Kuning-Hijau Muted / Belakang) ---
  fill(90, 130, 120);
  beginShape();
  vertex(-150, height);
  bezierVertex(100, height-280, 250, height-380, 350, height-360); 
  bezierVertex(450, height-340, 600, height-200, 850, height);
  endShape(CLOSE);
  
  // Shadow Lereng Gunung Kiri
  fill(75, 110, 100);
  beginShape();
  vertex(350, height-360); 
  bezierVertex(400, height-300, 500, height-220, 600, height); 
  vertex(850, height);
  bezierVertex(600, height-200, 450, height-340, 350, height-360);
  endShape(CLOSE);

  // --- GUNUNG 2: SEBELAH KANAN (Hijau Kebiruan Segar / Depan) ---
  fill(105, 160, 130);
  beginShape();
  vertex(200, height);
  bezierVertex(450, height-320, 650, height-450, 750, height-430); 
  bezierVertex(850, height-410, 1050, height-200, 1350, height);
  endShape(CLOSE);
  
  // Shadow Lereng Gunung Kanan
  fill(85, 135, 110);
  beginShape();
  vertex(750, height-430); 
  bezierVertex(820, height-350, 950, height-220, 1080, height); 
  vertex(1350, height);
  bezierVertex(1050, height-200, 850, height-410, 750, height-430);
  endShape(CLOSE);

  // ==========================================================
  // TAMBAHAN: SILUET HUTAN DI KAKI GUNUNG
  // ==========================================================
  randomSeed(6789);
  fill(65, 95, 90); // Warna hijau-abu tebal siluet
  for (float tx = -50; tx < width + 100; tx += 22) {
    float th = random(40, 75);
    float ty = height - 120 + noise(tx * 0.01) * 35;
    // Gambar pohon cemara/hutan sederhana
    triangle(tx, ty - th, tx - 14, ty, tx + 14, ty);
    triangle(tx, ty - th * 0.65, tx - 9, ty, tx + 9, ty);
  }

  // ==========================================================
  // KABUT DINAMIS (FIXED: LOOP X DILEBARKAN AGAR KANAN FULL RAPI)
  // ==========================================================
  noiseOffset += 0.004;
  
  // 1. Lapisan Kabut Atmosfer Belakang
  fill(220, 235, 242, 130);
  beginShape();
  vertex(-50, height);
  for (int x = -50; x <= width + 60; x += 25) { 
    float yNoise = height - 210 + noise(x * 0.004, noiseOffset) * 40;
    vertex(x, yNoise);
  }
  vertex(width + 60, height);
  endShape(CLOSE);
  
  // 2. Lapisan Kabut Depan Lembut
  fill(235, 245, 250, 150);
  beginShape();
  vertex(-50, height);
  for (int x = -50; x <= width + 60; x += 20) { 
    float yNoise = height - 180 + noise(x * 0.006, noiseOffset + 10) * 35;
    vertex(x, yNoise);
  }
  vertex(width + 60, height);
  endShape(CLOSE);
  
  // 7. ANIMASI KAWANAN BURUNG (3 EKOR BERFORMASI V)
  birdTime += 0.003;
  if (birdTime > 1.2) birdTime = 0; 
  
  float wingWave = sin(frameCount * 0.15) * 6;
  stroke(65, 75, 85); strokeWeight(3); noFill();
  
  float[] offsetX = { 0, -50, -35 };
  float[] offsetY = { 0,  20, -20 };
  
  for (int i = 0; i < 3; i++) {
    float baseBirdX = bezierPoint(-100, 400, 900, width + 200, birdTime);
    float baseBirdY = bezierPoint(height - 300, height - 460, height - 500, height - 380, birdTime);
    
    float bX = baseBirdX + offsetX[i];
    float bY = baseBirdY + offsetY[i];
    
    if (bX > -30 && bX < width + 30) {
      beginShape();
      vertex(bX - 12, bY + wingWave);
      bezierVertex(bX - 4, bY - 2, bX, bY, bX, bY);
      bezierVertex(bX, bY, bX + 4, bY - 2, bX + 12, bY + wingWave);
      endShape();
    }
  }
  noStroke();

  // ==========================================================
  // TAMBAHAN: DEBU EMAS / EMBUN PAGI MELAYANG (GLOW PARTICLES)
  // ==========================================================
  randomSeed(9999);
  for (int i = 0; i < 30; i++) {
    float speedY = random(0.3, 0.9);
    float py = (height - 100 - (frameCount * speedY + i * 45) % 320);
    float px = (random(width) + sin(frameCount * 0.015 + i) * 25) % width;
    if (px < 0) px += width;
    
    float size = random(2.5, 5.5);
    float glowAlpha = map(py, height - 420, height - 100, 0, 160); // Pudar di atas kabut
    fill(255, 220, 140, glowAlpha);
    ellipse(px, py, size, size);
    fill(255, 240, 180, glowAlpha * 0.35);
    ellipse(px, py, size * 2.2, size * 2.2);
  }

  // 8. KONTROL TEKS JUDUL UTAMA (PREMIUM CINEMATIC)
  if (globalTime < 8.0) {
    if (titleAlpha < 255) titleAlpha += 4;
  } else {
    if (titleAlpha > 0) titleAlpha -= 6;
  }
  
  if (titleAlpha > 0) {
    float ta = titleAlpha;
    float cx = width / 2.0;
    float cy = height / 2.0 - 40;
    
    // --- Ambient glow (outer soft halo) ---
    for (int g = 80; g >= 10; g -= 8) {
      fill(255, 200, 100, ta * 0.045 * (80 - g) / 80.0);
      textSize(56 + g * 0.6);
      textAlign(CENTER, CENTER);
      text("LEGENDA BATU MENANGIS", cx, cy);
    }
    
    // --- Deep shadow (offset dark) ---
    fill(30, 20, 10, ta * 0.85);
    textSize(58);
    text("LEGENDA BATU MENANGIS", cx + 3, cy + 4);
    
    // --- Mid shadow (warm brown, closer) ---
    fill(110, 70, 30, ta * 0.7);
    text("LEGENDA BATU MENANGIS", cx + 1.5, cy + 2);
    
    // --- Outer stroke pass (dark outline simulation via 8 offsets) ---
    fill(25, 15, 5, ta * 0.55);
    textSize(58);
    String judul = "LEGENDA BATU MENANGIS";
    for (int ox = -2; ox <= 2; ox++) {
      for (int oy = -2; oy <= 2; oy++) {
        if (abs(ox) + abs(oy) == 2) {
          text(judul, cx + ox, cy + oy);
        }
      }
    }
    
    // --- Main title (warm ivory-gold gradient simulation via 3 layers) ---
    fill(255, 245, 190, ta);          // Top highlight
    text(judul, cx, cy - 1);
    fill(255, 225, 130, ta);          // Core warm gold
    text(judul, cx, cy);
    fill(230, 170, 60, ta * 0.5);    // Bottom warm edge
    text(judul, cx, cy + 1);
    
    // --- Shimmering light sweep animation ---
    float sweepX = cx - 500 + (globalTime % 4.0) * 280;
    fill(255, 255, 255, ta * 0.18);
    textSize(58);
    pushMatrix();
    translate(sweepX, cy);
    rotate(radians(-12));
    rect(-18, -50, 36, 100);
    popMatrix();
    
    // --- Decorative horizontal rule lines ---
    float lineW = 310;
    stroke(255, 200, 80, ta * 0.7);
    strokeWeight(1.2);
    line(cx - lineW - 10, cy + 32, cx - 20, cy + 32);
    line(cx + 20, cy + 32, cx + lineW + 10, cy + 32);
    
    // Tiny diamond ornament in the centre of the lines
    fill(255, 215, 80, ta);
    noStroke();
    pushMatrix();
    translate(cx, cy + 32);
    rotate(radians(45));
    rect(-4, -4, 8, 8);
    popMatrix();
    noStroke();
    
    // --- Subtitle badge ---
    // Pill background
    fill(30, 20, 5, ta * 0.65);
    rectMode(CENTER);
    rect(cx, cy + 65, 280, 30, 15);
    
    // Subtitle text
    fill(255, 220, 140, ta);
    textSize(19);
    textAlign(CENTER, CENTER);
    text("by Gacor Hebat Animation Studios", cx, cy + 65);
    rectMode(CORNER);
  }
}
