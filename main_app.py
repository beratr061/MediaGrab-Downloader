import sys
import os
import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
import threading
import subprocess
from pathlib import Path
import queue
import re

LANGUAGES = {
    'en': {"name": "English", "strings": {
        "window_title": "MediaGrab v1.0", "url_label": "Video URL:", "video_audio_option": "Video + Audio",
        "audio_mp3_option": "Audio Only (MP3)", "audio_original_option": "Audio Only (Original)", "video_only_option": "Video Only",
        "cookies_checkbox": "Use browser cookies for sites requiring login", "download_button": "Download",
        "status_initial": "Paste a URL and select an option to begin.", "platforms_link": "Supported Platforms",
        "platforms_window_title": "Supported Platforms",
        "platforms_info": "\nMediaGrab is powered by yt-dlp and supports over 1000 websites. Some of the most popular platforms are listed below:\n\n",
        "platforms_cat_social": "Social Media", "platforms_cat_video": "Video & Streaming Platforms",
        "platforms_cat_extra": "...and hundreds more!", "platforms_close_button": "Close",
        "status_preparing": "Preparing, please wait...", "status_downloading": "Downloading...",
        "msg_success_title": "Success", "msg_success_body": "Download completed successfully!", 
        "msg_error_title": "Error", "msg_error_url": "Please enter a URL.",
        "msg_error_ytdlp": "yt-dlp returned an error:\n\n", "msg_error_unexpected": "An unexpected error occurred: "
    }},
    'tr': {"name": "Türkçe", "strings": {
        "window_title": "MediaGrab v1.0", "url_label": "Video URL'si:",
        "video_audio_option": "Video + Ses", "audio_mp3_option": "Sadece Ses (MP3)",
        "audio_original_option": "Sadece Ses (Orijinal)", "video_only_option": "Sadece Video",
        "cookies_checkbox": "Giriş gerektiren siteler için tarayıcı çerezlerini kullan",
        "download_button": "İndir", "status_initial": "İndirmek için URL girin ve bir seçenek belirleyin.",
        "platforms_link": "Desteklenen Platformlar", "platforms_window_title": "Desteklenen Platformlar",
        "platforms_info": "\nMediaGrab, gücünü yt-dlp kütüphanesinden alır ve 1000'den fazla web sitesini destekler. En popüler platformlardan bazıları aşağıda listelenmiştir:\n\n",
        "platforms_cat_social": "Sosyal Medya", "platforms_cat_video": "Video & Yayın Platformları",
        "platforms_cat_extra": "...ve daha yüzlercesi!", "platforms_close_button": "Kapat",
        "status_preparing": "İşlem hazırlanıyor, lütfen bekleyin...", "status_downloading": "İndiriliyor...",
        "msg_success_title": "Başarılı", "msg_success_body": "İndirme başarıyla tamamlandı!",
        "msg_error_title": "Hata", "msg_error_url": "Lütfen bir URL girin.",
        "msg_error_ytdlp": "yt-dlp bir hata verdi:\n\n", "msg_error_unexpected": "Beklenmedik bir hata oluştu: "
    }},
    'ru': {"name": "Русский", "strings": { "window_title": "MediaGrab v1.0", "url_label": "URL видео:", "video_audio_option": "Видео + Аудио", "audio_mp3_option": "Только Аудио (MP3)", "audio_original_option": "Только Аудио (Оригинал)", "video_only_option": "Только Видео", "cookies_checkbox": "Использовать файлы cookie браузера для сайтов, требующих входа", "download_button": "Скачать", "status_initial": "Вставьте URL и выберите опцию для начала.", "platforms_link": "Поддерживаемые платформы", "platforms_window_title": "Поддерживаемые платформы", "platforms_info": "\nMediaGrab работает на базе yt-dlp и поддерживает более 1000 веб-сайтов. Некоторые из самых популярных платформ перечислены ниже:\n\n", "platforms_cat_social": "Социальные сети", "platforms_cat_video": "Видео и стриминговые платформы", "platforms_cat_extra": "...и сотни других!", "platforms_close_button": "Закрыть", "status_preparing": "Подготовка, пожалуйста, подождите...", "status_downloading": "Загрузка...", "msg_success_title": "Успех", "msg_success_body": "Загрузка успешно завершена!", "msg_error_title": "Ошибка", "msg_error_url": "Пожалуйста, введите URL.", "msg_error_ytdlp": "yt-dlp вернул ошибку:\n\n", "msg_error_unexpected": "Произошла непредвиденная ошибка: " }},
    'hi': {"name": "हिंदी", "strings": { "window_title": "MediaGrab v1.0", "url_label": "वीडियो यूआरएल:", "video_audio_option": "वीडियो + ऑडियो", "audio_mp3_option": "केवल ऑडियो (MP3)", "audio_original_option": "केवल ऑडियो (मूल)", "video_only_option": "केवल वीडियो", "cookies_checkbox": "लॉगिन की आवश्यकता वाली साइटों के लिए ब्राउज़र कुकीज़ का उपयोग करें", "download_button": "डाउनलोड", "status_initial": "शुरू करने के लिए एक यूआरएल पेस्ट करें और एक विकल्प चुनें।", "platforms_link": "समर्थित प्लेटफ़ॉर्म", "platforms_window_title": "समर्थित प्लेटफ़ॉर्म", "platforms_info": "\nमीडियाग्रैब yt-dlp द्वारा संचालित है और 1000 से अधिक वेबसाइटों का समर्थन करता है। कुछ सबसे लोकप्रिय प्लेटफ़ॉर्म नीचे सूचीबद्ध हैं:\n\n", "platforms_cat_social": "सोशल मीडिया", "platforms_cat_video": "वीडियो और स्ट्रीमिंग प्लेटफ़ॉर्म", "platforms_cat_extra": "...और सैकड़ों!", "platforms_close_button": "बंद करें", "status_preparing": "तैयार हो रहा है, कृपया प्रतीक्षा करें...", "status_downloading": "डाउनलोड हो रहा है...", "msg_success_title": "सफलता", "msg_success_body": "डाउनलोड सफलतापूर्वक पूरा हुआ!", "msg_error_title": "त्रुटि", "msg_error_url": "कृपया एक यूआरएल दर्ज करें।", "msg_error_ytdlp": "yt-dlp ने एक त्रुटि दी:\n\n", "msg_error_unexpected": "एक अप्रत्याशित त्रुटि हुई: " }},
    'zh': {"name": "中文", "strings": { "window_title": "MediaGrab v1.0", "url_label": "视频网址:", "video_audio_option": "视频 + 音频", "audio_mp3_option": "仅音频 (MP3)", "audio_original_option": "仅音频 (原始)", "video_only_option": "仅视频", "cookies_checkbox": "对需要登录的网站使用浏览器Cookie", "download_button": "下载", "status_initial": "粘贴URL并选择一个选项以开始。", "platforms_link": "支持的平台", "platforms_window_title": "支持的平台", "platforms_info": "\nMediaGrab由yt-dlp强力驱动，支持超过1000个网站。下面列出了一些最受欢迎的平台：\n\n", "platforms_cat_social": "社交媒体", "platforms_cat_video": "视频和直播平台", "platforms_cat_extra": "...以及数百个其他网站！", "platforms_close_button": "关闭", "status_preparing": "准备中，请稍候...", "status_downloading": "下载中...", "msg_success_title": "成功", "msg_success_body": "下载成功完成！", "msg_error_title": "错误", "msg_error_url": "请输入一个URL。", "msg_error_ytdlp": "yt-dlp返回一个错误：\n\n", "msg_error_unexpected": "发生意外错误：" }}
}
LANG = LANGUAGES['en']['strings']
LANG_MAP = {lang_data["name"]: code for code, lang_data in LANGUAGES.items()}

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

