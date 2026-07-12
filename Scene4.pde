// Variabel Global Scene 4, 5, 6, & 7
ArrayList<NPCAnakKecil> npcsAnak = new ArrayList<NPCAnakKecil>();
ArrayList<NPCWarga> npcsWarga = new ArrayList<NPCWarga>();
NPCPedagang pedagang1, pedagang2;
ArrayList<PVector> daunGugur5 = new ArrayList<PVector>();

boolean scene4SetupDone = false;
boolean npcFrozen = false;
float zoomProgress = 0;

// Credits array — dideklarasi GLOBAL agar tidak dialokasikan ulang tiap frame
String[][] credits = {
  {"PRODUCER",           "Nama Anda / Teman 1"},
  {"DIRECTOR",           "Nama Teman 2"},
  {"SCREENPLAY WRITER",  "Nama Teman 3"},
  {"LEAD ANIMATOR",      "Nama Teman 4"},
  {"CHARACTER DESIGNER", "Nama Teman 5"},
  {"BACKGROUND ARTIST",  "Nama Teman 6"},
  {"VFX SUPERVISOR",     "Nama Teman 7"},
  {"SOUND DESIGNER",     "Nama Teman 8"},
  {"PRODUCTION MANAGER", "Nama Teman 9"},
  {"EXECUTIVE PRODUCER", "Nama Teman 10"}
};

void setupScene4() {
  if (scene4SetupDone) return;
  
  // Spawn static sellers at their stalls
  pedagang1 = new NPCPedagang(250, height - 150);
  pedagang2 = new NPCPedagang(950, height - 150);
  
  // Spawn random walking citizens
  npcsWarga.add(new NPCWarga(200, height - 150));
  npcsWarga.add(new NPCWarga(800, height - 150));
  npcsWarga.add(new NPCWarga(1100, height - 150));
  
  // Spawn running children
  npcsAnak.add(new NPCAnakKecil(350, height - 150));
  npcsAnak.add(new NPCAnakKecil(900, height - 150));
  
  // Initialize swirling leaves for Scene 5/6
  daunGugur5.clear();
  for (int i = 0; i < 25; i++) {
    daunGugur5.add(new PVector(random(width), random(height - 300), random(TWO_PI)));
  }
  
  scene4SetupDone = true;
}

