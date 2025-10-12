import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'tr': {
      'app_title': 'MediaGrab',
      'app_subtitle': 'Video & Müzik İndirici',
      'url_label': 'Video URL',
      'url_hint': 'https://youtube.com/watch?v=...',
      'download_options': 'İndirme Seçenekleri',
      'video_audio': 'Video + Ses',
      'video_audio_desc': 'En iyi kalitede video ve ses',
      'audio_mp3': 'Sadece Ses (MP3)',
      'audio_mp3_desc': 'Yüksek kaliteli MP3 formatında',
      'audio_original': 'Sadece Ses (Orijinal)',
      'audio_original_desc': 'Maksimum kalitede orijinal format',
      'video_only': 'Sadece Video',
      'video_only_desc': 'Sessiz video',
      'use_cookies': 'Giriş gerektiren siteler için çerezleri kullan',
      'download': 'İndir',
      'downloading': 'İndiriliyor...',
      'platforms': 'Platformlar',
      'cookies_settings': 'Cookies Ayarları',
      'settings': 'Ayarlar',
      'theme': 'Tema',
      'language': 'Dil',
      'dark_mode': 'Karanlık Mod',
      'light_mode': 'Aydınlık Mod',
      'supported_platforms': 'Desteklenen Platformlar',
      'platforms_count': '1000+ platform destekleniyor',
      'enter_url': 'Lütfen bir URL girin',
      'download_complete': 'İndirme tamamlandı!',
      'download_failed': 'İndirme başarısız',
      'ytdlp_version': 'yt-dlp sürümü',
      'ytdlp_not_installed': 'yt-dlp yüklü değil',
      'queue': 'Kuyruk',
      'history': 'Geçmiş',
      'quality': 'Kalite',
      'preview': 'Önizleme',
      'your_ultimate': 'Nihai',
      'downloader': 'İndirici',
      'free_social_media': 'Ücretsiz Sosyal Medya',
      'description': 'VidDown, videoları anında hızlı ve kolay bir şekilde indirmenizi sağlar. Sorunsuz, kesintisiz eğlence parmaklarınızın ucunda!',
      'insert_link': 'Video bağlantınızı buraya yapıştırın...',
      'supported_platforms_label': 'Desteklenen Platformlar:',
      'format_options': 'Format Seçenekleri',
      'use_cookies_short': 'Çerezleri Kullan',
      'for_private_content': 'Özel içerik için',
      'customize_experience': 'Deneyiminizi özelleştirin',
      'dark_mode_active': 'Karanlık mod aktif',
      'light_mode_active': 'Aydınlık mod aktif',
      'choose_language': 'Tercih ettiğiniz dili seçin',
      'downloads_count': 'indirme',
      'no_downloads': 'Henüz indirme yok',
      'history_description': 'İndirme geçmişiniz burada görünecek',
      'hello': 'Merhaba',
      'guest_user': 'Misafir Kullanıcı',
      'downloads': 'İndirmeler',
      'terms': 'Şartlar',
      'privacy': 'Gizlilik',
      'about': 'Hakkında',
    },
    'en': {
      'app_title': 'MediaGrab',
      'app_subtitle': 'Video & Music Downloader',
      'url_label': 'Video URL',
      'url_hint': 'https://youtube.com/watch?v=...',
      'download_options': 'Download Options',
      'video_audio': 'Video + Audio',
      'video_audio_desc': 'Best quality video and audio',
      'audio_mp3': 'Audio Only (MP3)',
      'audio_mp3_desc': 'High quality MP3 format',
      'audio_original': 'Audio Only (Original)',
      'audio_original_desc': 'Maximum quality original format',
      'video_only': 'Video Only',
      'video_only_desc': 'Silent video',
      'use_cookies': 'Use cookies for sites requiring login',
      'download': 'Download',
      'downloading': 'Downloading...',
      'platforms': 'Platforms',
      'cookies_settings': 'Cookies Settings',
      'settings': 'Settings',
      'theme': 'Theme',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'supported_platforms': 'Supported Platforms',
      'platforms_count': '1000+ platforms supported',
      'enter_url': 'Please enter a URL',
      'download_complete': 'Download completed!',
      'download_failed': 'Download failed',
      'ytdlp_version': 'yt-dlp version',
      'ytdlp_not_installed': 'yt-dlp not installed',
      'queue': 'Queue',
      'history': 'History',
      'quality': 'Quality',
      'preview': 'Preview',
    },
    'ru': {
      'app_title': 'MediaGrab',
      'app_subtitle': 'Загрузчик видео и музыки',
      'url_label': 'URL видео',
      'url_hint': 'https://youtube.com/watch?v=...',
      'download_options': 'Параметры загрузки',
      'video_audio': 'Видео + Аудио',
      'video_audio_desc': 'Лучшее качество видео и аудио',
      'audio_mp3': 'Только аудио (MP3)',
      'audio_mp3_desc': 'Высокое качество MP3',
      'audio_original': 'Только аудио (Оригинал)',
      'audio_original_desc': 'Максимальное качество',
      'video_only': 'Только видео',
      'video_only_desc': 'Видео без звука',
      'use_cookies': 'Использовать cookies для сайтов с авторизацией',
      'download': 'Скачать',
      'downloading': 'Загрузка...',
      'platforms': 'Платформы',
      'cookies_settings': 'Настройки Cookies',
      'settings': 'Настройки',
      'theme': 'Тема',
      'language': 'Язык',
      'dark_mode': 'Темная тема',
      'light_mode': 'Светлая тема',
      'supported_platforms': 'Поддерживаемые платформы',
      'platforms_count': 'Поддерживается 1000+ платформ',
      'enter_url': 'Пожалуйста, введите URL',
      'download_complete': 'Загрузка завершена!',
      'download_failed': 'Ошибка загрузки',
      'ytdlp_version': 'Версия yt-dlp',
      'ytdlp_not_installed': 'yt-dlp не установлен',
      'queue': 'Очередь',
      'history': 'История',
      'quality': 'Качество',
      'preview': 'Предпросмотр',
    },
    'hi': {
      'app_title': 'MediaGrab',
      'app_subtitle': 'वीडियो और संगीत डाउनलोडर',
      'url_label': 'वीडियो URL',
      'url_hint': 'https://youtube.com/watch?v=...',
      'download_options': 'डाउनलोड विकल्प',
      'video_audio': 'वीडियो + ऑडियो',
      'video_audio_desc': 'सर्वोत्तम गुणवत्ता वीडियो और ऑडियो',
      'audio_mp3': 'केवल ऑडियो (MP3)',
      'audio_mp3_desc': 'उच्च गुणवत्ता MP3',
      'audio_original': 'केवल ऑडियो (मूल)',
      'audio_original_desc': 'अधिकतम गुणवत्ता',
      'video_only': 'केवल वीडियो',
      'video_only_desc': 'मूक वीडियो',
      'use_cookies': 'लॉगिन की आवश्यकता वाली साइटों के लिए कुकीज़ का उपयोग करें',
      'download': 'डाउनलोड',
      'downloading': 'डाउनलोड हो रहा है...',
      'platforms': 'प्लेटफ़ॉर्म',
      'cookies_settings': 'कुकीज़ सेटिंग्स',
      'settings': 'सेटिंग्स',
      'theme': 'थीम',
      'language': 'भाषा',
      'dark_mode': 'डार्क मोड',
      'light_mode': 'लाइट मोड',
      'supported_platforms': 'समर्थित प्लेटफ़ॉर्म',
      'platforms_count': '1000+ प्लेटफ़ॉर्म समर्थित',
      'enter_url': 'कृपया एक URL दर्ज करें',
      'download_complete': 'डाउनलोड पूर्ण!',
      'download_failed': 'डाउनलोड विफल',
      'ytdlp_version': 'yt-dlp संस्करण',
      'ytdlp_not_installed': 'yt-dlp स्थापित नहीं है',
      'queue': 'कतार',
      'history': 'इतिहास',
      'quality': 'गुणवत्ता',
      'preview': 'पूर्वावलोकन',
    },
    'zh': {
      'app_title': 'MediaGrab',
      'app_subtitle': '视频和音乐下载器',
      'url_label': '视频网址',
      'url_hint': 'https://youtube.com/watch?v=...',
      'download_options': '下载选项',
      'video_audio': '视频 + 音频',
      'video_audio_desc': '最佳质量视频和音频',
      'audio_mp3': '仅音频 (MP3)',
      'audio_mp3_desc': '高质量MP3',
      'audio_original': '仅音频 (原始)',
      'audio_original_desc': '最高质量',
      'video_only': '仅视频',
      'video_only_desc': '无声视频',
      'use_cookies': '对需要登录的网站使用Cookie',
      'download': '下载',
      'downloading': '下载中...',
      'platforms': '平台',
      'cookies_settings': 'Cookie设置',
      'settings': '设置',
      'theme': '主题',
      'language': '语言',
      'dark_mode': '深色模式',
      'light_mode': '浅色模式',
      'supported_platforms': '支持的平台',
      'platforms_count': '支持1000+平台',
      'enter_url': '请输入网址',
      'download_complete': '下载完成！',
      'download_failed': '下载失败',
      'ytdlp_version': 'yt-dlp版本',
      'ytdlp_not_installed': 'yt-dlp未安装',
      'queue': '队列',
      'history': '历史',
      'quality': '质量',
      'preview': '预览',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String get appTitle => translate('app_title');
  String get appSubtitle => translate('app_subtitle');
  String get urlLabel => translate('url_label');
  String get urlHint => translate('url_hint');
  String get downloadOptions => translate('download_options');
  String get videoAudio => translate('video_audio');
  String get videoAudioDesc => translate('video_audio_desc');
  String get audioMp3 => translate('audio_mp3');
  String get audioMp3Desc => translate('audio_mp3_desc');
  String get audioOriginal => translate('audio_original');
  String get audioOriginalDesc => translate('audio_original_desc');
  String get videoOnly => translate('video_only');
  String get videoOnlyDesc => translate('video_only_desc');
  String get useCookies => translate('use_cookies');
  String get download => translate('download');
  String get downloading => translate('downloading');
  String get platforms => translate('platforms');
  String get cookiesSettings => translate('cookies_settings');
  String get settings => translate('settings');
  String get theme => translate('theme');
  String get language => translate('language');
  String get darkMode => translate('dark_mode');
  String get lightMode => translate('light_mode');
  String get supportedPlatforms => translate('supported_platforms');
  String get platformsCount => translate('platforms_count');
  String get enterUrl => translate('enter_url');
  String get downloadComplete => translate('download_complete');
  String get downloadFailed => translate('download_failed');
  String get ytdlpVersion => translate('ytdlp_version');
  String get ytdlpNotInstalled => translate('ytdlp_not_installed');
  String get queue => translate('queue');
  String get history => translate('history');
  String get quality => translate('quality');
  String get preview => translate('preview');
  String get yourUltimate => translate('your_ultimate');
  String get downloader => translate('downloader');
  String get freeSocialMedia => translate('free_social_media');
  String get description => translate('description');
  String get insertLink => translate('insert_link');
  String get supportedPlatformsLabel => translate('supported_platforms_label');
  String get formatOptions => translate('format_options');
  String get useCookiesShort => translate('use_cookies_short');
  String get forPrivateContent => translate('for_private_content');
  String get customizeExperience => translate('customize_experience');
  String get darkModeActive => translate('dark_mode_active');
  String get lightModeActive => translate('light_mode_active');
  String get chooseLanguage => translate('choose_language');
  String get downloadsCount => translate('downloads_count');
  String get noDownloads => translate('no_downloads');
  String get historyDescription => translate('history_description');
  String get hello => translate('hello');
  String get guestUser => translate('guest_user');
  String get downloads => translate('downloads');
  String get terms => translate('terms');
  String get privacy => translate('privacy');
  String get about => translate('about');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en', 'ru', 'hi', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