def change_language(event=None):
    selected_lang_name = lang_var.get()
    lang_code = LANG_MAP[selected_lang_name]
    global LANG
    LANG = LANGUAGES[lang_code]['strings']
    window.title(LANG["window_title"])
    url_label.config(text=LANG["url_label"])
    choice_buttons[0].config(text=LANG["video_audio_option"])
    choice_buttons[1].config(text=LANG["audio_mp3_option"])
    choice_buttons[2].config(text=LANG["audio_original_option"])
    choice_buttons[3].config(text=LANG["video_only_option"])
    cookies_checkbox.config(text=LANG["cookies_checkbox"])
    download_button.config(text=LANG["download_button"])
    status_label.config(text=LANG["status_initial"])
    platforms_link.config(text=LANG["platforms_link"])
    
def show_supported_platforms():
    platforms_window = tk.Toplevel(window)
    platforms_window.title(LANG["platforms_window_title"])
    platforms_window.geometry("450x400")
    platforms_window.resizable(False, False)
    platforms_window.transient(window)
    try:
        platforms_window.iconbitmap(icon_path)
    except Exception: pass
    platforms_window.grab_set()
    main_frame = tk.Frame(platforms_window, padx=10, pady=10)
    main_frame.pack(expand=True, fill='both')
    text_area = tk.Text(main_frame, wrap='word', font=("Arial", 10), relief="flat", bg=platforms_window.cget('bg'))
    scrollbar = tk.Scrollbar(main_frame, command=text_area.yview)
    text_area.configure(yscrollcommand=scrollbar.set)
    scrollbar.pack(side='right', fill='y')
    text_area.pack(side='left', expand=True, fill='both')
    platforms_text = LANG["platforms_info"] + f"**{LANG['platforms_cat_social']}**\n" + "• YouTube (Shorts, Music, Live Streams included)\n• TikTok\n• Instagram (Reels, Videos)\n• Twitter (X)\n• Facebook (Videos, Reels)\n• Reddit\n\n" + f"**{LANG['platforms_cat_video']}**\n" + "• Twitch (Clips, VODs)\n• Kick\n• Vimeo\n• Dailymotion\n• SoundCloud\n• Bandcamp\n• Bilibili\n• TED\n\n" + LANG['platforms_cat_extra']
    text_area.insert('1.0', platforms_text)
    text_area.tag_configure("bold", font=("Arial", 11, "bold"))
    text_area.tag_add("bold", "1.0", "end")
    text_area.config(state="disabled")
    close_button = tk.Button(platforms_window, text=LANG["platforms_close_button"], command=platforms_window.destroy, width=10)
    close_button.pack(pady=10)