void displayScene4() {
  // Pastikan setup dipanggil sekali
  setupScene4();
  
  // OPTIMASI: Saat credits fullscreen (189.5s+), skip semua rendering scene berat
  // dan langsung render credits saja agar tidak lag
  if (globalTime >= 189.5) {
    fill(0);
    rectMode(CORNER);
    rect(0, 0, width, height);
    
    float scrollSpeed = 60.0;
    float scrollY = (height + 50) - (globalTime - 189.5) * scrollSpeed;
    float currentY = scrollY;
    
    textAlign(CENTER, TOP);
    textSize(28);
    fill(255, 215, 100);
    text("LEGENDA BATU MENANGIS", width/2, currentY);
    currentY += 95;
    
    for (int i = 0; i < credits.length; i++) {
      textSize(15);
      fill(200);
      text(credits[i][0], width/2, currentY);
      textSize(19);
      fill(255);
      text(credits[i][1], width/2, currentY + 23);
      currentY += 78;
    }
    currentY += 40;
    
    if (currentY < height/2) {
      float finalAlpha = map(height/2 - currentY, 0, 100, 0, 255);
      finalAlpha = constrain(finalAlpha, 0, 255);
      fill(255, 215, 100, finalAlpha);
      textSize(36);
      textAlign(CENTER, CENTER);
      text("SELESAI", width/2, height/2 - 40);
      fill(200, finalAlpha);
      textSize(18);
      text("Terima Kasih Telah Menonton", width/2, height/2 + 20);
    }
    return;  // ← Keluar lebih awal, skip semua rendering scene 4 di bawah
  }
  
  // Update timeline states
  npcFrozen = (globalTime >= 85.0);
  
  // Multi-zoom camera logic based on active speaker and Scene 5/6/7 panning
  float zoomScale = 1.0;
  float centerX = width/2;
  float centerY = height/2;
  zoomProgress = 0;
  
  // Camera shake offset (Scene 6 lightning strikes)
  float shakeX = 0;
  float shakeY = 0;
  if (globalTime >= 135.0 && globalTime < 165.0) {
    if (random(1) < 0.28 && (frameCount % 6 < 3)) {
      shakeX = random(-8, 8);
      shakeY = random(-8, 8);
    }
  }
  
  if (globalTime >= 79.5 && globalTime < 84.0) {
    // Zoom-in to pedagang2 (speaking)
    float t = map(globalTime, 79.5, 80.3, 0.0, 1.0);
    t = constrain(t, 0.0, 1.0);
    zoomScale = lerp(1.0, 1.7, t);
    centerX = lerp(width/2, pedagang2.x, t);
    centerY = lerp(height/2, height - 145, t);
  } else if (globalTime >= 84.0 && globalTime < 84.5) {
    // Zoom-out transition back to center
    float t = map(globalTime, 84.0, 84.5, 1.0, 0.0);
    t = constrain(t, 0.0, 1.0);
    zoomScale = lerp(1.0, 1.7, t);
    centerX = lerp(width/2, pedagang2.x, t);
    centerY = lerp(height/2, height - 145, t);
  } else if (globalTime >= 84.5 && globalTime < 88.0) {
    // Zoom-in to Anak (speaking)
    float t = map(globalTime, 84.5, 85.3, 0.0, 1.0);
    t = constrain(t, 0.0, 1.0);
    zoomScale = lerp(1.0, 1.9, t);
    centerX = lerp(width/2, anak.x, t);
    centerY = lerp(height/2, height - 145, t);
    zoomProgress = t; // Drives red kebaya color transition
  } else if (globalTime >= 88.0 && globalTime < 90.0) {
    // Zoom-out transition back to normal
    float t = map(globalTime, 88.0, 90.0, 1.0, 0.0);
    t = constrain(t, 0.0, 1.0);
    zoomScale = lerp(1.0, 1.9, t);
    centerX = lerp(width/2, anak.x, t);
    centerY = lerp(height/2, height - 145, t);
    zoomProgress = t;
  } else if (globalTime >= 105.0 && globalTime < 135.0) {
    // SCENE 5: Camera slowly pans and zooms on the weeping mother
    float t = map(globalTime, 105.0, 108.0, 0.0, 1.0);
    t = constrain(t, 0.0, 1.0);
    zoomScale = lerp(1.0, 2.1, t);
    centerX = lerp(width/2, ibu.x, t);
    centerY = lerp(height/2, ibu.y - 120, t);
  } else if (globalTime >= 135.0 && globalTime < 165.0) {
    // SCENE 6: Camera focuses on both (slightly pulled back but keeping zoom on Mother/Anak space)
    zoomScale = 1.6;
    centerX = (ibu.x + anak.x) / 2.0;
    centerY = height - 200;
  } else if (globalTime >= 165.0) {
    // SCENE 7: Camera slowly pans out back to normal overview
    float t = map(globalTime, 165.0, 169.0, 1.0, 0.0);
    t = constrain(t, 0.0, 1.0);
    zoomScale = lerp(1.0, 1.6, t);
    centerX = lerp(width/2, (ibu.x + anak.x) / 2.0, t);
    centerY = lerp(height/2, height - 200, t);
  }
  
  // Calculate storm background progress (Scene 5 & 6)
  float stormProgress = 0.0;
  if (globalTime >= 105.0 && globalTime < 112.0) {
    stormProgress = map(globalTime, 105.0, 112.0, 0.0, 1.0);
  } else if (globalTime >= 112.0 && globalTime < 165.0) {
    stormProgress = 1.0;
  } else if (globalTime >= 165.0 && globalTime < 169.0) {
    // Scene 7 storm clears away
    stormProgress = map(globalTime, 165.0, 169.0, 1.0, 0.0);
  }
  stormProgress = constrain(stormProgress, 0.0, 1.0);
  
  pushMatrix();
  translate(width/2 + shakeX, height/2 + shakeY); // Apply zoom and shake matrix
  scale(zoomScale);
  translate(-centerX, -centerY);
  
  // ==========================================
  // 1. SKY GRADASI PAGI / BADAI SIANG
  // ==========================================
  for (int i = 0; i < height - 150; i++) {
    float inter = map(i, 0, height - 150, 0, 1);
    color cLangitPagi = lerpColor(color(135, 205, 235), color(220, 240, 255), inter);
    color cLangitBadai = lerpColor(color(25, 25, 35), color(10, 10, 15), inter); // Darker black sky in Scene 6
    color cLangit = lerpColor(cLangitPagi, cLangitBadai, stormProgress);
    stroke(cLangit);
    line(0, i, width, i);
  }
  noStroke();
  
  // Awan Raksasa Latar Belakang (Gets darker based on stormProgress)
  pushMatrix();
  float giantCloudScroll = (globalTime * 3.5) % (width + 800);
  translate(giantCloudScroll - 400, 0);
  
  color cCloud1 = lerpColor(color(185, 215, 235, 140), color(50, 50, 60, 140), stormProgress);
  color cCloud2 = lerpColor(color(225, 240, 252, 175), color(65, 65, 75, 175), stormProgress);
  color cCloud3 = lerpColor(color(255, 255, 255, 220), color(80, 80, 95, 220), stormProgress);
  
  fill(cCloud1);
  ellipse(300, height - 420, 320, 200);
  ellipse(480, height - 390, 380, 230);
  ellipse(150, height - 370, 240, 160);
  ellipse(width - 250, height - 400, 340, 210);
  ellipse(width - 430, height - 370, 380, 230);
  fill(cCloud2);
  ellipse(290, height - 400, 280, 170);
  ellipse(460, height - 375, 330, 200);
  ellipse(160, height - 360, 200, 135);
  ellipse(width - 260, height - 380, 300, 180);
  ellipse(width - 410, height - 355, 330, 200);
  fill(cCloud3);
  ellipse(280, height - 390, 230, 140);
  ellipse(440, height - 365, 280, 165);
  ellipse(width - 270, height - 370, 250, 150);
  ellipse(width - 390, height - 345, 280, 165);
  popMatrix();
  
  // Gunung jauh siluet
  color cGunung = lerpColor(color(90, 130, 120), color(20, 30, 28), stormProgress);
  fill(cGunung);
  beginShape();
  vertex(-150, height);
  bezierVertex(100, height-280, 250, height-380, 350, height-360); 
  bezierVertex(450, height-340, 600, height-200, 850, height);
  endShape(CLOSE);
  
  // BUKIT & POHON JAUH
  drawHillDetails();
  
  // ==========================================
  // LAYER 1 DI BELAKANG KIOS: PEDAGANG
  // ==========================================
  pedagang1.display();
  pedagang2.display();
  
  // ==========================================
  // 2. KIOS PASAR (Meja & Atap menutupi pedagang)
  // ==========================================
  drawMarketStalls();
  
  // ==========================================
  // 3. HORIZON & DIRT ROAD
  // ==========================================
  color cLine = lerpColor(color(60, 50, 45), color(12, 8, 5), stormProgress);
  stroke(cLine); strokeWeight(3);
  line(0, height - 150, width, height - 150);
  noStroke();
  
  // Jalan Tanah
  for (int i = height - 150; i <= height; i++) {
    float inter = map(i, height - 150, height, 0, 1);
    color cTanahPagi = lerpColor(color(180, 160, 130), color(140, 120, 100), inter);
    color cTanahBadai = lerpColor(color(60, 55, 45), color(40, 35, 30), inter);
    color cTanah = lerpColor(cTanahPagi, cTanahBadai, stormProgress);
    stroke(cTanah);
    line(0, i, width, i);
  }
  noStroke();
  
  // Ornamen batu kerikil
  randomSeed(9876);
  fill(100, 90, 85, map(stormProgress, 0, 1, 180, 50));
  for (int i = 0; i < 15; i++) {
    ellipse(random(width), random(height - 140, height), random(10, 20), random(5, 10));
  }

  // KUBANGAN LUMPUR
  drawMudPatches();
  
  // BACKGROUND STORM OVERLAY (Darkens environment behind characters)
  if (stormProgress > 0) {
    rectMode(CORNER);
    fill(8, 8, 18, stormProgress * 155); // Darkens background up to 60%
    rect(-100, -100, width + 200, height + 200);
  }

  // ==========================================
  // 4. UPDATE & RENDER WALKING NPCs
  // ==========================================
  for (NPCAnakKecil npc : npcsAnak) {
    npc.isMoving = !npcFrozen && (globalTime < 105.0); 
    npc.update();
    npc.display();
  }
  for (NPCWarga npc : npcsWarga) {
    npc.isMoving = !npcFrozen && (globalTime < 105.0);
    npc.update();
    npc.display();
  }
  
  // Pedagang 2 speaks during Dialogue 1
  pedagang2.isSpeaking = (globalTime >= 79.5 && globalTime < 84.5);

  // ==========================================
  // 5. UPDATE & DRAW AKTOR UTAMA (Ibu & Anak)
  // ==========================================
  float walkDist = globalTime * 50.0;
  
  if (globalTime < 78.0) {
    // Walk from Left to Right into the center
    anak.x = lerp(120, width/2 + 20, map(globalTime, 75.0, 78.0, 0, 1));
    anak.y = height - 110;
    anak.update();
    anak.displayWalking(walkDist);
    
    ibu.x = lerp(-120, width/2 - 180, map(globalTime, 75.0, 78.0, 0, 1));
    ibu.y = height - 110;
    ibu.update();
    ibu.displayWalking(walkDist);
  } else {
    // Stand in place
    anak.x = width/2 + 20;
    anak.y = height - 110;
    anak.update();
    
    ibu.x = width/2 - 180;
    ibu.y = height - 110;
    ibu.update();
    
    if (globalTime < 105.0) {
      // Scene 4 - Stand and Point
      ibu.displayWalking(0); 
      if (globalTime < 83.5) {
        anak.displayScene2(); 
      } else {
        displayAnakAngryPointing();
      }
    } else if (globalTime >= 105.0 && globalTime < 135.0) {
      // SCENE 5: Mother Prays, Daughter looks back in shock
      float prayProgress = map(globalTime, 105.0, 110.0, 0.0, 1.0);
      prayProgress = constrain(prayProgress, 0.0, 1.0);
      
      ibu.displayPraying(prayProgress);
      anak.displayScene2(); 
    } else {
      // SCENE 6 & 7: The Curse takes effect, Daughter turns into stone
      ibu.displayPraying(1.0); // Mother keeps weeping/praying
      
      float stoneProgress = map(globalTime, 135.0, 155.0, 0.0, 1.0);
      stoneProgress = constrain(stoneProgress, 0.0, 1.0);
      anak.displayStoning(stoneProgress);
      
      // Draw fallen gold mirror on the ground
      pushMatrix();
      translate(anak.x - 30, height - 110);
      rotate(radians(65));
      fill(140, 110, 30); rect(-1.5, 0, 3, 12, 1);
      stroke(140, 110, 30); strokeWeight(1.8); ellipse(0, 18, 18, 22); noStroke();
      fill(170, 200, 210); ellipse(0, 18, 14, 18);
      popMatrix();
    }
  }
  
  // HEWAN DI PASAR (Sapi & Ayam)
  drawChicken(430, height - 80, true);
  drawChicken(470, height - 80, false);
  drawChicken(1050, height - 80, false);
  drawCow(120, height - 110, true);
  drawCow(780, height - 110, false);

  // LIGHTING AND CHARACTERS STORM OVERLAY
  if (stormProgress > 0) {
    rectMode(CORNER);
    fill(4, 4, 12, stormProgress * 65); 
    rect(-100, -100, width + 200, height + 200);
  }

  // ==========================================
  // EFEK BADAI DAUN & KABUT BERPUTAR (Scene 5 & 6)
  // ==========================================
  if (stormProgress > 0) {
    // 1. Drifting Ground Fog
    fill(210, 210, 220, stormProgress * 42);
    rectMode(CORNER);
    for (int i = 0; i < 4; i++) {
      float fx = ((frameCount * (1.2 + i * 0.4) + i * 300) % (width + 600)) - 300;
      float fy = height - 180 + i * 15 + sin(frameCount * 0.02 + i) * 12;
      ellipse(fx, fy, 400 + i * 80, 50 + i * 12);
    }
    
    // 2. Swirling Leaves (Angin Kencang)
    if (stormProgress > 0.2) {
      fill(110, 100, 40, stormProgress * 220); // Greenish brown leaves
      for (PVector leaf : daunGugur5) {
        leaf.x -= 9.5 + stormProgress * 6.0;
        leaf.y += sin(frameCount * 0.08 + leaf.x * 0.01) * 3.5 + 1.2;
        
        if (leaf.x < -50) {
          leaf.x = width + 50;
          leaf.y = random(height - 300);
        }
        
        pushMatrix();
        translate(leaf.x, leaf.y);
        rotate(leaf.z + frameCount * 0.12);
        beginShape();
        vertex(0, -6);
        bezierVertex(6, -6, 8, 0, 0, 8);
        bezierVertex(-8, 0, -6, -6, 0, -6);
        endShape(CLOSE);
        popMatrix();
      }
    }
  }

  // ==========================================
  // SCENE 6 EFEK RAIN PARTICLES (Detik 135.0 - 165.0)
  // ==========================================
  if (globalTime >= 135.0 && globalTime < 165.0) {
    stroke(170, 195, 235, 110);
    strokeWeight(1.4);
    randomSeed(4321);
    for (int i = 0; i < 85; i++) {
      float rx = random(width + 200) - 100;
      float ry = (random(height) + frameCount * 13) % height;
      line(rx, ry, rx - 6, ry + 18);
    }
    noStroke();
  }


  // ==========================================
  // 6. DIALOG SPEECH BUBBLES
  // ==========================================
  if (globalTime >= 79.5 && globalTime < 84.5) {
    drawSpeechBubble(pedagang2.x, pedagang2.y, "Hai Nona, siapakah wanita tua itu?", true);
  } else if (globalTime >= 84.5 && globalTime < 88.0) {
    drawSpeechBubble(anak.x, anak.y, "Dia hanya pembantuku!", false);
  }

  popMatrix(); // End camera zoom/shake matrix

  // ==========================================
  // SCENE 5 & 6 EFEK LIGHTNING & WHITE FLASH
  // ==========================================
  if (globalTime >= 135.0 && globalTime < 135.4) {
    // Giant white-out flash at the start of Scene 6
    float flashAlpha = map(globalTime, 135.0, 135.4, 255, 0);
    rectMode(CORNER);
    fill(255, flashAlpha);
    rect(0, 0, width, height);
  } else if (globalTime >= 110.0 && globalTime < 165.0) {
    // Distant lightning strike flashes
    if (random(1) < 0.015 && (frameCount % 6 < 2)) {
      rectMode(CORNER);
      fill(245, 240, 255, 210); 
      rect(0, 0, width, height);
    }
  }

  // ==========================================
  // SCENE 7: BURUNG TERBANG KEMBALI (Detik 165.0+)
  // ==========================================
  if (globalTime >= 165.0 && globalTime < 178.0) {
    float birdTime = (globalTime - 165.0) * 110.0;
    for (int b = 0; b < 3; b++) {
      float bx = -100 + birdTime + b * 45;
      float by = 160 + b * 22 + sin(frameCount * 0.08 + b) * 8;
      if (bx < width + 100) {
        fill(45); noStroke();
        float wingFlap = sin(frameCount * 0.16 + b) * 8.0;
        beginShape();
        vertex(bx, by);
        bezierVertex(bx + 8, by - 12 - wingFlap, bx + 16, by - 8, bx + 24, by);
        bezierVertex(bx + 16, by + 4, bx + 8, by + 4, bx, by);
        endShape(CLOSE);
      }
    }
  }  // ==========================================
  // HUD NARASI BERTAHAP (Scene 4, 5 & 6)
  // ==========================================
  if (globalTime >= 157.0 && globalTime < 165.0) {
    drawHUDNarasi("Batu itu terus mengeluarkan air mata penyesalan.");
  } else if (globalTime >= 147.0 && globalTime < 157.0) {
    drawHUDNarasi("Sedikit demi sedikit seluruh tubuhnya berubah menjadi batu.");
  } else if (globalTime >= 137.0 && globalTime < 147.0) {
    drawHUDNarasi("Seketika langit menjadi gelap. Tubuh sang anak perlahan mengeras.");
  } else if (globalTime >= 114.0 && globalTime < 135.0) {
    drawHUDNarasi("Hati sang ibu hancur. Dengan penuh kesedihan ia berdoa kepada Tuhan agar memberikan hukuman yang setimpal kepada anaknya.");
  } else if (globalTime >= 88.0 && globalTime < 101.0) {
    drawHUDNarasi("Dengan penuh kesombongan sang anak mengaku bahwa wanita tua itu hanyalah pembantunya.");
  }
}

