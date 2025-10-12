enum DownloadOption {
  videoAudio('Video + Ses', 'En iyi kalitede video ve ses'),
  audioMp3('Sadece Ses (MP3)', 'Yüksek kaliteli MP3 formatında'),
  audioOriginal('Sadece Ses (Orijinal)', 'Maksimum kalitede orijinal format'),
  videoOnly('Sadece Video', 'Sessiz video');

  final String title;
  final String description;

  const DownloadOption(this.title, this.description);
}
