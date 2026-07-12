// ==========================================
// AUDIO MANAGER — Legenda Batu Menangis
// Menggunakan library Minim
// ==========================================
// CATATAN: File .webm mungkin tidak didukung Minim (JavaSound).
// Jika scene1.webm / hujan.webm / petir.webm tidak bunyi,
// konversi ke .mp3 menggunakan VLC atau online converter.
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
// VOLUME CONSTANTS
// Gain dalam dB: 0 = penuh, -6 ≈ 50%, -12 ≈ 25%
// ==========================================
final float VOL_BGM    = -10; // BGM dikecilkan 50%
final float VOL_BGM2   = -12; // BGM Scene 2 lebih kecil 20% lagi
final float VOL_SFX    = -6;  // SFX efek suara
final float VOL_NARASI = -3;  // Narasi/dialog
final float VOL_DIALOG2 = 2;  // Dialog2 digedein 75% (+5dB dari VOL_NARASI)

// ==========================================
// SETUP AUDIO
// ==========================================
void setupAudio() {
  minim = new Minim(this);

  // Musik latar
  bgmScene1   = loadAudioSafe("audio/scene1.mp3");
  bgmScene2   = loadAudioSafe("audio/scene2.mp3");
  bgmScene3   = loadAudioSafe("audio/scene3.mp3");

  // SFX
  sfxHujan    = loadAudioSafe("audio/hujan.mp3");
  sfxPetir    = loadAudioSafe("audio/petir.mp3");
  sfxMenangis = loadAudioSafe("audio/sfx_menangis.mp3");
  sfxMembatu  = loadAudioSafe("audio/sfxmembatu.mp3");

  // Narasi
  narasi1  = loadAudioSafe("audio/narasi1.mp3");
  narasi2  = loadAudioSafe("audio/narasi2.mp3");
  narasi3  = loadAudioSafe("audio/narasi3.mp3");
  narasi4  = loadAudioSafe("audio/narasi4.mp3");
  narasi5  = loadAudioSafe("audio/narasi5.mp3");
  narasi6  = loadAudioSafe("audio/narasi6.mp3");
  narasi7  = loadAudioSafe("audio/narasi7.mp3");
  narasi8  = loadAudioSafe("audio/narasi8.mp3");
  narasi9  = loadAudioSafe("audio/narasi9.mp3");
  narasi10 = loadAudioSafe("audio/narasi10.mp3");
  narasi11 = loadAudioSafe("audio/narasi11.mp3");

  // Dialog
  dialog1    = loadAudioSafe("audio/dialog1.mp3");
  dialog2    = loadAudioSafe("audio/dialog2.mp3");

  // Pesan moral
  pesanMoral = loadAudioSafe("audio/pesanmoral.mp3");

  // ---- Mulai BGM Scene 1 langsung ----
  if (bgmScene1 != null) {
    bgmScene1.setGain(VOL_BGM);
    bgmScene1.loop();
    println("✅ BGM Scene 1 dimulai");
  } else {
    println("⚠️ scene1.webm gagal dimuat. Coba konversi ke scene1.mp3");
  }
}

// Helper: load audio dengan fallback graceful
AudioPlayer loadAudioSafe(String path) {
  try {
    AudioPlayer p = minim.loadFile(path);
    if (p != null) {
      p.setGain(VOL_BGM);
      println("✅ Loaded: " + path);
    }
    return p;
  } catch (Exception e) {
    println("⚠️ Gagal memuat: " + path + " → " + e.getMessage());
    return null;
  }
}