void drawHillDetails() {
  // Siluet pohon-pohon di lereng gunung
  drawRidgeTree(60, height - 280, 20);
  drawRidgeTree(120, height - 310, 22);
  drawRidgeTree(180, height - 340, 25);
  drawRidgeTree(240, height - 360, 24);
  drawRidgeTree(300, height - 365, 20);
  drawRidgeTree(360, height - 355, 18);
  drawRidgeTree(420, height - 340, 16);
  drawRidgeTree(500, height - 300, 18);
  
  // Siluet gubug di bukit
  pushMatrix();
  translate(260, height - 368);
  fill(75, 110, 100);
  rect(0, 0, 16, 12, 1);
  triangle(-2, 0, 18, 0, 8, -8);
  stroke(75, 110, 100); strokeWeight(1.5);
  line(3, 12, 3, 16);
  line(13, 12, 13, 16);
  noStroke();
  popMatrix();
}

void drawRidgeTree(float x, float y, float h) {
  pushMatrix();
  translate(x, y);
  fill(75, 110, 100);
  triangle(0, 0, -h * 0.4, h, h * 0.4, h);
  triangle(0, -h * 0.4, -h * 0.33, h * 0.4, h * 0.33, h * 0.4);
  rect(-h * 0.1, h, h * 0.2, h * 0.4);
  popMatrix();
}