def start_download():
    progress_queue = queue.Queue()
    progress_bar['value'] = 0
    
    download_thread = threading.Thread(target=download_video_with_yt_dlp, args=(progress_queue,))
    download_thread.start()
    
    window.after(100, check_queue, progress_queue)

def check_queue(progress_queue):
    try:
        message = progress_queue.get_nowait()
        if isinstance(message, int):
            progress_bar['value'] = message
            status_label.config(text=f'{LANG["status_downloading"]} {message}%')
            window.after(100, check_queue, progress_queue)
        elif message == "done":
            progress_bar['value'] = 100
            status_label.config(text=LANG["status_initial"])
            messagebox.showinfo(LANG["msg_success_title"], LANG["msg_success_body"])
            reset_ui()
        elif isinstance(message, Exception):
            status_label.config(text=LANG["status_initial"])
            messagebox.showerror(LANG["msg_error_title"], str(message))
            reset_ui()
    except queue.Empty:
        window.after(100, check_queue, progress_queue)

def download_video_with_yt_dlp(progress_queue):
    url = url_entry.get()
    download_choice = choice_var.get()
    use_cookies = use_cookies_var.get()

    if not url:
        progress_queue.put(Exception(LANG["msg_error_url"]))
        return

    try:
        for widget in choice_frame.winfo_children(): widget.config(state=tk.DISABLED)
        cookies_checkbox.config(state=tk.DISABLED)
        download_button.config(state=tk.DISABLED)
        
        downloads_path = str(Path.home() / "Downloads")
        output_template = os.path.join(downloads_path, "%(title)s.%(ext)s")
        
        command = ["yt-dlp", "--progress", "--newline"]

        if use_cookies:
            cookies_file_path = resource_path("cookies.txt")
            command.extend(["--cookies", cookies_file_path])

        if download_choice == "video_audio":
            command.extend(["-f", "bestvideo+bestaudio/best", "--merge-output-format", "mp4", "-o", output_template, url])
        elif download_choice == "audio_mp3":
            command.extend(["-f", "bestaudio/best", "-x", "--audio-format", "mp3", "--audio-quality", "0", "-o", output_template, url])
        elif download_choice == "audio_original":
            command.extend(["-f", "bestaudio/best", "-x", "--audio-format", "m4a", "-o", output_template, url])
        elif download_choice == "video_only":
            command.extend(["-f", "bestaudio/best", "-o", output_template, url])

        startupinfo = subprocess.STARTUPINFO()
        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding='utf-8', startupinfo=startupinfo)
        
        for line in iter(process.stdout.readline, ''):
            match = re.search(r"\[download\]\s+([0-9.]+)%", line)
            if match:
                percentage = float(match.group(1))
                progress_queue.put(int(percentage))
        
        process.wait()

        if process.returncode != 0:
            error_output = process.stderr.read()
            raise subprocess.CalledProcessError(process.returncode, command, stderr=error_output)

        progress_queue.put("done")

    except subprocess.CalledProcessError as e:
        error_message = e.stderr or str(e)
        progress_queue.put(Exception(f'{LANG["msg_error_ytdlp"]}{error_message[:500]}'))
    except Exception as e:
        progress_queue.put(Exception(f'{LANG["msg_error_unexpected"]}{e}'))

