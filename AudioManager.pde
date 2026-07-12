// ==========================================
// AUDIO MANAGER — Legenda Batu Menangis
// Menggunakan library Minim (built-in Processing)
// ==========================================
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;

// --- Musik Latar ---
AudioPlayer bgmScene1;   // audio/scene1.webm
AudioPlayer bgmScene2;   // audio/scene2.mp3
AudioPlayer bgmScene3;   // audio/scene3.mp3  (Scene 3 & 4)

// --- SFX Atmosfer ---
AudioPlayer sfxHujan;    // audio/hujan.webm
AudioPlayer sfxPetir;    // audio/petir.webm
AudioPlayer sfxMenangis; // audio/sfx menangis.mp4
AudioPlayer sfxMembatu;  // audio/sfxmembatu.mp4

// --- Narasi (11 baris) ---
AudioPlayer narasi1;     // audio/narasi1.mp4
AudioPlayer narasi2;     // audio/narasi2.mp4
AudioPlayer narasi3;     // audio/narasi3.mp4
AudioPlayer narasi4;     // audio/narasi4.mp4
AudioPlayer narasi5;     // audio/narasi5.mp4
AudioPlayer narasi6;     // audio/narasi6.mp4
AudioPlayer narasi7;     // audio/narasi7.mp4
AudioPlayer narasi8;     // audio/narasi8.mp4
AudioPlayer narasi9;     // audio/narasi9.mp4
AudioPlayer narasi10;    // audio/narasi10.mp4
AudioPlayer narasi11;    // audio/narasi11.mp4

// --- Dialog ---
AudioPlayer dialog1;     // audio/dialog1.mpeg  (Pedagang)
AudioPlayer dialog2;     // audio/dialog2.mpeg  (Anak)

// --- Pesan Moral ---
AudioPlayer pesanMoral;  // audio/pesanmoral.mp4

// --- Status flags (untuk pastikan audio hanya diplay sekali) ---
boolean[] narasiPlayed   = new boolean[12]; // index 1-11
boolean dialog1Played    = false;
boolean dialog2Played    = false;
boolean sfxHujanPlaying  = false;
boolean sfxPetirPlayed   = false;
boolean sfxMenangisPlayed= false;
boolean sfxMembatuPlayed = false;
boolean pesanMoralPlayed = false;

// ==========================================
// SETUP AUDIO — dipanggil di setup()
// ==========================================
void setupAudio() {
  minim = new Minim(this);
  
  // Musik latar
  bgmScene1   = loadAudioSafe("audio/scene1.webm");
  bgmScene2   = loadAudioSafe("audio/scene2.mp3");
  bgmScene3   = loadAudioSafe("audio/scene3.mp3");
  
  // SFX
  sfxHujan    = loadAudioSafe("audio/hujan.webm");
  sfxPetir    = loadAudioSafe("audio/petir.webm");
  sfxMenangis = loadAudioSafe("audio/sfx menangis.mp4");
  sfxMembatu  = loadAudioSafe("audio/sfxmembatu.mp4");
  
  // Narasi
  narasi1     = loadAudioSafe("audio/narasi1.mp4");
  narasi2     = loadAudioSafe("audio/narasi2.mp4");
  narasi3     = loadAudioSafe("audio/narasi3.mp4");
  narasi4     = loadAudioSafe("audio/narasi4.mp4");
  narasi5     = loadAudioSafe("audio/narasi5.mp4");
  narasi6     = loadAudioSafe("audio/narasi6.mp4");
  narasi7     = loadAudioSafe("audio/narasi7.mp4");
  narasi8     = loadAudioSafe("audio/narasi8.mp4");
  narasi9     = loadAudioSafe("audio/narasi9.mp4");
  narasi10    = loadAudioSafe("audio/narasi10.mp4");
  narasi11    = loadAudioSafe("audio/narasi11.mp4");
  
  // Dialog
  dialog1     = loadAudioSafe("audio/dialog1.mpeg");
  dialog2     = loadAudioSafe("audio/dialog2.mpeg");
  
  // Pesan moral
  pesanMoral  = loadAudioSafe("audio/pesanmoral.mp4");
  
  // Mulai musik Scene 1 langsung
  playBGM(bgmScene1, 0.85);
}

// Helper: load audio dengan graceful fallback
AudioPlayer loadAudioSafe(String path) {
  try {
    AudioPlayer p = minim.loadFile(path);
    if (p != null) p.setGain(-5); // Volume default sedikit lebih rendah dari max
    return p;
  } catch (Exception e) {
    println("⚠️ Tidak bisa memuat audio: " + path);
    return null;
  }
}

// Helper: play BGM dengan loop, stop yang sebelumnya
void playBGM(AudioPlayer player, float volume) {
  if (player == null) return;
  player.setGain(map(volume, 0, 1, -40, 0)); // Konversi 0-1 ke dB gain
  player.loop();
}

// Helper: play sekali (one-shot), tidak loop
void playOnce(AudioPlayer player) {
  if (player == null) return;
  player.rewind();
  player.play();
}

// Helper: stop audio dengan fade check
void stopAudio(AudioPlayer player) {
  if (player != null && player.isPlaying()) {
    player.pause();
    player.rewind();
  }
}

