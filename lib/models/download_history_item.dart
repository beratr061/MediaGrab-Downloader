class DownloadHistoryItem {
  final String id;
  final String title;
  final String url;
  final String filePath;
  final String type; // 'video' or 'audio'
  final String format; // 'mp4', 'mp3', etc.
  final int fileSize; // bytes
  final DateTime downloadDate;
  final String thumbnail;

  DownloadHistoryItem({
    required this.id,
    required this.title,
    required this.url,
    required this.filePath,
    required this.type,
    required this.format,
    required this.fileSize,
    required this.downloadDate,
    this.thumbnail = '',
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'filePath': filePath,
      'type': type,
      'format': format,
      'fileSize': fileSize,
      'downloadDate': downloadDate.toIso8601String(),
      'thumbnail': thumbnail,
    };
  }

  factory DownloadHistoryItem.fromJson(Map<String, dynamic> json) {
    return DownloadHistoryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      filePath: json['filePath'] as String,
      type: json['type'] as String,
      format: json['format'] as String,
      fileSize: json['fileSize'] as int,
      downloadDate: DateTime.parse(json['downloadDate'] as String),
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  // Helper methods
  String get formattedSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(downloadDate);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Az önce';
        }
        return '${difference.inMinutes} dakika önce';
      }
      return '${difference.inHours} saat önce';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${downloadDate.day}.${downloadDate.month}.${downloadDate.year}';
    }
  }

  bool get isVideo => type == 'video';
  bool get isAudio => type == 'audio';
}
