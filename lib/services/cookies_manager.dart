import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

class CookiesManager {
  static String? _cookiesPath;

  /// Initialize cookies from assets
  static Future<void> initialize() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final cookiesDir = Directory(path.join(appDir.path, 'cookies'));
      
      if (!await cookiesDir.exists()) {
        await cookiesDir.create(recursive: true);
      }

      final cookiesFile = File(path.join(cookiesDir.path, 'cookies.txt'));
      
      // Copy default cookies from assets if not exists
      if (!await cookiesFile.exists()) {
        try {
          final data = await rootBundle.load('assets/cookies/cookies.txt');
          await cookiesFile.writeAsBytes(data.buffer.asUint8List());
          print('✅ Default cookies loaded from assets');
        } catch (e) {
          print('⚠️ No default cookies found in assets: $e');
        }
      }
      
      _cookiesPath = cookiesFile.path;
      print('✅ Cookies initialized: $_cookiesPath');
    } catch (e) {
      print('⚠️ Failed to initialize cookies: $e');
    }
  }

  /// Get cookies file path
  static String? get cookiesPath => _cookiesPath;

  /// Check if cookies file exists
  static Future<bool> hasCookies() async {
    if (_cookiesPath == null) return false;
    return await File(_cookiesPath!).exists();
  }

  /// Import cookies from file picker
  static Future<bool> importCookies() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        dialogTitle: 'Select cookies.txt file',
      );

      if (result != null && result.files.single.path != null) {
        final sourcePath = result.files.single.path!;
        final sourceFile = File(sourcePath);
        
        if (await sourceFile.exists()) {
          final appDir = await getApplicationSupportDirectory();
          final cookiesFile = File(path.join(appDir.path, 'cookies', 'cookies.txt'));
          
          // Copy file
          await sourceFile.copy(cookiesFile.path);
          _cookiesPath = cookiesFile.path;
          
          print('✅ Cookies imported successfully');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Failed to import cookies: $e');
      return false;
    }
  }

  /// Export cookies to user-selected location
  static Future<bool> exportCookies() async {
    try {
      if (_cookiesPath == null || !await File(_cookiesPath!).exists()) {
        return false;
      }

      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save cookies.txt',
        fileName: 'cookies.txt',
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (outputPath != null) {
        final sourceFile = File(_cookiesPath!);
        await sourceFile.copy(outputPath);
        print('✅ Cookies exported successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Failed to export cookies: $e');
      return false;
    }
  }

  /// Update cookies content
  static Future<bool> updateCookies(String content) async {
    try {
      if (_cookiesPath == null) {
        await initialize();
      }
      
      if (_cookiesPath != null) {
        final cookiesFile = File(_cookiesPath!);
        await cookiesFile.writeAsString(content);
        print('✅ Cookies updated successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Failed to update cookies: $e');
      return false;
    }
  }

  /// Read cookies content
  static Future<String?> readCookies() async {
    try {
      if (_cookiesPath == null || !await File(_cookiesPath!).exists()) {
        return null;
      }
      
      final cookiesFile = File(_cookiesPath!);
      return await cookiesFile.readAsString();
    } catch (e) {
      print('❌ Failed to read cookies: $e');
      return null;
    }
  }

  /// Delete cookies file
  static Future<bool> deleteCookies() async {
    try {
      if (_cookiesPath != null && await File(_cookiesPath!).exists()) {
        await File(_cookiesPath!).delete();
        print('✅ Cookies deleted successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Failed to delete cookies: $e');
      return false;
    }
  }

  /// Get cookies info
  static Future<Map<String, dynamic>> getCookiesInfo() async {
    try {
      if (_cookiesPath == null || !await File(_cookiesPath!).exists()) {
        return {
          'exists': false,
          'path': null,
          'size': 0,
          'lastModified': null,
        };
      }

      final cookiesFile = File(_cookiesPath!);
      final stat = await cookiesFile.stat();
      final content = await cookiesFile.readAsString();
      final lines = content.split('\n').where((line) => 
        line.trim().isNotEmpty && !line.trim().startsWith('#')
      ).length;

      return {
        'exists': true,
        'path': _cookiesPath,
        'size': stat.size,
        'lastModified': stat.modified,
        'cookieCount': lines,
      };
    } catch (e) {
      print('❌ Failed to get cookies info: $e');
      return {
        'exists': false,
        'path': null,
        'size': 0,
        'lastModified': null,
      };
    }
  }

  /// Validate cookies format
  static Future<bool> validateCookies() async {
    try {
      final content = await readCookies();
      if (content == null) return false;

      // Check for Netscape format header
      if (!content.contains('# Netscape HTTP Cookie File')) {
        return false;
      }

      // Check if there are any valid cookie lines
      final lines = content.split('\n');
      final validLines = lines.where((line) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) return false;
        
        // Cookie line should have 7 fields separated by tabs
        final fields = trimmed.split('\t');
        return fields.length >= 7;
      });

      return validLines.isNotEmpty;
    } catch (e) {
      print('❌ Failed to validate cookies: $e');
      return false;
    }
  }
}
