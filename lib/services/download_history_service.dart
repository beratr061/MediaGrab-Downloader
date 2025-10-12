import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/download_history_item.dart';

class DownloadHistoryService {
  static const String _historyKey = 'download_history';
  static const int _maxHistoryItems = 100;

  /// Get all history items
  Future<List<DownloadHistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      return historyJson
          .map((json) => DownloadHistoryItem.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.downloadDate.compareTo(a.downloadDate));
    } catch (e) {
      print('Error loading history: $e');
      return [];
    }
  }

  /// Add new item to history
  Future<void> addToHistory(DownloadHistoryItem item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();
      
      // Add new item at the beginning
      history.insert(0, item);
      
      // Keep only last N items
      if (history.length > _maxHistoryItems) {
        history.removeRange(_maxHistoryItems, history.length);
      }
      
      // Save to SharedPreferences
      final historyJson = history.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error adding to history: $e');
    }
  }

  /// Remove item from history
  Future<void> removeFromHistory(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();
      
      history.removeWhere((item) => item.id == id);
      
      final historyJson = history.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error removing from history: $e');
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  /// Delete file and remove from history
  Future<bool> deleteFile(DownloadHistoryItem item) async {
    try {
      final file = File(item.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      await removeFromHistory(item.id);
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  /// Check if file still exists
  Future<bool> fileExists(String filePath) async {
    try {
      return await File(filePath).exists();
    } catch (e) {
      return false;
    }
  }

  /// Get history statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final history = await getHistory();
    
    int totalVideos = 0;
    int totalAudios = 0;
    int totalSize = 0;
    
    for (var item in history) {
      if (item.isVideo) {
        totalVideos++;
      } else {
        totalAudios++;
      }
      totalSize += item.fileSize;
    }
    
    return {
      'totalItems': history.length,
      'totalVideos': totalVideos,
      'totalAudios': totalAudios,
      'totalSize': totalSize,
    };
  }
}
