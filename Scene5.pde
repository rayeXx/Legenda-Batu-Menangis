// ==========================================
// SCENE 5 — PESAN MORAL & CREDITS
// ==========================================

void setupScene5() {
  // Setup jika diperlukan di masa depan
}

void displayScene5() {
  background(0); // Solid black background — completely lag-free!
  
  // 1. PESAN MORAL CARD OVERLAY (Detik 169.0 - 188.0)
  if (globalTime >= 169.0 && globalTime < 188.0) {
    float cardAlpha = map(globalTime, 169.0, 170.0, 0, 255);
    if (globalTime >= 187.0) cardAlpha = map(globalTime, 187.0, 188.0, 255, 0);
    cardAlpha = constrain(cardAlpha, 0, 255);
    
    rectMode(CENTER);
    fill(15, 15, 20, cardAlpha * 0.85);
    stroke(255, 215, 100, cardAlpha * 0.3);
    strokeWeight(1.5);
    rect(width/2, height/2, width - 260, height - 250, 15);
    noStroke();
    
    fill(255, 220, 100, cardAlpha);
    textSize(26);
    textAlign(CENTER, CENTER);
    text("PESAN MORAL", width/2, height/2 - 100);
    
    fill(245, cardAlpha);
    textSize(18);
    text("1. Hormatilah kedua orang tua, terutama ibu yang telah berjuang membesarkan kita.", width/2, height/2 - 30);
    text("2. Penyesalan selalu datang terlambat.", width/2, height/2 + 20);
    text("3. Kasih sayang orang tua tidak dapat digantikan oleh apa pun.", width/2, height/2 + 70);
  }
  
  // 2. CREDIT SCENE (Detik 188.0+)
  if (globalTime >= 188.0) {
    float creditsAlpha = map(globalTime, 188.0, 189.5, 0, 255);
    creditsAlpha = constrain(creditsAlpha, 0, 255);
    
    // Draw background solid black
    fill(0);
    rectMode(CORNER);
    rect(0, 0, width, height);
    
    // Calculate scroll Y position
    float scrollSpeed = 60.0; // 60 pixels per second
    float scrollY = (height + 50) - (globalTime - 188.0) * scrollSpeed;
    float currentY = scrollY;
    
    // Draw scrolling credits text
    textAlign(CENTER, TOP);
    textSize(28);
    fill(255, 215, 100, creditsAlpha);
    text("LEGENDA BATU MENANGIS", width/2, currentY);
    currentY += 95;
    
    for (int i = 0; i < credits.length; i++) {
      textSize(15);
      fill(200, creditsAlpha);
      text(credits[i][0], width/2, currentY);
      textSize(19);
      fill(255, creditsAlpha);
      text(credits[i][1], width/2, currentY + 23);
      currentY += 78;
    }
    
    currentY += 40;
    
    // Once the credits finish scrolling, fade in the final static "SELESAI" card
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
  }
}
