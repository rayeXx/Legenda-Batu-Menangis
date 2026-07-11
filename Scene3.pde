float cameraX = 0;
ArrayList<PVector> debuJalan = new ArrayList<PVector>();
ArrayList<PVector> daunGugur = new ArrayList<PVector>();

void displayScene3() {
  cameraX += 2.0; // Efek kamera mengikuti langkah kaki
  
  // ==========================================
  // 1. GRADASI LANGIT SIANG ANIME
  // ==========================================
  for (int i = 0; i < height - 100; i++) {
    float inter = map(i, 0, height - 100, 0, 1);
    color cLangit = lerpColor(color(110, 190, 235), color(205, 235, 250), inter);
    stroke(cLangit);
    line(0, i, width, i);
  }
  noStroke();
  
  // ==========================================
  // 2. MATAHARI TINGGI
  // ==========================================
  float sunY = map(constrain(globalTime, 45.0, 75.0), 45.0, 75.0, 180.0, 70.0);
  float sunX = width - 180;
  for (int r = 200; r > 60; r -= 20) {
    fill(255, 245, 200, map(r, 60, 200, 35, 0));
    ellipse(sunX, sunY, r, r);
  }
  fill(255, 250, 220);
  ellipse(sunX, sunY, 60, 60);

  // EFEK SUNBEAMS CINEMATIC (Cahaya matahari menembus celah)
  pushMatrix();
  translate(sunX, sunY);
  fill(255, 245, 210, 10);
  for (int i = 0; i < 6; i++) {
    float angle = radians(110 + i * 25 + sin(globalTime + i) * 3);
    float beamLength = 450;
    beginShape();
    vertex(0, 0);
    vertex(cos(angle - 0.12) * beamLength, sin(angle - 0.12) * beamLength);
    vertex(cos(angle + 0.12) * beamLength, sin(angle + 0.12) * beamLength);
    endShape(CLOSE);
  }
  popMatrix();

  // ==========================================
  // TAMBAHAN: AWAN RAKSASA GRADASI SIANG (Proper Cumulus Anime Style)
  // ==========================================
  pushMatrix();
  float giantCloudScroll = (globalTime * 3.5) % (width + 800);
  translate(giantCloudScroll - 400, 0); // Bergerak ke kanan pelan dan wrap secara berkala
  
  // Shadow (Biru keabu-abuan lembut)
  fill(185, 215, 235, 140);
  ellipse(300, height - 420, 320, 200);
  ellipse(480, height - 390, 380, 230);
  ellipse(150, height - 370, 240, 160);
  
  ellipse(width - 250, height - 400, 340, 210);
  ellipse(width - 430, height - 370, 380, 230);
  
  // Midtone (Putih bersih dengan rona langit)
  fill(225, 240, 252, 175);
  ellipse(290, height - 400, 280, 170);
  ellipse(460, height - 375, 330, 200);
  ellipse(160, height - 360, 200, 135);
  
  ellipse(width - 260, height - 380, 300, 180);
  ellipse(width - 410, height - 355, 330, 200);
  
  // Highlight (Putih cerah di bagian puncak awan)
  fill(255, 255, 255, 220);
  ellipse(280, height - 390, 230, 140);
  ellipse(440, height - 365, 280, 165);
  
  ellipse(width - 270, height - 370, 250, 150);
  ellipse(width - 390, height - 345, 280, 165);
  
  popMatrix();

  // ==========================================
  // 3. AWAN BERGERAK (Meliuk dinamis)
  // ==========================================
  float cloudSpeed = globalTime * 12.0;
  fill(255, 255, 255, 140);
  for (int i = 0; i < 5; i++) {
    float cx = ((i * 380 + cloudSpeed) % (width + 400)) - 200;
    float cy = 90 + sin(globalTime * 0.5 + i) * 15;
    ellipse(cx, cy, 150, 32);
    ellipse(cx + 25, cy - 6, 95, 26);
    ellipse(cx - 30, cy + 6, 75, 22);
  }

  // ==========================================
  // 4. BUKIT/GUNUNG SILUET DI KEJAUHAN (Parallax Lambat)
  // ==========================================
  float hillScroll = cameraX * 0.25;
  fill(80, 132, 125);
  beginShape();
  vertex(0, height - 100);
  for (int x = 0; x <= width + 40; x += 40) {
    float wx = x + hillScroll;
    float y = height - 170 + noise(wx * 0.003) * 55;
    vertex(x, y);
  }
  vertex(width, height - 100);
  endShape(CLOSE);

  // EFEK PARALLAX GUBUG/RUMAH WARGA DESA (Latar belakang jauh)
  float hutScroll = (cameraX * 0.4) % 650;
  for (float hx = -hutScroll + 150; hx < width + 300; hx += 650) {
    // Dinding rumah gubug belakang
    fill(95, 80, 70);
    rect(hx, height - 135, 48, 35, 2);
    // Atap jerami cokelat
    fill(120, 75, 60);
    triangle(hx - 6, height - 135, hx + 24, height - 155, hx + 54, height - 135);
    // Pintu/Jendela kecil
    fill(55, 45, 40);
    rect(hx + 10, height - 120, 8, 20);
    rect(hx + 28, height - 122, 10, 8);
  }

  // ==========================================
  // 5. POHON PARALLAX DI LATAR TENGAH
  // ==========================================
  float treeSpacing = 420;
  float treeScroll = (cameraX * 0.8) % treeSpacing;
  for (float tx = -treeScroll - 100; tx < width + 200; tx += treeSpacing) {
    // Batang pohon
    fill(95, 70, 50);
    rect(tx - 8, height - 230, 16, 130);
    // Cabang
    stroke(80, 55, 35); strokeWeight(2.5);
    line(tx, height - 190, tx - 18, height - 210);
    line(tx, height - 170, tx + 18, height - 190);
    noStroke();
    // Daun pohon (volumetrik bertumpuk)
    fill(45, 95, 60);
    ellipse(tx, height - 230, 110, 80);
    fill(55, 110, 70, 240);
    ellipse(tx - 20, height - 245, 80, 60);
    ellipse(tx + 20, height - 240, 75, 55);
  }

  // ==========================================
  // 6. RUMPUT LATAR BELAKANG JALAN
  // ==========================================
  fill(70, 110, 65);
  rect(0, height - 120, width, 20);

  // BUNGA LIAR WARNA-WARNI DI PINGGIR JALAN (Parallax grass boundary)
  float flowerScroll = cameraX % 140;
  for (float fx = -flowerScroll - 50; fx < width + 150; fx += 140) {
    // Bunga merah
    fill(235, 75, 75); ellipse(fx + 30, height - 107, 7, 7);
    fill(245, 185, 40); ellipse(fx + 30, height - 107, 2, 2);
    // Bunga kuning
    fill(245, 205, 45); ellipse(fx + 85, height - 113, 6, 6);
    fill(255); ellipse(fx + 85, height - 113, 1.8, 1.8);
    // Bunga putih
    fill(245, 245, 250); ellipse(fx + 120, height - 105, 5, 5);
    fill(235, 90, 90); ellipse(fx + 120, height - 105, 1.5, 1.5);
  }

  // ==========================================
  // 7. JALAN DESA TANAH LIAT
  // ==========================================
  fill(150, 118, 90);
  rect(0, height - 100, width, 100);
  
  // Tekstur jalan (garis tipis tanah bergulir)
  stroke(130, 100, 75, 120); strokeWeight(1.5);
  float pathScroll = cameraX % 200;
  for (float px = -pathScroll; px < width + 200; px += 200) {
    line(px, height - 70, px + 90, height - 70);
    line(px + 120, height - 40, px + 170, height - 40);
  }
  noStroke();

  // BEBATUAN & KERIKIL JALAN BERGERAK
  fill(110, 95, 85, 180);
  float rockScroll = cameraX % 300;
  for (float rx = -rockScroll; rx < width + 300; rx += 300) {
    ellipse(rx + 50, height - 60, 14, 6);
    ellipse(rx + 180, height - 85, 8, 4);
    ellipse(rx + 240, height - 35, 16, 7);
  }

  // ==========================================
  // 8. PAGAR BAMBU PARALLAX DEPAN (Scrolling Pagar)
  // ==========================================
  float fenceSpacing = 180;
  float fenceScroll = cameraX % fenceSpacing;
  stroke(105, 85, 70); strokeWeight(3.5);
  for (float fx = -fenceScroll - 50; fx < width + 150; fx += fenceSpacing) {
    // Tiang bambu vertikal
    line(fx, height - 115, fx, height - 60);
    // Papan bambu horizontal ganda
    line(fx, height - 105, fx + fenceSpacing, height - 105);
    line(fx, height - 85, fx + fenceSpacing, height - 85);
  }
  noStroke();

  // ==========================================
  // 9. RUMPUT TEPI JALAN DINAMIS
  // ==========================================
  stroke(65, 115, 75); strokeWeight(2.0);
  float grassScroll = cameraX % 45;
  for (float gx = -grassScroll; gx < width + 50; gx += 45) {
    float wave = sin(globalTime * 3.5 + gx) * 6;
    line(gx, height - 100, gx + wave, height - 116);
    line(gx + 12, height - 100, gx + 12 + wave * 1.3, height - 122);
  }
  noStroke();

  // ==========================================
  // 10. DAUN BERGUGURAN TERTIUP ANGIN
  // ==========================================
  if (frameCount % 15 == 0 && daunGugur.size() < 12) {
    daunGugur.add(new PVector(random(width, width + 150), random(40, height - 160), random(8, 16)));
  }
  
  for (int i = daunGugur.size() - 1; i >= 0; i--) {
    PVector d = daunGugur.get(i);
    d.x -= 3.2; // Tertiup angin kencang ke kiri
    d.y += 1.2; // Melayang turun
    
    pushMatrix();
    translate(d.x, d.y);
    rotate(sin(globalTime * 2.5 + d.x * 0.04) * 0.6); // Bergoyang tertiup angin
    
    // Warna daun bervariasi (hijau segar, hijau tua, atau cokelat gugur)
    if (d.z < 10) fill(95, 145, 70); 
    else if (d.z < 13) fill(65, 110, 50);
    else fill(185, 115, 55); // Daun kering cokelat/oranye
    
    ellipse(0, 0, d.z, d.z * 0.45);
    stroke(55, 90, 40, 100); strokeWeight(1);
    line(-d.z * 0.45, 0, d.z * 0.45, 0);
    noStroke();
    popMatrix();
    
    if (d.x < -50 || d.y > height - 90) {
      daunGugur.remove(i);
    }
  }

  // ==========================================
  // 11. BURUNG MELINTAS
  // ==========================================
  float birdTimeScene3 = (globalTime * 0.04) % 1.0;
  float wingWaveScene3 = sin(frameCount * 0.22) * 5.5;
  stroke(50, 55, 70); strokeWeight(2.0); noFill();
  for (int i = 0; i < 3; i++) {
    float bx = bezierPoint(-100, 350, 800, width + 150, birdTimeScene3) - (i * 35);
    float by = bezierPoint(140, 85, 60, 130, birdTimeScene3) + (i * 18);
    
    if (bx > -20 && bx < width + 20) {
      beginShape();
      vertex(bx - 10, by + wingWaveScene3);
      bezierVertex(bx - 4, by - 2, bx, by, bx, by);
      bezierVertex(bx, by, bx + 4, by - 2, bx + 10, by + wingWaveScene3);
      endShape();
    }
  }
  noStroke();

  // ==========================================
  // 12. SPELLED DEBU DARI KAKI
  // ==========================================
  if (frameCount % 6 == 0) {
    debuJalan.add(new PVector(anak.x + random(-12, 12), height - 90, random(10, 22)));
    debuJalan.add(new PVector(ibu.x + random(-12, 12), height - 90, random(10, 22)));
  }
  
  for (int i = debuJalan.size() - 1; i >= 0; i--) {
    PVector p = debuJalan.get(i);
    p.x -= 2.6; 
    p.y -= 0.45; 
    p.z -= 0.65; 
    
    float alphaVal = map(p.z, 0, 22, 0, 130);
    float sizeVal = map(p.z, 0, 22, 16, 5); 
    
    fill(195, 180, 160, alphaVal);
    ellipse(p.x, p.y, sizeVal, sizeVal * 0.75);
    
    if (p.z <= 0) {
      debuJalan.remove(i);
    }
  }

  // ==========================================
  // 13. UPDATE & DISPLAY AKTOR
  // ==========================================
  anak.x = width/2 + 120; // Anak berjalan di depan
  anak.y = height - 110;
  anak.update();
  anak.displayWalking(cameraX); 
  
  ibu.x = width/2 - 240; // Ibu jauh di belakang
  ibu.y = height - 110;
  ibu.update();
  ibu.displayWalking(cameraX);

  // ==========================================
  // 13.5 HEWAN DI PINGGIR JALAN (Ayam & Sapi Parallax - Di Atas Karakter)
  // ==========================================
  // Pasang Ayam 1 & 2 (Hadap-hadapan mematuk)
  drawChicken(850 - cameraX, height - 85, true);
  drawChicken(910 - cameraX, height - 85, false);
  
  // Sapi 1
  drawCow(1800 - cameraX, height - 110, false);
  
  // Sapi 2
  drawCow(2800 - cameraX, height - 110, true);
  
  // Pasang Ayam 3 & 4
  drawChicken(3400 - cameraX, height - 85, false);
  drawChicken(3460 - cameraX, height - 85, true);

  // ==========================================
  // 14. HUD NARASI BERTAHAP
  // ==========================================
  if (globalTime < 55.0) {
    drawHUDNarasi("Suatu hari mereka berjalan menuju pasar.");
  } else if (globalTime >= 55.0 && globalTime < 65.0) {
    drawHUDNarasi("Sang anak mengenakan pakaian terbaiknya dan berjalan di depan.");
  } else {
    drawHUDNarasi("Sementara ibunya berjalan jauh di belakang sambil membawa keranjang yang berat.");
  }
}

