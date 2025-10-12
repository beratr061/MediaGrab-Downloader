import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/download_option.dart';
import '../models/download_history_item.dart';
import 'binary_manager.dart';
import 'cookies_manager.dart';
import 'download_history_service.dart';

class DownloadService {
  static const platform = MethodChannel('com.mediagrab/downloader');
  final DownloadHistoryService _historyService = DownloadHistoryService();
  
  Stream<double> downloadVideo({
    required String url,
    required DownloadOption option,
    required bool useCookies,
  }) async* {
    try {
      // Get download directory
      final directory = await _getDownloadDirectory();
      
      // Prepare yt-dlp command arguments
      final args = _buildYtDlpArgs(url, option, useCookies, directory);
      
      // Start download process using embedded binary
      final ytdlpPath = BinaryManager.ytdlpPath;
      final result = await Process.start(ytdlpPath, args);
      
      // Listen to stdout for progress
      await for (final line in result.stdout.transform(SystemEncoding().decoder)) {
        final progress = _parseProgress(line);
        if (progress != null) {
          yield progress;
        }
      }
      
      // Check exit code
      final exitCode = await result.exitCode;
      if (exitCode != 0) {
        final error = await result.stderr.transform(SystemEncoding().decoder).join();
        throw Exception('yt-dlp error: $error');
      }
      
      yield 1.0; // Complete
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }
  
  Future<String> _getDownloadDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await getExternalStorageDirectory();
      return directory?.path ?? (await getApplicationDocumentsDirectory()).path;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final directory = await getDownloadsDirectory();
      return directory?.path ?? (await getApplicationDocumentsDirectory()).path;
    }
    return (await getApplicationDocumentsDirectory()).path;
  }
  
  List<String> _buildYtDlpArgs(
    String url,
    DownloadOption option,
    bool useCookies,
    String outputDir,
  ) {
    final args = <String>[
      '--progress',
      '--newline',
      '-o',
      '$outputDir/%(title)s.%(ext)s',
    ];
    
    // Instagram specific: Enable DASH manifest for higher quality
    if (url.contains('instagram.com')) {
      args.addAll(['--extractor-args', 'instagram:no_dash_manifest=false']);
    }
    
    if (useCookies) {
      // Use cookies file if available
      final cookiesPath = CookiesManager.cookiesPath;
      if (cookiesPath != null && File(cookiesPath).existsSync()) {
        args.addAll(['--cookies', cookiesPath]);
      } else {
        // Fallback to browser cookies
        args.addAll(['--cookies-from-browser', 'chrome']);
      }
    }
    
    switch (option) {
      case DownloadOption.videoAudio:
        args.addAll([
          '-f',
          'bestvideo+bestaudio/best',
          '--merge-output-format',
          'mp4',
        ]);
        break;
      case DownloadOption.audioMp3:
        args.addAll([
          '-f',
          'bestaudio/best',
          '-x',
          '--audio-format',
          'mp3',
          '--audio-quality',
          '0',
        ]);
        break;
      case DownloadOption.audioOriginal:
        args.addAll([
          '-f',
          'bestaudio/best',
          '-x',
          '--audio-format',
          'm4a',
        ]);
        break;
      case DownloadOption.videoOnly:
        args.addAll([
          '-f',
          'bestvideo/best',
        ]);
        break;
    }
    
    args.add(url);
    return args;
  }
  
  double? _parseProgress(String line) {
    // Parse yt-dlp progress output
    // Example: [download]  45.2% of 10.50MiB at 1.23MiB/s ETA 00:05
    final regex = RegExp(r'\[download\]\s+(\d+\.?\d*)%');
    final match = regex.firstMatch(line);
    if (match != null) {
      final percentage = double.tryParse(match.group(1) ?? '0');
      return percentage != null ? percentage / 100.0 : null;
    }
    return null;
  }
  
  Future<bool> checkYtDlpInstalled() async {
    return await BinaryManager.checkBinaries();
  }
  
  Future<String?> getYtDlpVersion() async {
    return await BinaryManager.getYtDlpVersion();
  }
  
  Future<String?> getFFmpegVersion() async {
    return await BinaryManager.getFFmpegVersion();
  }
}
