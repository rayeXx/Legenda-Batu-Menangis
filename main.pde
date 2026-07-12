// ==========================================
// GLOBAL VARIABLES & MANAGERS
// ==========================================
int currentScene = 1;
float globalTime = 0; 

// ============================================
// VARIABEL TRANSISI SKY-ZOOM (Scene 1 -> 2)
// ============================================
// skyZoomProgress: 0.0 = normal, 1.0 = fully zoomed in (sky fills screen)
float skyZoomProgress = 0.0;
boolean skyZoomDone    = false;  // set true once we flip to scene 2

// Scene 1 sky top/bottom colours  (from Scene1.pde gradient)
color s1SkyTop    = color(35,  65,  105);
color s1SkyBot    = color(210, 135,  85);

// Scene 2 sky top/bottom colours  (from Scene2.pde gradient)
color s2SkyTop    = color(105, 175, 190);
color s2SkyBot    = color(245, 175, 110);

// How long (seconds) the full zoom-in takes
float ZOOM_DURATION = 3.0;
float zoomStartTime  = -1;

// Scene 2 zoom-out: how long to ease back to 1.0
float ZOOMOUT_DURATION = 2.5;
float scene2StartTime  = -1;

// Variabel Efek Transisi Black Out (Scene 2 -> 3)
float blackOutAlpha = 0;
boolean triggerBlackOut = false;
float blackOutStartTime = 0;

// Variabel Efek Transisi Black Out (Scene 3 -> 4)
float blackOutAlpha4 = 0;
boolean triggerBlackOut4 = false;
float blackOutStartTime4 = 0;

CharacterIbu ibu;
CharacterAnak anak;

void setup() {
  size(1280, 720); 
  smooth(8);
  frameRate(60);
  
  ibu  = new CharacterIbu(width/2 - 200, height - 150);
  anak = new CharacterAnak(width/2 + 200, height - 150);
  
  setupScene1();
  setupScene2();
  setupScene4();
  setupAudio();  // Muat & mulai semua audio
}