void drawMudPatches() {
  fill(110, 80, 55, 180);
  noStroke();
  ellipse(400, height - 70, 90, 24);
  ellipse(720, height - 50, 110, 28);
  // Air lumpur berkilau
  fill(130, 95, 65, 200);
  ellipse(395, height - 72, 70, 16);
  ellipse(725, height - 52, 90, 18);
}

void drawMarketStalls() {
  rectMode(CORNER); // FIXED: Prevent stalls from being broken by global rectMode(CENTER) state
  
  // Stall 1: Makanan (Kiri)
  pushMatrix();
  translate(250, height - 150);
  
  // Tiang kayu (Dinaikkan agar tidak menghalangi muka pedagang)
  fill(90, 70, 50);
  rect(-80, -135, 8, 135);
  rect(80, -135, 8, 135);
  
  // Meja dagangan
  fill(110, 85, 60);
  rect(-90, -35, 180, 35, 2);
  
  // Pot makanan mengepul
  fill(150);
  ellipse(0, -42, 40, 16);
  rect(-20, -52, 40, 10);
  
  // Asap makanan mengepul
  fill(235, 235, 235, 80);
  for (int i = 0; i < 3; i++) {
    float sy = -56 - ((frameCount * 0.8 + i * 20) % 50);
    float sx = sin(frameCount * 0.05 + i) * 6;
    ellipse(sx, sy, 12 + (sy*-0.1), 8 + (sy*-0.05));
  }
  
  // Atap Kios Merah Putih (Fluttering canopy) - Dinaikkan Y nya
  float flutter = sin(globalTime * 3.5) * 5;
  fill(200, 50, 50);
  beginShape();
  vertex(-95, -135);
  vertex(95, -135);
  vertex(105, -160 + flutter);
  vertex(-105, -160 + flutter);
  endShape(CLOSE);
  
  popMatrix();
  
  // Stall 2: Kain (Kios Tengah-Kanan)
  pushMatrix();
  translate(550, height - 150);
  // Tiang (Dinaikkan agar tidak menghalangi muka pedagang)
  fill(90, 70, 50);
  rect(-70, -135, 6, 135);
  rect(70, -135, 6, 135);
  line(-70, -135, 70, -135);
  
  // Kain bergantungan berkibar (Disesuaikan mulai dari tiang atas)
  float clothSway = sin(globalTime * 3.0) * 4;
  fill(50, 120, 200, 230); // Kain biru
  rect(-60, -130, 30, 75 + clothSway, 2);
  fill(210, 180, 50, 230); // Kain kuning
  rect(-20, -130, 35, 65 - clothSway, 2);
  fill(180, 60, 150, 230); // Kain ungu
  rect(25, -130, 30, 80 + clothSway, 2);
  
  // Atap kanopi biru
  fill(50, 90, 150);
  rect(-85, -155, 170, 20, 3);
  popMatrix();

  // Stall 3: Buah (Kanan)
  pushMatrix();
  translate(950, height - 150);
  // Tiang (Dinaikkan agar tidak menghalangi muka pedagang)
  fill(90, 70, 50);
  rect(-70, -135, 8, 135);
  rect(70, -135, 8, 135);
  fill(100, 75, 50);
  rect(-80, -30, 160, 30, 2);
  
  // Buah-buahan
  fill(220, 50, 50); ellipse(-40, -36, 12, 12); ellipse(-45, -34, 10, 10); // Apel
  fill(240, 210, 40); ellipse(0, -35, 14, 10); ellipse(10, -36, 12, 10); // Jeruk/Pisang
  fill(50, 180, 50); ellipse(40, -36, 12, 12); // Apel Hijau
  
  // Atap kanopi hijau berkibar - Dinaikkan Y nya
  float flutterG = cos(globalTime * 3.0) * 4;
  fill(50, 150, 80);
  beginShape();
  vertex(-85, -135);
  vertex(85, -135);
  vertex(95, -155 + flutterG);
  vertex(-95, -155 + flutterG);
  endShape(CLOSE);
  popMatrix();
}