def reset_ui():
    url_entry.delete(0, tk.END)
    for widget in choice_frame.winfo_children(): widget.config(state=tk.NORMAL)
    cookies_checkbox.config(state=tk.NORMAL)
    download_button.config(state=tk.NORMAL)

window = tk.Tk()
try:
    icon_path = resource_path("logo.ico")
    window.iconbitmap(icon_path)
except Exception: pass

window.geometry("600x340")
top_frame = tk.Frame(window)
top_frame.pack(fill='x', padx=10, pady=(5,0))
lang_var = tk.StringVar(window)
lang_options = [lang_data["name"] for lang_data in LANGUAGES.values()]
lang_var.set(LANGUAGES['en']['name'])
lang_menu = ttk.OptionMenu(top_frame, lang_var, None, *lang_options, command=change_language)
lang_menu.pack(side='right')
url_frame = tk.Frame(window)
url_frame.pack(pady=5, padx=10, fill='x')
url_label = tk.Label(url_frame, text="", font=("Arial", 12))
url_label.pack(side='left')
url_entry = tk.Entry(url_frame, width=60, font=("Arial", 10))
url_entry.pack(side='left', expand=True, fill='x', padx=(5,0))
choice_frame = tk.Frame(window)
choice_frame.pack(pady=10)
choice_var = tk.StringVar(value="video_audio") 
choice_buttons = [
    tk.Radiobutton(choice_frame, text="", variable=choice_var, value="video_audio", font=("Arial", 10)),
    tk.Radiobutton(choice_frame, text="", variable=choice_var, value="audio_mp3", font=("Arial", 10)),
    tk.Radiobutton(choice_frame, text="", variable=choice_var, value="audio_original", font=("Arial", 10)),
    tk.Radiobutton(choice_frame, text="", variable=choice_var, value="video_only", font=("Arial", 10))
]
for btn in choice_buttons: btn.pack(side='left', padx=5)
cookies_frame = tk.Frame(window)
cookies_frame.pack(pady=5)
use_cookies_var = tk.BooleanVar()
cookies_checkbox = tk.Checkbutton(cookies_frame, text="", variable=use_cookies_var, font=("Arial", 9))
cookies_checkbox.pack()
download_button = tk.Button(window, text="", font=("Arial", 14, "bold"), command=start_download, bg="#4CAF50", fg="white")
download_button.pack(pady=10, ipadx=20, ipady=5)
progress_bar = ttk.Progressbar(window, orient='horizontal', length=400, mode='determinate')
progress_bar.pack(pady=5)
bottom_frame = tk.Frame(window)
bottom_frame.pack(side='bottom', fill='x', padx=10, pady=5)
status_label = tk.Label(bottom_frame, text="", font=("Arial", 10))
status_label.pack(side='left')
platforms_link = tk.Label(bottom_frame, text="", fg="blue", cursor="hand2", font=("Arial", 9, "underline"))
platforms_link.pack(side='right')
platforms_link.bind("<Button-1>", lambda e: show_supported_platforms())

change_language()
window.mainloop()