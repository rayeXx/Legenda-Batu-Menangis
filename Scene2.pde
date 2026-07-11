float smokeTime = 0;
float envAnimTime = 0;
ArrayList<PVector> debuSapu = new ArrayList<PVector>();
float birdTimeScene2 = 0; 

void setupScene2() {}

void displayScene2() {
  // Reset drawing state — prevent any state leak from Scene 1 transforms
  rectMode(CORNER);
  noStroke();
  textAlign(LEFT, BASELINE);
  
  smokeTime += 0.04;
  envAnimTime += 0.03;
  
  // Kontrol Waktu Terbang Burung Melintas
  birdTimeScene2 += 0.0035;
  if (birdTimeScene2 > 1.3) birdTimeScene2 = 0; 
  
  // ==========================================================
  // 1. LANGIT GRADASI PAGI
  // ==========================================================
  for (int i = 0; i < height - 150; i++) {
    float inter = map(i, 0, height - 150, 0, 1);
    color cLangit = lerpColor(color(105, 175, 190), color(245, 175, 110), inter);
    stroke(cLangit);
    line(0, i, width, i);
  }
  noStroke();

  // ==========================================================
  // 2. MATAHARI TERBIT
  // ==========================================================
  pushMatrix();
  translate(width/2, height - 150);
  fill(240, 190, 60, 100); arc(0, 0, 650, 650, PI, TWO_PI); 
  fill(245, 210, 70, 150); arc(0, 0, 480, 480, PI, TWO_PI); 
  fill(255, 230, 85, 220); arc(0, 0, 320, 320, PI, TWO_PI); 
  popMatrix();

  // ==========================================================
  // 3. AWAN VOLUMETRIK
  // ==========================================================
  pushMatrix(); translate(0 + sin(envAnimTime*0.05)*15, 0); fill(250, 190, 150, 230); ellipse(100, height - 350, 450, 350); fill(255, 165, 120, 240); ellipse(50, height - 220, 500, 280); fill(250, 145, 95,  250); ellipse(150, height - 170, 420, 180); popMatrix();
  pushMatrix(); translate(width + cos(envAnimTime*0.05)*15, 0); fill(250, 190, 150, 230); ellipse(-100, height - 380, 480, 380); fill(255, 165, 120, 240); ellipse(-80, height - 240, 550, 320); fill(250, 145, 95,  250); ellipse(-180, height - 190, 480, 200); popMatrix();
  fill(255, 185, 130, 210); ellipse(width/2 - 120, height - 320, 180, 25); ellipse(width/2 + 160, height - 280, 240, 30); ellipse(width/2 - 280, height - 240, 200, 20);

  // ==========================================================
  // 4. BUKIT/GUNUNG SILUET
  // ==========================================================
  fill(65, 60, 95); beginShape(); vertex(0, height - 150); vertex(0, height - 230); bezierVertex(200, height - 290, 400, height - 180, 600, height - 210); bezierVertex(800, height - 250, 1000, height - 190, width, height - 230); vertex(width, height - 150); endShape(CLOSE);
  fill(30, 65, 70); beginShape(); vertex(0, height - 150); vertex(0, height - 190); bezierVertex(300, height - 130, 500, height - 210, 700, height - 160); bezierVertex(900, height - 120, 1100, height - 170, width, height - 160); vertex(width, height - 150); endShape(CLOSE);

  // ==========================================================
  // 5. BURUNG MELINTAS
  // ==========================================================
  float wingWave = sin(frameCount * 0.18) * 6;
  stroke(45, 40, 55); strokeWeight(2.5); noFill();
  float[] birdOffsetX = { 0, -50, -35 }; float[] birdOffsetY = { 0,  25, -20 };
  for (int i = 0; i < 3; i++) {
    float bBaseX = bezierPoint(-100, 350, 850, width + 150, birdTimeScene2);
    float bBaseY = bezierPoint(height - 480, height - 550, height - 580, height - 450, birdTimeScene2);
    float bX = bBaseX + birdOffsetX[i]; float bY = bBaseY + birdOffsetY[i];
    if (bX > -30 && bX < width + 30) {
      beginShape(); vertex(bX - 10, bY + wingWave); bezierVertex(bX - 4, bY - 2, bX, bY, bX, bY); bezierVertex(bX, bY, bX + 4, bY - 2, bX + 10, bY + wingWave); endShape();
    }
  }
  noStroke();

  // ==========================================================
  // 6. HALAMAN RUMAH (HYPER-DETAIL GROUND)
  // ==========================================================
  // A. Gradasi Tanah (Hijau ke Cokelat Gelap)
  for (int i = height - 150; i <= height; i++) {
    float inter = map(i, height - 150, height, 0, 1);
    color cTanah = lerpColor(color(75, 125, 90), color(45, 65, 50), inter);
    stroke(cTanah);
    line(0, i, width, i);
  }
  noStroke();
  
  // B. Genangan Lumpur Basah (Mud Patches)
  fill(55, 45, 35, 140);
  ellipse(width/2 - 200, height - 60, 140, 25);
  ellipse(width/2 + 250, height - 40, 180, 35);
  ellipse(250, height - 120, 100, 18);
  ellipse(850, height - 90, 120, 22);

  // C. Kerikil & Bebatuan
  fill(100, 90, 80, 200);
  ellipse(width/2 - 250, height - 80, 16, 7); ellipse(width/2 - 60, height - 120, 10, 5);
  ellipse(width/2 + 280, height - 90, 14, 6); ellipse(width/2 + 90, height - 60, 18, 8);
  ellipse(380, height - 40, 25, 9); ellipse(880, height - 110, 35, 12);
  
  // D. Ranting Patah Berserakan (Twigs)
  stroke(55, 40, 25); strokeWeight(2.5);
  line(180, height - 50, 220, height - 40); line(195, height - 45, 190, height - 35); // Ranting kiri
  line(950, height - 60, 990, height - 75); line(970, height - 67, 980, height - 55); // Ranting kanan
  line(350, height - 100, 320, height - 95);
  noStroke();

  // E. Rumput Rimbun Dinamis (Bergoyang tertiup angin)
  stroke(55, 100, 70); strokeWeight(2);
  for (int i = 20; i < width; i += 35) { // Jarak dirapatkan jadi 35 (lebih rimbun)
    float wave = sin(envAnimTime + i) * 6;
    // Layer rumput belakang
    line(i, height - 150, i + wave, height - 165); 
    line(i + 10, height - 150, i + 10 + wave, height - 160);
    // Layer rumput depan (di atas tanah/lumpur)
    if (i % 3 == 0) {
      stroke(45, 85, 55);
      line(i + 5, height - 120, i + 5 + wave*1.5, height - 135);
      stroke(55, 100, 70);
    }
  }
  noStroke();

  // ==========================================================
  // 7. RUMAH GUBUG TRADISIONAL PANGGUNG (ELEVATED STILT HUT)
  // ==========================================================
  // A. Tiang Penyangga Kolong Rumah (Stilts)
  fill(65, 45, 30);
  rect(width/2 - 135, height - 210, 16, 60, 2);
  rect(width/2 - 80, height - 210, 14, 60, 2);
  rect(width/2 - 20, height - 210, 14, 60, 2);
  rect(width/2 + 40, height - 210, 14, 60, 2);
  rect(width/2 + 95, height - 210, 14, 60, 2);
  rect(width/2 + 125, height - 210, 16, 60, 2);
  
  // B. Dinding Rumah - Bambu Anyam (Gedek Weave)
  fill(95, 70, 48); rect(width/2 - 140, height - 350, 280, 140, 2); 
  stroke(80, 55, 35, 120); strokeWeight(1.5);
  for (int wx = width/2 - 140; wx < width/2 + 140; wx += 10) {
    line(wx, height - 350, wx + 10, height - 210);
    line(wx + 10, height - 350, wx, height - 210);
  }
  noStroke();
  
  // Pilar utama rangka dinding kayu lapuk
  fill(75, 55, 40); 
  rect(width/2 - 142, height - 355, 12, 145); 
  rect(width/2 + 130, height - 355, 12, 145);
  rect(width/2 - 5, height - 350, 10, 140);
  
  // C. Pintu & Jendela Terbuka Dengan Penyangga Kayu
  // Pintu Lapuk
  fill(55, 35, 20); rect(width/2 + 60, height - 290, 32, 80, 2);
  fill(45, 25, 12); ellipse(width/2 + 85, height - 250, 4, 4); // Gagang pintu
  
  // Tangga Kayu ke Pintu
  stroke(75, 50, 32); strokeWeight(4);
  line(width/2 + 54, height - 148, width/2 + 62, height - 210); // Tiang kiri
  line(width/2 + 84, height - 148, width/2 + 92, height - 210); // Tiang kanan
  strokeWeight(3);
  line(width/2 + 56, height - 162, width/2 + 86, height - 162); // Anak tangga 1
  line(width/2 + 58, height - 180, width/2 + 88, height - 180); // Anak tangga 2
  line(width/2 + 60, height - 198, width/2 + 90, height - 198); // Anak tangga 3
  noStroke();

  // Jendela Bambu Terbuka (Propped Open)
  fill(35, 25, 18); rect(width/2 - 75, height - 290, 50, 45, 2); // Lubang jendela gelap
  pushMatrix();
  translate(width/2 - 75, height - 290);
  rotate(radians(-35)); // Daun jendela terangkat keluar/ke atas
  fill(85, 60, 40); rect(0, 0, 50, 45, 2);
  stroke(70, 48, 30, 100); strokeWeight(1.2);
  for(int wx = 0; wx < 50; wx += 8) {
    line(wx, 0, wx + 5, 45);
    line(wx + 5, 0, wx, 45);
  }
  popMatrix();
  noStroke();
  // Kayu Penyangga Jendela (Prop Stick)
  stroke(100, 75, 50); strokeWeight(2.5);
  line(width/2 - 50, height - 245, width/2 - 58, height - 265);
  noStroke();

  // D. Aksesoris Halaman/Kolong (Tempayan Air & Kayu Bakar)
  // Tumpukan Kayu Bakar
  fill(80, 55, 35);
  rectMode(CENTER);
  rect(width/2 - 110, height - 160, 35, 10, 2);
  rect(width/2 - 105, height - 168, 30, 9, 2);
  rect(width/2 - 112, height - 176, 28, 8, 2);
  fill(130, 95, 65);
  ellipse(width/2 - 128, height - 160, 5, 10);
  ellipse(width/2 - 120, height - 168, 5, 9);
  ellipse(width/2 - 126, height - 176, 4, 8);
  rectMode(CORNER);
  
  // Tempayan Air Tanah Liat
  fill(110, 65, 45); 
  ellipse(width/2 - 40, height - 162, 28, 28);
  fill(85, 45, 30);
  ellipse(width/2 - 40, height - 172, 22, 8); // Bibir tempayan
  fill(35, 20, 15);
  ellipse(width/2 - 40, height - 172, 16, 4); // Lubang air
  fill(30, 25, 20, 80);
  ellipse(width/2 - 40, height - 148, 22, 5); // Bayangan tanah tempayan
  noStroke();

  // E. Atap Rumbia / Jerami (Organic Thatch Roof)
  fill(80, 62, 45);
  beginShape();
  vertex(width/2 - 180, height - 345);
  vertex(width/2 + 180, height - 345);
  vertex(width/2 + 30, height - 440);
  vertex(width/2 - 30, height - 415);
  vertex(width/2 - 70, height - 440);
  endShape(CLOSE);
  
  // Rumbai-rumbai jerami/ijuk lapuk bergantungan
  stroke(60, 45, 30); strokeWeight(2);
  for (float rx = -185; rx <= 185; rx += 4.5) {
    float rHeight = random(12, 24);
    line(width/2 + rx, height - 345, width/2 + rx + random(-3, 3), height - 345 + rHeight);
  }
  
  // Tekstur anyaman daun kelapa/jerami kering di atap
  stroke(95, 75, 55, 120);
  for (float i = -170; i <= 170; i += 12) {
    float bottomX = width/2 + i;
    float topX = width/2 + (i * 0.18);
    line(bottomX, height - 345, topX - 25, height - 430);
  }
  noStroke();
  
  // Tambalan Atap Bocor (Lapuk)
  fill(40, 32, 25);
  triangle(width/2 - 50, height - 380, width/2 - 25, height - 370, width/2 - 35, height - 395);
  
  // ----------------------------------------------------------
  // ASAP CEROBONG (Membesar, Naik, lalu Pudar/Menghilang)
  // ----------------------------------------------------------
  fill(60, 48, 38); rect(width/2 - 110, height - 410, 16, 65, 1); // Cerobong bambu/kayu lapuk
  stroke(45, 35, 25); strokeWeight(1.5);
  line(width/2 - 110, height - 390, width/2 - 94, height - 390);
  line(width/2 - 110, height - 370, width/2 - 94, height - 370);
  noStroke();
  
  for (int i = 0; i < 6; i++) {
    // Menghitung offset Y berulang (0 sampai 180 px ke atas)
    float flyUpOffset = (smokeTime * 25 + i * 30) % 180; 
    
    float sX = (width/2 - 99) + sin(smokeTime + i) * (10 + flyUpOffset * 0.15); // Goyangan ke samping melebar
    float sY = (height - 405) - flyUpOffset; // Bergerak naik terus
    
    float sizeW = 15 + (flyUpOffset * 0.3); // Semakin naik semakin membesar
    float sizeH = 12 + (flyUpOffset * 0.2);
    
    float alphaFade = map(flyUpOffset, 0, 180, 220, 0); // Semakin naik semakin transparan/hilang
    
    fill(230, 230, 230, alphaFade);
    ellipse(sX, sY, sizeW, sizeH);
  }
  
  // Semak & Pohon
  fill(45, 80, 50); ellipse(width/2 - 130, height - 150, 50, 40); ellipse(width/2 - 100, height - 145, 60, 35); ellipse(width/2 + 120, height - 148, 55, 40);

  pushMatrix();
  translate(130, height - 150);
  fill(80, 60, 40); rect(-12, -140, 24, 140, 2);
  stroke(70, 50, 30); strokeWeight(3); line(0, -90, -25, -120); line(0, -70, 20, -100); noStroke();
  float lW = sin(envAnimTime) * 3;
  fill(35, 70, 45); ellipse(lW, -155, 135, 100); ellipse(45 + lW, -180, 100, 80); ellipse(-45 + lW, -170, 95, 80);
  fill(50, 95, 60, 240); ellipse(lW - 5, -145, 110, 80); ellipse(35 + lW, -170, 85, 65); ellipse(-35 + lW, -155, 80, 65);
  popMatrix();

  // Garis horizon belakang tanah
  stroke(60, 50, 45); strokeWeight(3); line(0, height - 150, width, height - 150); noStroke();

  // ==========================================================
  // 8. UPDATE AKTOR
  // ==========================================================
  ibu.update(); ibu.displayScene2(); 
  anak.update(); anak.displayScene2(); 
  
  if (frameCount % 10 == 0) debuSapu.add(new PVector(ibu.x + 50 + sin(smokeTime)*30, height - 100));
  for (int i = debuSapu.size()-1; i >= 0; i--) {
    PVector p = debuSapu.get(i); fill(185, 172, 155, 110); ellipse(p.x, p.y, 5, 4); p.y -= 0.3;
    if (debuSapu.size() > 10) debuSapu.remove(0);
  }

  // ==========================================================
  // 9. HUD NARASI
  // ==========================================================
  if (globalTime < 22.0) drawHUDNarasi("Di sebuah desa terpencil hiduplah seorang janda miskin bersama anak perempuan semata wayangnya.");
  else if (globalTime >= 22.0 && globalTime < 33.0) drawHUDNarasi("Sang ibu bekerja keras setiap hari demi memenuhi kebutuhan hidup.");
  else drawHUDNarasi("Namun anaknya tumbuh menjadi gadis yang cantik, tetapi memiliki sifat malas, manja, dan angkuh.");
}