void drawChicken(float x, float y, boolean facingRight) {
  pushMatrix();
  translate(x, y);
  if (!facingRight) {
    scale(-1, 1); // Flip secara horizontal
  }
  
  // Kaki (Kuning/Oranye)
  stroke(235, 170, 40); strokeWeight(1.5);
  line(-3, 6, -3, 13);
  line(3, 6, 3, 13);
  // Cakar kaki
  line(-3, 13, -6, 14);
  line(3, 13, 0, 14);
  noStroke();
  
  // Ekor ayam (bulu hitam melengkung)
  fill(55, 45, 40);
  triangle(-8, -2, -16, -10, -5, -6);
  
  // Badan (Putih)
  fill(235, 230, 225);
  ellipse(0, 0, 22, 16);
  
  // Sayap (Muted Grey)
  fill(210, 200, 190);
  ellipse(-2, 1, 12, 8);
  
  // Leher & Kepala (Mematuk dinamis)
  float peckRot = 0;
  if (sin(globalTime * 6.0 + x * 0.1) > 0.4) {
    peckRot = radians(25);
  }
  
  pushMatrix();
  translate(6, -6);
  rotate(peckRot);
  
  // Leher
  fill(235, 230, 225);
  rectMode(CENTER);
  pushMatrix(); translate(-2, 2); rotate(radians(-45)); rect(0, 0, 6, 8); popMatrix();
  // Kepala
  ellipse(2, -4, 10, 10);
  
  // Jengger (Merah)
  fill(225, 55, 55);
  ellipse(2, -10, 4, 6);
  ellipse(4, -9, 3, 4);
  
  // Paruh (Kuning)
  fill(245, 185, 40);
  triangle(6, -5, 11, -4, 6, -3);
  
  // Mata
  fill(30);
  ellipse(2, -5, 1.8, 1.8);
  
  popMatrix();
  
  popMatrix();
}