// ==========================================
// UPDATE AUDIO — dipanggil setiap frame
// ==========================================
void updateAudio() {

  // ---- Hentikan BGM1 saat zoom transition ke scene 2 ----
  if (globalTime >= 13.5 && bgmScene1 != null && bgmScene1.isPlaying()) {
    bgmScene1.pause();
  }

  // ---- BGM Scene 2: mulai tepat saat masuk scene 2 ----
  if (currentScene == 2 && !bgm2Started && bgmScene2 != null) {
    bgmScene2.setGain(VOL_BGM2);  // lebih kecil 20% dari BGM lain
    bgmScene2.loop();
    bgm2Started = true;
  }

  // ---- BGM Scene 3 & 4: mulai tepat saat masuk scene 3 ----
  if (currentScene >= 3 && !bgm3Started && bgmScene3 != null) {
    if (bgmScene2 != null && bgmScene2.isPlaying()) bgmScene2.pause();
    bgmScene3.setGain(VOL_BGM);
    bgmScene3.loop();
    bgm3Started = true;
  }

  // ---- Hentikan BGM3 saat storm Scene 5 (105s) ----
  if (globalTime >= 105.0 && bgmScene3 != null && bgmScene3.isPlaying()) {
    bgmScene3.pause();
  }

  // ==========================================
  // NARASI — timing sinkron TEPAT dengan HUD teks
  // ==========================================

  // Scene 2: teks muncul sejak scene 2 masuk s.d. 22s
  playNarasiOnce(narasi1,  1, 15.5);   // ← scene 2 masuk

  // Scene 2: narasi 2 ditunda 3 detik (25s) agar narasi 1 selesai dulu
  playNarasiOnce(narasi2,  2, 25.0);

  // Scene 2: teks berubah tepat 33s
  playNarasiOnce(narasi3,  3, 33.0);

  // Scene 3: teks muncul sejak scene 3 masuk s.d. 55s
  playNarasiOnce(narasi4,  4, 45.5);   // ← scene 3 masuk (setelah blackout ~45s)

  // Scene 3: teks berubah tepat 55s
  playNarasiOnce(narasi5,  5, 55.0);

  // Scene 3: teks berubah tepat 65s
  playNarasiOnce(narasi6,  6, 65.0);

  // Scene 4: narasi setelah dialog anak (HUD: 88s - 105s)
  playNarasiOnce(narasi7,  7, 88.0);

  // Scene 5: narasi ibu berdoa (HUD: 114s - 135s)
  playNarasiOnce(narasi8,  8, 114.0);

  // Scene 6: narasi kutukan bertahap (HUD: 137s-165s)
  playNarasiOnce(narasi9,  9,  137.0);
  playNarasiOnce(narasi10, 10, 147.0);
  playNarasiOnce(narasi11, 11, 157.0);

  // ==========================================
  // DIALOG — Scene 4 (Pasar)
  // ==========================================
  // Dialog pedagang: mulai saat bubble muncul (79.5s)
  if (globalTime >= 79.5 && !dialog1Played) {
    playOnce(dialog1, VOL_NARASI);
    dialog1Played = true;
  }
  // Dialog anak: mulai saat bubble muncul (84.5s) — volume lebih keras
  if (globalTime >= 84.5 && !dialog2Played) {
    playOnce(dialog2, VOL_DIALOG2);
    dialog2Played = true;
  }

  // ==========================================
  // SFX — Scene 5 (Ibu Menangis)
  // ==========================================
  if (globalTime >= 105.0 && !sfxMenangisPlayed) {
    playOnce(sfxMenangis, VOL_SFX);
    sfxMenangisPlayed = true;
  }

  // ==========================================
  // SFX — Scene 6 (Kutukan, Petir, Hujan, Membatu)
  // ==========================================
  // Petir: tepat saat flash putih (135s)
  if (globalTime >= 135.0 && !sfxPetirPlayed) {
    playOnce(sfxPetir, VOL_SFX);
    sfxPetirPlayed = true;
  }
  // Hujan loop: mulai 136s, berhenti 165s
  if (globalTime >= 136.0 && !sfxHujanPlaying && sfxHujan != null) {
    sfxHujan.setGain(VOL_BGM);
    sfxHujan.loop();
    sfxHujanPlaying = true;
  }
  if (globalTime >= 165.0 && sfxHujanPlaying && sfxHujan != null && sfxHujan.isPlaying()) {
    sfxHujan.pause();
    sfxHujanPlaying = false;
  }
  // SFX membatu: ditunda 3 detik → 140s
  if (globalTime >= 140.0 && !sfxMembatuPlayed) {
    playOnce(sfxMembatu, VOL_SFX);
    sfxMembatuPlayed = true;
  }

  // ==========================================
  // PESAN MORAL — Scene 7 (170s)
  // ==========================================
  if (globalTime >= 170.0 && !pesanMoralPlayed) {
    playOnce(pesanMoral, VOL_NARASI);
    pesanMoralPlayed = true;
  }
}

// Helper: play narasi sekali pada waktu tertentu
void playNarasiOnce(AudioPlayer player, int idx, float startTime) {
  if (player == null) return;
  if (globalTime >= startTime && !narasiPlayed[idx]) {
    player.rewind();
    player.setGain(VOL_NARASI);
    player.play();
    narasiPlayed[idx] = true;
    println("▶ Narasi " + idx + " dimulai pada t=" + nf(globalTime, 0, 1) + "s");
  }
}

// Helper: play SFX/dialog sekali
void playOnce(AudioPlayer player, float gain) {
  if (player == null) return;
  player.rewind();
  player.setGain(gain);
  player.play();
}

// ==========================================
// CLEANUP
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
