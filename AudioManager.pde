// ==========================================
// AUDIO MANAGER — Legenda Batu Menangis
// Menggunakan library Minim
// ==========================================
import ddf.minim.*;

Minim minim;

// --- Musik Latar ---
AudioPlayer bgmScene1;
AudioPlayer bgmScene2;
AudioPlayer bgmScene3;

// --- SFX Atmosfer ---
AudioPlayer sfxHujan;
AudioPlayer sfxPetir;
AudioPlayer sfxMenangis;
AudioPlayer sfxMembatu;

// --- Narasi (11 baris) ---
AudioPlayer narasi1,  narasi2,  narasi3,  narasi4,  narasi5,
            narasi6,  narasi7,  narasi8,  narasi9,  narasi10, narasi11;

// --- Dialog ---
AudioPlayer dialog1;
AudioPlayer dialog2;

// --- Pesan Moral ---
AudioPlayer pesanMoral;

// --- Status flags ---
boolean[] narasiPlayed    = new boolean[12];
boolean dialog1Played     = false;
boolean dialog2Played     = false;
boolean sfxHujanPlaying   = false;
boolean sfxPetirPlayed    = false;
boolean sfxMenangisPlayed = false;
boolean sfxMembatuPlayed  = false;
boolean pesanMoralPlayed  = false;
boolean bgm2Started       = false;
boolean bgm3Started       = false;

// ==========================================
// SETUP AUDIO
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
  narasi1  = loadAudioSafe("audio/narasi1.mp4");
  narasi2  = loadAudioSafe("audio/narasi2.mp4");
  narasi3  = loadAudioSafe("audio/narasi3.mp4");
  narasi4  = loadAudioSafe("audio/narasi4.mp4");
  narasi5  = loadAudioSafe("audio/narasi5.mp4");
  narasi6  = loadAudioSafe("audio/narasi6.mp4");
  narasi7  = loadAudioSafe("audio/narasi7.mp4");
  narasi8  = loadAudioSafe("audio/narasi8.mp4");
  narasi9  = loadAudioSafe("audio/narasi9.mp4");
  narasi10 = loadAudioSafe("audio/narasi10.mp4");
  narasi11 = loadAudioSafe("audio/narasi11.mp4");

  // Dialog
  dialog1    = loadAudioSafe("audio/dialog1.mpeg");
  dialog2    = loadAudioSafe("audio/dialog2.mpeg");

  // Pesan moral
  pesanMoral = loadAudioSafe("audio/pesanmoral.mp4");

  // Mulai BGM Scene 1 langsung
  if (bgmScene1 != null) {
    bgmScene1.setGain(-4);
    bgmScene1.loop();
  }
}

// Helper: load audio dengan fallback graceful
AudioPlayer loadAudioSafe(String path) {
  try {
    AudioPlayer p = minim.loadFile(path);
    if (p != null) p.setGain(-5);
    return p;
  } catch (Exception e) {
    println("⚠️ Tidak bisa memuat: " + path);
    return null;
  }
}

// ==========================================
// UPDATE AUDIO — dipanggil setiap frame
// ==========================================
void updateAudio() {

  // ---- Hentikan BGM1 saat zoom transition ----
  if (globalTime >= 13.0 && bgmScene1 != null && bgmScene1.isPlaying()) {
    bgmScene1.pause();
  }

  // ---- BGM Scene 2 ----
  if (currentScene == 2 && !bgm2Started && bgmScene2 != null) {
    bgmScene2.setGain(-6);
    bgmScene2.loop();
    bgm2Started = true;
  }

  // ---- BGM Scene 3 & 4 ----
  if (currentScene >= 3 && !bgm3Started && bgmScene3 != null) {
    if (bgmScene2 != null && bgmScene2.isPlaying()) bgmScene2.pause();
    bgmScene3.setGain(-6);
    bgmScene3.loop();
    bgm3Started = true;
  }

  // ---- Hentikan BGM3 saat storm Scene 5 ----
  if (globalTime >= 105.0 && bgmScene3 != null && bgmScene3.isPlaying()) {
    bgmScene3.pause();
  }

  // ==========================================
  // NARASI — Scene 2
  // ==========================================
  playNarasiOnce(narasi1,  1, 15.5);
  playNarasiOnce(narasi2,  2, 22.5);
  playNarasiOnce(narasi3,  3, 33.5);

  // ==========================================
  // NARASI — Scene 3
  // ==========================================
  playNarasiOnce(narasi4,  4, 46.0);
  playNarasiOnce(narasi5,  5, 56.0);
  playNarasiOnce(narasi6,  6, 66.0);

  // ==========================================
  // DIALOG — Scene 4
  // ==========================================
  if (globalTime >= 79.5 && !dialog1Played) {
    playOnce(dialog1);
    dialog1Played = true;
  }
  if (globalTime >= 84.5 && !dialog2Played) {
    playOnce(dialog2);
    dialog2Played = true;
  }

  // ==========================================
  // NARASI 7 — setelah dialog
  // ==========================================
  playNarasiOnce(narasi7, 7, 92.5);

  // ==========================================
  // SFX + NARASI — Scene 5
  // ==========================================
  if (globalTime >= 105.0 && !sfxMenangisPlayed) {
    playOnce(sfxMenangis);
    sfxMenangisPlayed = true;
  }
  playNarasiOnce(narasi8, 8, 114.5);

  // ==========================================
  // SFX + NARASI — Scene 6
  // ==========================================
  if (globalTime >= 135.0 && !sfxPetirPlayed) {
    playOnce(sfxPetir);
    sfxPetirPlayed = true;
  }
  if (globalTime >= 136.0 && !sfxHujanPlaying && sfxHujan != null) {
    sfxHujan.setGain(-8);
    sfxHujan.loop();
    sfxHujanPlaying = true;
  }
  if (globalTime >= 165.0 && sfxHujanPlaying && sfxHujan != null && sfxHujan.isPlaying()) {
    sfxHujan.pause();
    sfxHujanPlaying = false;
  }
  if (globalTime >= 137.0 && !sfxMembatuPlayed) {
    playOnce(sfxMembatu);
    sfxMembatuPlayed = true;
  }
  playNarasiOnce(narasi9,  9,  137.5);
  playNarasiOnce(narasi10, 10, 147.5);
  playNarasiOnce(narasi11, 11, 157.5);

  // ==========================================
  // PESAN MORAL — Scene 7
  // ==========================================
  if (globalTime >= 170.0 && !pesanMoralPlayed) {
    playOnce(pesanMoral);
    pesanMoralPlayed = true;
  }
}

// Helper: play narasi sekali pada waktu tertentu
void playNarasiOnce(AudioPlayer player, int idx, float startTime) {
  if (player == null) return;
  if (globalTime >= startTime && !narasiPlayed[idx]) {
    player.rewind();
    player.play();
    narasiPlayed[idx] = true;
  }
}

// Helper: play SFX sekali (one-shot)
void playOnce(AudioPlayer player) {
  if (player == null) return;
  player.rewind();
  player.play();
}

// ==========================================
// CLEANUP — dipanggil otomatis saat sketch stop
// ==========================================
void stop() {
  AudioPlayer[] all = {
    bgmScene1, bgmScene2, bgmScene3,
    sfxHujan, sfxPetir, sfxMenangis, sfxMembatu,
    narasi1, narasi2, narasi3, narasi4, narasi5, narasi6,
    narasi7, narasi8, narasi9, narasi10, narasi11,
    dialog1, dialog2, pesanMoral
  };
  for (AudioPlayer p : all) {
    if (p != null) p.close();
  }
  if (minim != null) minim.stop();
  super.stop();
}