void drawCow(float x, float y, boolean facingRight) {
  pushMatrix();
  translate(x, y);
  if (!facingRight) {
    scale(-1, 1);
  }
  
  // Kaki belakang & depan (Cokelat/Abu-abu dengan kuku hitam)
  fill(200, 195, 190);
  rectMode(CORNER);
  rect(-28, 10, 10, 32, 2); // Kaki belakang kiri
  rect(-14, 10, 10, 32, 2); // Kaki belakang kanan
  rect(14, 10, 10, 32, 2);  // Kaki depan kiri
  rect(26, 10, 10, 32, 2);  // Kaki depan kanan
  
  // Kuku kaki (Hitam)
  fill(50);
  rect(-28, 38, 10, 4, 1);
  rect(-14, 38, 10, 4, 1);
  rect(14, 38, 10, 4, 1);
  rect(26, 38, 10, 4, 1);
  
  // Ekor bergoyang pelan
  float tailSwing = sin(globalTime * 2.0 + x * 0.05) * radians(15);
  pushMatrix();
  translate(-35, -15);
  rotate(tailSwing);
  stroke(100, 95, 90); strokeWeight(3);
  line(0, 0, -7, 25);
  noStroke();
  fill(50);
  ellipse(-7, 27, 6, 10);
  popMatrix();
  
  // Badan (Putih dengan bercak hitam khas sapi perah)
  fill(245, 245, 245);
  rectMode(CENTER);
  rect(0, -10, 75, 46, 6);
  
  // Bercak Hitam Prosedural
  fill(40);
  ellipse(-20, -18, 22, 12);
  ellipse(5, -6, 25, 18);
  ellipse(-12, 0, 14, 14);
  ellipse(22, -18, 16, 10);
  
  // Kepala & Moncong
  pushMatrix();
  translate(38, -25);
  // Leher
  rotate(radians(-20));
  fill(245, 245, 245);
  rect(0, 10, 16, 25, 2);
  fill(40); // Bercak hitam di leher
  ellipse(0, 12, 12, 10);
  
  // Kepala
  fill(245, 245, 245);
  rect(8, -10, 22, 24, 4);
  fill(40); // Bercak hitam di kepala
  rect(8, -16, 22, 10, 2);
  
  // Moncong Pink/Cream
  fill(245, 200, 200);
  rect(16, -4, 12, 12, 3);
  fill(90, 60, 60);
  ellipse(16, -6, 2, 2); // Lubang hidung
  ellipse(16, -2, 2, 2);
  
  // Tanduk kecil (Putih/Kuning tua)
  fill(225, 220, 200);
  triangle(4, -22, -2, -28, 2, -22);
  
  // Telinga (Putih)
  fill(245, 245, 245);
  ellipse(0, -12, 12, 5);
  
  // Mata bulat polos
  fill(30);
  ellipse(10, -12, 4, 4);
  popMatrix();
  
  popMatrix();
}