void draw() {
  globalTime = millis() / 1000.0;
  updateAudio();  // Update audio setiap frame sesuai timeline
  
  // ==========================================
  // TIMELINE: start zoom at 12 s in Scene 1
  // ==========================================
  if (globalTime >= 12.0 && currentScene == 1 && zoomStartTime < 0) {
    zoomStartTime = globalTime;
  }
  
  if (zoomStartTime > 0 && currentScene == 1) {
    float elapsed = globalTime - zoomStartTime;
    // Smooth ease-in-out curve  (smoothstep)
    float t = constrain(elapsed / ZOOM_DURATION, 0, 1);
    skyZoomProgress = t * t * (3 - 2 * t);  // smoothstep
    
    // At the peak of zoom flip to Scene 2
    if (elapsed >= ZOOM_DURATION && !skyZoomDone) {
      skyZoomDone   = true;
      currentScene  = 2;
      scene2StartTime = globalTime;
    }
  }
  
  // ==========================================
  // Scene 2 zoom-out progress
  // ==========================================
  float zoomOutProgress = 0.0;
  if (currentScene == 2 && scene2StartTime > 0) {
    float elapsed2 = globalTime - scene2StartTime;
    float t2 = constrain(elapsed2 / ZOOMOUT_DURATION, 0, 1);
    zoomOutProgress = 1.0 - t2 * t2 * (3 - 2 * t2); // smoothstep reversed
  }

  // Transisi dari Scene 2 ke Scene 3 (Black Out)
  if (globalTime >= 44.5 && currentScene == 2 && !triggerBlackOut) {
    triggerBlackOut = true;
    blackOutStartTime = globalTime;
  }
  if (triggerBlackOut && (globalTime - blackOutStartTime >= 0.5) && currentScene == 2) {
    currentScene = 3;
  }

  // Transisi dari Scene 3 ke Scene 4 (Black Out)
  if (globalTime >= 74.5 && currentScene == 3 && !triggerBlackOut4) {
    triggerBlackOut4 = true;
    blackOutStartTime4 = globalTime;
  }
  if (triggerBlackOut4 && (globalTime - blackOutStartTime4 >= 0.5) && currentScene == 3) {
    currentScene = 4;
  }

  // ==========================================
  // RENDER CURRENT SCENE
  // ==========================================
  
  if (currentScene == 1) {
    // Determine zoom scale & pivot (top-centre of sky area)
    float zoomScale = lerp(1.0, 8.0, skyZoomProgress);  // zoom up to 8x into sky
    float pivotX = width  / 2.0;
    float pivotY = height * 0.15;  // aim at the upper-sky area
    
    // Apply zoom transform
    pushMatrix();
    translate(pivotX, pivotY);
    scale(zoomScale);
    translate(-pivotX, -pivotY);
    displayScene1();
    popMatrix();
    
    // Overlay blended sky colour that fills screen as zoom peaks
    // (makes the colour feel like it's cross-dissolving to Scene 2's sky)
    if (skyZoomProgress > 0.4) {
      float blendT = map(skyZoomProgress, 0.4, 1.0, 0, 1);
      blendT = constrain(blendT, 0, 1);
      
      // Draw a vertical sky gradient that cross-fades to Scene 2 colours
      for (int i = 0; i < height; i++) {
        float inter = (float)i / height;
        color rowS1  = lerpColor(s1SkyTop, s1SkyBot, inter);
        color rowS2  = lerpColor(s2SkyTop, s2SkyBot, inter);
        color rowBlend = lerpColor(rowS1, rowS2, blendT);
        // Alpha rises with blendT so the overlay gradually takes over
        float overlayA = blendT * blendT * 255;
        stroke(red(rowBlend), green(rowBlend), blue(rowBlend), overlayA);
        line(0, i, width, i);
      }
      noStroke();
    }
    
  } else if (currentScene == 2) {
    // Zoom-out: dari 1.4x → 1.0x, pivot di tengah layar
    // rectMode(CORNER) sudah di-reset di dalam displayScene2(), jadi aman
    float elapsed2 = (scene2StartTime > 0) ? (globalTime - scene2StartTime) : 0;
    float t2 = constrain(elapsed2 / ZOOMOUT_DURATION, 0, 1);
    float easeT2 = t2 * t2 * (3 - 2 * t2);  // smoothstep
    float zoomScale2 = lerp(1.4, 1.0, easeT2);
    
    float pivotX2 = width  / 2.0;
    float pivotY2 = height / 2.0;  // pivot tengah — rumah tetap dalam frame
    
    pushMatrix();
    translate(pivotX2, pivotY2);
    scale(zoomScale2);
    translate(-pivotX2, -pivotY2);
    displayScene2();
    popMatrix();
    
    // Sky overlay: opaque saat masuk, memudar dalam 1.5 detik pertama
    float fadeOut = constrain(1.0 - (elapsed2 / 1.5), 0, 1);
    fadeOut = fadeOut * fadeOut;
    if (fadeOut > 0) {
      float overlayA = fadeOut * 255;
      for (int i = 0; i < height; i++) {
        float inter = (float)i / height;
        color rowS2 = lerpColor(s2SkyTop, s2SkyBot, inter);
        stroke(red(rowS2), green(rowS2), blue(rowS2), overlayA);
        line(0, i, width, i);
      }
      noStroke();
    }
    
  } else if (currentScene == 3) {
    displayScene3();
  } else if (currentScene == 4) {
    displayScene4();
  }
  
  // ==========================================
  // SCREEN TRANSITION EFFECT (BLACK OUT Scene 2->3)
  // ==========================================
  if (triggerBlackOut) {
    if (currentScene == 2) {
      blackOutAlpha = map(globalTime - blackOutStartTime, 0, 0.5, 0, 255);
    } else {
      blackOutAlpha = map(globalTime - (blackOutStartTime + 0.5), 0, 0.5, 255, 0);
      if (blackOutAlpha < 0) blackOutAlpha = 0;
    }
    rectMode(CORNER);
    fill(0, blackOutAlpha);
    rect(0, 0, width, height);
  }

  // ==========================================
  // SCREEN TRANSITION EFFECT (BLACK OUT Scene 3->4)
  // ==========================================
  if (triggerBlackOut4) {
    if (currentScene == 3) {
      blackOutAlpha4 = map(globalTime - blackOutStartTime4, 0, 0.5, 0, 255);
    } else {
      blackOutAlpha4 = map(globalTime - (blackOutStartTime4 + 0.5), 0, 0.5, 255, 0);
      if (blackOutAlpha4 < 0) blackOutAlpha4 = 0;
    }
    rectMode(CORNER);
    fill(0, blackOutAlpha4);
    rect(0, 0, width, height);
  }
}

void drawHUDNarasi(String teks) {
  rectMode(CENTER);
  fill(0, 160);
  rect(width/2, height - 70, width - 200, 85, 12);
  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(21);
  text(teks, width/2, height - 72);
}
