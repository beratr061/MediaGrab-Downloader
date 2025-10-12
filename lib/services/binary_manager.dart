import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class BinaryManager {
  static const String _ytdlpAssetPath = 'assets/binaries';
  static String? _ytdlpPath;
  static String? _ffmpegPath;
  static String? _ffprobePath;

  /// Initialize and extract binaries to app directory
  static Future<void> initialize() async {
    final appDir = await getApplicationSupportDirectory();
    final binDir = Directory(path.join(appDir.path, 'bin'));
    
    if (!await binDir.exists()) {
      await binDir.create(recursive: true);
    }

    await _extractBinaries(binDir);
  }

  static Future<void> _extractBinaries(Directory binDir) async {
    final platform = _getPlatformName();
    
    try {
      // Extract yt-dlp
      final ytdlpAsset = '$_ytdlpAssetPath/$platform/yt-dlp${_getExecutableExtension()}';
      final ytdlpFile = File(path.join(binDir.path, 'yt-dlp${_getExecutableExtension()}'));
      
      if (!await ytdlpFile.exists()) {
        final data = await rootBundle.load(ytdlpAsset);
        await ytdlpFile.writeAsBytes(data.buffer.asUint8List());
        
        if (!Platform.isWindows) {
          await Process.run('chmod', ['+x', ytdlpFile.path]);
        }
      }
      _ytdlpPath = ytdlpFile.path;

      // Extract FFmpeg
      final ffmpegAsset = '$_ytdlpAssetPath/$platform/ffmpeg${_getExecutableExtension()}';
      final ffmpegFile = File(path.join(binDir.path, 'ffmpeg${_getExecutableExtension()}'));
      
      if (!await ffmpegFile.exists()) {
        final data = await rootBundle.load(ffmpegAsset);
        await ffmpegFile.writeAsBytes(data.buffer.asUint8List());
        
        if (!Platform.isWindows) {
          await Process.run('chmod', ['+x', ffmpegFile.path]);
        }
      }
      _ffmpegPath = ffmpegFile.path;

      // Extract FFprobe
      final ffprobeAsset = '$_ytdlpAssetPath/$platform/ffprobe${_getExecutableExtension()}';
      final ffprobeFile = File(path.join(binDir.path, 'ffprobe${_getExecutableExtension()}'));
      
      if (!await ffprobeFile.exists()) {
        final data = await rootBundle.load(ffprobeAsset);
        await ffprobeFile.writeAsBytes(data.buffer.asUint8List());
        
        if (!Platform.isWindows) {
          await Process.run('chmod', ['+x', ffprobeFile.path]);
        }
      }
      _ffprobePath = ffprobeFile.path;
      
    } catch (e) {
      // Fallback to system binaries
      _ytdlpPath = 'yt-dlp';
      _ffmpegPath = 'ffmpeg';
      _ffprobePath = 'ffprobe';
    }
  }

  static String _getPlatformName() {
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    throw UnsupportedError('Unsupported platform: Only Windows, macOS, and Linux are supported');
  }

  static String _getExecutableExtension() {
    return Platform.isWindows ? '.exe' : '';
  }

  /// Get yt-dlp executable path
  static String get ytdlpPath {
    if (_ytdlpPath == null) {
      throw StateError('BinaryManager not initialized. Call initialize() first.');
    }
    return _ytdlpPath!;
  }

  /// Get FFmpeg executable path
  static String get ffmpegPath {
    if (_ffmpegPath == null) {
      throw StateError('BinaryManager not initialized. Call initialize() first.');
    }
    return _ffmpegPath!;
  }

  /// Get FFprobe executable path
  static String get ffprobePath {
    if (_ffprobePath == null) {
      throw StateError('BinaryManager not initialized. Call initialize() first.');
    }
    return _ffprobePath!;
  }

  /// Check if binaries are available
  static Future<bool> checkBinaries() async {
    try {
      // Check yt-dlp
      final ytdlpResult = await Process.run(_ytdlpPath ?? 'yt-dlp', ['--version']);
      if (ytdlpResult.exitCode != 0) return false;

      // Check FFmpeg
      final ffmpegResult = await Process.run(_ffmpegPath ?? 'ffmpeg', ['-version']);
      if (ffmpegResult.exitCode != 0) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get yt-dlp version
  static Future<String?> getYtDlpVersion() async {
    try {
      final result = await Process.run(_ytdlpPath ?? 'yt-dlp', ['--version']);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (e) {
      print('Error getting yt-dlp version: $e');
    }
    return null;
  }

  /// Get FFmpeg version
  static Future<String?> getFFmpegVersion() async {
    try {
      final result = await Process.run(_ffmpegPath ?? 'ffmpeg', ['-version']);
      if (result.exitCode == 0) {
        final output = result.stdout.toString();
        final match = RegExp(r'ffmpeg version ([\d.]+)').firstMatch(output);
        return match?.group(1);
      }
    } catch (e) {
      print('Error getting FFmpeg version: $e');
    }
    return null;
  }

  /// Clean up old binaries
  static Future<void> cleanup() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final binDir = Directory(path.join(appDir.path, 'bin'));
      
      if (await binDir.exists()) {
        await binDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error cleaning up binaries: $e');
    }
  }
}