// ==========================================
// UPDATE AUDIO — dipanggil setiap frame di draw()
// ==========================================
void updateAudio() {
  
  // ---- BGM Scene 1 (0 - ~15s) ----
  // Sudah di-play di setupAudio(), berhenti saat zoom transition
  if (globalTime >= 13.0 && bgmScene1 != null && bgmScene1.isPlaying()) {
    bgmScene1.pause();
  }
  
  // ---- BGM Scene 2 (mulai saat masuk scene 2) ----
  if (currentScene == 2 && bgmScene2 != null && !bgmScene2.isPlaying()
      && (bgmScene3 == null || !bgmScene3.isPlaying())) {
    stopAudio(bgmScene1);
    playBGM(bgmScene2, 0.75);
  }
  
  // ---- BGM Scene 3 & 4 (mulai saat masuk scene 3) ----
  if (currentScene >= 3 && bgmScene3 != null && !bgmScene3.isPlaying()) {
    stopAudio(bgmScene2);
    playBGM(bgmScene3, 0.75);
  }
  
  // ---- Hentikan bgmScene3 saat storm Scene 5 ----
  if (globalTime >= 105.0 && bgmScene3 != null && bgmScene3.isPlaying()) {
    bgmScene3.pause();
  }

  // ==========================================
  // NARASI — Scene 2
  // ==========================================
  playNarasiOnce(narasi1, 1, 15.5, 22.0);   // Scene 2 narasi 1
  playNarasiOnce(narasi2, 2, 22.5, 33.0);   // Scene 2 narasi 2
  playNarasiOnce(narasi3, 3, 33.5, 44.0);   // Scene 2 narasi 3
  
  // ==========================================
  // NARASI — Scene 3
  // ==========================================
  playNarasiOnce(narasi4, 4, 46.0, 55.0);   // Scene 3 narasi 4
  playNarasiOnce(narasi5, 5, 56.0, 65.0);   // Scene 3 narasi 5
  playNarasiOnce(narasi6, 6, 66.0, 74.0);   // Scene 3 narasi 6
  
  // ==========================================
  // DIALOG — Scene 4 (Pasar)
  // ==========================================
  // Dialog 1: Pedagang
  if (globalTime >= 79.5 && !dialog1Played) {
    playOnce(dialog1);
    dialog1Played = true;
  }
  // Dialog 2: Anak
  if (globalTime >= 84.5 && !dialog2Played) {
    playOnce(dialog2);
    dialog2Played = true;
  }
  
  // ==========================================
  // NARASI 7 — Scene 4 (setelah dialog)
  // ==========================================
  playNarasiOnce(narasi7, 7, 92.5, 105.0);
  
  // ==========================================
  // SFX & NARASI — Scene 5 (Ibu Menangis & Berdoa)
  // ==========================================
  // SFX menangis ibu mulai saat scene 5
  if (globalTime >= 105.0 && !sfxMenangisPlayed) {
    playOnce(sfxMenangis);
    sfxMenangisPlayed = true;
  }
  // Narasi 8: "Hati sang ibu hancur..."
  playNarasiOnce(narasi8, 8, 114.5, 135.0);
  
  // ==========================================
  // SFX & NARASI — Scene 6 (Kutukan & Hujan)
  // ==========================================
  // SFX petir flash awal Scene 6
  if (globalTime >= 135.0 && !sfxPetirPlayed) {
    playOnce(sfxPetir);
    sfxPetirPlayed = true;
  }
  // SFX hujan mulai
  if (globalTime >= 136.0 && !sfxHujanPlaying && sfxHujan != null) {
    sfxHujan.loop();
    sfxHujanPlaying = true;
  }
  // Hentikan hujan di Scene 7
  if (globalTime >= 165.0 && sfxHujanPlaying && sfxHujan != null && sfxHujan.isPlaying()) {
    sfxHujan.pause();
    sfxHujanPlaying = false;
  }
  // SFX membatu
  if (globalTime >= 137.0 && !sfxMembatuPlayed) {
    playOnce(sfxMembatu);
    sfxMembatuPlayed = true;
  }
  // Narasi 9-11
  playNarasiOnce(narasi9,  9,  137.5, 147.0);
  playNarasiOnce(narasi10, 10, 147.5, 157.0);
  playNarasiOnce(narasi11, 11, 157.5, 165.0);
  
  // ==========================================
  // PESAN MORAL — Scene 7
  // ==========================================
  if (globalTime >= 170.0 && !pesanMoralPlayed) {
    playOnce(pesanMoral);
    pesanMoralPlayed = true;
  }
}

// Helper: play narasi sekali dalam window waktu tertentu
void playNarasiOnce(AudioPlayer player, int idx, float startTime, float endTime) {
  if (player == null) return;
  if (globalTime >= startTime && globalTime < endTime && !narasiPlayed[idx]) {
    playOnce(player);
    narasiPlayed[idx] = true;
  }
}

// ==========================================
// CLEANUP — dipanggil saat sketch stop
// ==========================================
void stop() {
  if (bgmScene1   != null) bgmScene1.close();
  if (bgmScene2   != null) bgmScene2.close();
  if (bgmScene3   != null) bgmScene3.close();
  if (sfxHujan    != null) sfxHujan.close();
  if (sfxPetir    != null) sfxPetir.close();
  if (sfxMenangis != null) sfxMenangis.close();
  if (sfxMembatu  != null) sfxMembatu.close();
  if (narasi1     != null) narasi1.close();
  if (narasi2     != null) narasi2.close();
  if (narasi3     != null) narasi3.close();
  if (narasi4     != null) narasi4.close();
  if (narasi5     != null) narasi5.close();
  if (narasi6     != null) narasi6.close();
  if (narasi7     != null) narasi7.close();
  if (narasi8     != null) narasi8.close();
  if (narasi9     != null) narasi9.close();
  if (narasi10    != null) narasi10.close();
  if (narasi11    != null) narasi11.close();
  if (dialog1     != null) dialog1.close();
  if (dialog2     != null) dialog2.close();
  if (pesanMoral  != null) pesanMoral.close();
  if (minim       != null) minim.stop();
  super.stop();
}