void displayAnakAngryPointing() {
  float bodyBob = 0;
  color bodyColor = anak.cKebaya;
  if (zoomProgress > 0) {
    bodyColor = lerpColor(anak.cKebaya, color(205, 50, 70), zoomProgress);
  }
  
  pushMatrix();
  translate(anak.x, anak.y - bodyBob);

  // 1. TANGAN KANAN (Rileks di sebelah kanan)
  pushMatrix(); 
  translate(14, -85); 
  rotate(radians(15)); 
  fill(bodyColor); rectMode(CORNER); 
  rect(-7, 0, 14, 40, 5); 
  fill(anak.cGold); rect(-8, 32, 16, 3, 1); 
  fill(anak.cSkin); rect(-5, 40, 10, 10, 2); 
  popMatrix();

  // 2. RAMBUT BELAKANG
  fill(20, 18, 18); rectMode(CENTER); rect(0, -85, 42, 55, 15, 15, 5, 5); triangle(-21, -65, 21, -65, 0, -35);

  // 3. KAKI KIRI & KAKI KANAN (Berdiri Diam)
  pushMatrix(); 
  translate(-8, -45); 
  fill(anak.cKain); rectMode(CORNER); rect(-7, 0, 14, 38, 3); 
  fill(anak.cSkin); rect(-5, 38, 10, 22, 2); 
  fill(anak.cGold); rect(-7, 56, 14, 6, 3); 
  popMatrix();

  pushMatrix(); 
  translate(8, -45); 
  fill(anak.cKain); rectMode(CORNER); rect(-7, 0, 14, 38, 3); 
  fill(anak.cSkin); rect(-5, 38, 10, 22, 2); 
  fill(anak.cGold); rect(-7, 56, 14, 6, 3); 
  popMatrix();

  // 4. SELENDANG
  fill(240, 210, 60, 220); 
  beginShape(); 
  vertex(-14, -85); 
  bezierVertex(-30, -60, -25, -20, -30, 20); 
  vertex(-22, 20); 
  bezierVertex(-18, -20, -22, -60, -10, -75); 
  endShape(CLOSE);

  // 5. BADAN (Lerp warna ke merah saat marah)
  fill(bodyColor); rectMode(CENTER); rect(0, -68, 36, 46, 10); 
  fill(anak.cGold); rect(-16, -68, 3, 40); rect(16, -68, 3, 40); fill(250, 230, 180); rect(0, -80, 12, 14, 2); fill(anak.cGold); ellipse(0, -82, 6, 6); ellipse(0, -76, 6, 6);

  // 6. ROK (DI ATAS KAKI)
  fill(anak.cKain); 
  beginShape(); vertex(-18, -44); vertex(18, -44); vertex(23, -10); vertex(-23, -10); endShape(CLOSE);
  stroke(anak.cGold, 180); strokeWeight(1.8); 
  line(-15, -44, -19, -10); line(-8, -44, -10, -10); line(0, -44, 0, -10); line(8, -44, 10, -10); line(15, -44, 19, -10);   
  noStroke();

  // 7. WAJAH SIMPEL MARAH
  pushMatrix();
  translate(0, -102); 
  fill(anak.cGold); rectMode(CENTER); rect(0, 13, 10, 10, 3); 
  fill(anak.cSkin); noStroke(); ellipse(0, 0, 42, 44); 
  fill(245, 140, 140, 90); ellipse(-10, 7, 7, 4); ellipse(14, 7, 7, 4); 

  // Mata Terbuka Melotot Melirik ke Kanan (Wajah marah)
  stroke(30); strokeWeight(1.8); fill(255);
  ellipse(-6, 0, 12, 10); 
  ellipse(10, 0, 12, 10);
  fill(30); noStroke();
  ellipse(-4, 0, 5, 5); 
  ellipse(12, 0, 5, 5); 

  // Alis MARAH Miring ke Bawah
  stroke(30); strokeWeight(2.5); noFill();
  line(-13, -3, -2, -7);
  line(17, -3, 6, -7);
  noStroke(); // FIXED: Prevent stroke leak to remaining parts

  // Mouth speaking animation during dialogue (Dialogue 2 speeded up to 84.5s - 92.0s)
  boolean anakSpeaking = (globalTime >= 84.5 && globalTime < 92.0);
  if (anakSpeaking) {
    float mouthOpen = abs(sin(frameCount * 0.45)) * 8.0 + 2.0;
    fill(100, 30, 30);
    ellipse(3, 14, 7, mouthOpen);
  } else {
    // Bibir cemberut marah
    stroke(180, 40, 50); strokeWeight(2.0); noFill();
    arc(3, 14, 12, 5, 0, PI); 
    noStroke();
  }

  fill(20, 18, 18); arc(0, -8, 44, 34, PI, TWO_PI); 
  quad(-21, -8, -16, 16, -20, 20, -23, -8); quad(21, -8, 16, 16, 20, 20, 23, -8);
  fill(anak.cGold); triangle(0, -22, -10, -17, 10, -17); ellipse(0, -24, 4, 4); 
  popMatrix();

  // 8. TANGAN KIRI (Menunjuk ke arah Ibu di kiri/belakang)
  pushMatrix(); 
  translate(-14, -85); 
  rotate(radians(90)); // Points straight back to the mother on the left (positive 90 points left in this orientation)
  noStroke(); // FIXED: Ensure absolutely no outlines on the pointing arm/hand
  fill(bodyColor); rectMode(CORNER); 
  rect(-6, 0, 12, 42, 4); 
  fill(anak.cSkin); rect(-5, 42, 10, 10, 2); // Hand pointing
  popMatrix();

  popMatrix();
}

void drawSpeechBubble(float bx, float by, String text, boolean pointsLeft) {
  pushMatrix();
  translate(bx, by - 120);
  
  textSize(16);
  float txtWidth = textWidth(text);
  float w = txtWidth + 24;
  float h = 38;
  
  // Shadow
  fill(0, 30);
  rectMode(CENTER);
  rect(2, 2 - 30, w, h, 8);
  
  // Body
  fill(255);
  stroke(40); strokeWeight(2);
  rect(0, -30, w, h, 8);
  
  // Pointer triangle
  fill(255);
  beginShape();
  if (pointsLeft) {
    vertex(-10, -11);
    vertex(-18, -11);
    vertex(-8, -3);
  } else {
    vertex(10, -11);
    vertex(18, -11);
    vertex(8, -3);
  }
  endShape(CLOSE);
  noStroke();
  
  // Text
  fill(30);
  textAlign(CENTER, CENTER);
  text(text, 0, -32);
  
  popMatrix();
}
