// ==========================================
// SCENE 5 — PESAN MORAL & OUTRO
// ==========================================

void setupScene5() {
  // Setup jika diperlukan di masa depan
}

void displayScene5() {
  background(0); // Solid black background — completely lag-free!
  
  // 1. PESAN MORAL CARD OVERLAY (Detik 164.0 - 183.0)
  if (globalTime >= 164.0 && globalTime < 183.0) {
    float cardAlpha = map(globalTime, 164.0, 165.0, 0, 255);
    if (globalTime >= 182.0) cardAlpha = map(globalTime, 182.0, 183.0, 255, 0);
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
  
  // 2. SELESAI CARD (Detik 183.0+)
  if (globalTime >= 183.0) {
    float selesaiAlpha = map(globalTime, 183.0, 184.5, 0, 255);
    selesaiAlpha = constrain(selesaiAlpha, 0, 255);
    
    fill(255, 215, 100, selesaiAlpha);
    textSize(36);
    textAlign(CENTER, CENTER);
    text("SELESAI", width/2, height/2 - 40);
    
    fill(200, selesaiAlpha);
    textSize(18);
    text("Terima Kasih Telah Menonton", width/2, height/2 + 20);
  }
}
