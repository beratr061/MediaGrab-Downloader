import sys
import os
import tkinter as tk
from tkinter import messagebox
import threading
import subprocess
import re
import json

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

def sanitize_filename(filename):
    # Windows'ta geçersiz olan karakterleri kaldır ama boşlukları koru
    return re.sub(r'[\\/*?:"<>|]', "", filename)

def start_download():
    download_thread = threading.Thread(target=download_video_with_yt_dlp)
    download_thread.start()

def download_video_with_yt_dlp():
    url = url_entry.get()
    download_choice = choice_var.get()
    use_cookies = use_cookies_var.get()

    if not url:
        messagebox.showerror("Hata", "Lütfen bir URL girin.")
        return

    try:
        status_label.config(text="İşlem hazırlanıyor, lütfen bekleyin...")
        for btn in choice_buttons:
            btn.config(state=tk.DISABLED)
        cookies_checkbox.config(state=tk.DISABLED)
        download_button.config(state=tk.DISABLED)
        
        command = ["yt-dlp"]

        if use_cookies:
            cookies_file_path = resource_path("cookies.txt")
            command.extend(["--cookies", cookies_file_path])

        # --- YENİ DOSYA ADLANDIRMA MANTIĞI ---
        # Önce videoyu ID'si ile indir, sonra başlığına göre yeniden adlandır.
        # --print-json ile videonun bilgilerini (başlık, uzantı vb.) alıyoruz.
        temp_filename_template = "-o", "%(id)s.%(ext)s"
        
        if download_choice == "video_audio":
            status_label.config(text="En iyi video ve ses indiriliyor...")
            command.extend(["-f", "bestvideo+bestaudio/best", "--merge-output-format", "mp4", *temp_filename_template, "--print-json", url])
        elif download_choice == "audio_mp3":
            status_label.config(text="Yüksek kaliteli ses MP3 olarak indiriliyor...")
            command.extend(["-f", "bestaudio/best", "-x", "--audio-format", "mp3", "--audio-quality", "0", *temp_filename_template, "--print-json", url])
        elif download_choice == "audio_original":
            status_label.config(text="Orijinal ses dosyası ayıklanıyor...")
            command.extend(["-f", "bestaudio/best", "-x", "--audio-format", "m4a", *temp_filename_template, "--print-json", url])
        elif download_choice == "video_only":
            status_label.config(text="En iyi kalitede sadece video indiriliyor...")
            command.extend(["-f", "bestvideo/best", *temp_filename_template, "--print-json", url])

        startupinfo = subprocess.STARTUPINFO()
        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        
        process = subprocess.run(command, check=True, capture_output=True, text=True, encoding='utf-8', startupinfo=startupinfo)
        
        # İndirme başarılı, şimdi dosyayı yeniden adlandıralım
        status_label.config(text="Dosya yeniden adlandırılıyor...")
        metadata = json.loads(process.stdout)
        video_title = metadata.get('title', 'indirilen_dosya')
        file_extension = metadata.get('ext', 'mp4')
        
        temp_filename = f"{metadata['id']}.{file_extension}"
        
        # Eğer birleştirme olduysa (MP4), yt-dlp uzantıyı otomatik ayarlar.
        if download_choice == "video_audio":
             temp_filename = f"{metadata['id']}.mp4"
        
        sanitized_title = sanitize_filename(video_title)
        final_filename = f"{sanitized_title}.{file_extension}"
        
        # Eğer birleştirme olduysa, son dosya uzantısı mp4 olmalı
        if download_choice == "video_audio":
            final_filename = f"{sanitized_title}.mp4"

        os.rename(temp_filename, final_filename)
        
        messagebox.showinfo("Başarılı", f"İndirme başarıyla tamamlandı!\n\nDosya Adı: {final_filename}")

    except subprocess.CalledProcessError as e:
        error_message = e.stderr or str(e)
        messagebox.showerror("Hata", f"yt-dlp bir hata verdi:\n\n{error_message[:500]}")
    except FileNotFoundError:
        # Bu hata, yeniden adlandırma sırasında dosya bulunamazsa oluşur.
        messagebox.showerror("Hata", "İndirilen geçici dosya bulunamadı. Lütfen tekrar deneyin.")
    except Exception as e:
        messagebox.showerror("Hata", f"Beklenmedik bir hata oluştu: {e}")
    finally:
        status_label.config(text="İndirmek için URL girin ve bir seçenek belirleyin.")
        url_entry.delete(0, tk.END)
        for btn in choice_buttons:
            btn.config(state=tk.NORMAL)
        cookies_checkbox.config(state=tk.NORMAL)
        download_button.config(state=tk.NORMAL)

window = tk.Tk()
window.title("MediaGrab v1.2 - Estetik")
window.geometry("600x270")

try:
    icon_path = resource_path("logo.ico")
    window.iconbitmap(icon_path)
except Exception:
    print("İkon dosyası (logo.ico) bulunamadı veya yüklenemedi.")

url_frame = tk.Frame(window)
url_frame.pack(pady=10, padx=10, fill='x')
url_label = tk.Label(url_frame, text="Video URL'si:", font=("Arial", 12))
url_label.pack(side='left')
url_entry = tk.Entry(url_frame, width=60, font=("Arial", 10))
url_entry.pack(side='left', expand=True, fill='x', padx=(5,0))

choice_frame = tk.Frame(window)
choice_frame.pack(pady=5)
choice_var = tk.StringVar(value="video_audio") 

choice_buttons = [
    tk.Radiobutton(choice_frame, text="Video + Ses", variable=choice_var, value="video_audio", font=("Arial", 10)),
    tk.Radiobutton(choice_frame, text="Sadece Ses (MP3)", variable=choice_var, value="audio_mp3", font=("Arial", 10)),
    tk.Radiobutton(choice_frame, text="Sadece Ses (Orijinal)", variable=choice_var, value="audio_original", font=("Arial", 10)),
    tk.Radiobutton(choice_frame, text="Sadece Video", variable=choice_var, value="video_only", font=("Arial", 10))
]
for btn in choice_buttons:
    btn.pack(side='left', padx=5)

cookies_frame = tk.Frame(window)
cookies_frame.pack(pady=5)
use_cookies_var = tk.BooleanVar()
cookies_checkbox = tk.Checkbutton(cookies_frame, text="Giriş gerektiren siteler için tarayıcı çerezlerini kullan (Chrome/Firefox vb.)", variable=use_cookies_var, font=("Arial", 9))
cookies_checkbox.pack()

download_button = tk.Button(window, text="İndir", font=("Arial", 14, "bold"), command=start_download, bg="#4CAF50", fg="white")
download_button.pack(pady=15, ipadx=20, ipady=5)

status_label = tk.Label(window, text="İndirmek için URL girin ve bir seçenek belirleyin.", font=("Arial", 10))
status_label.pack(pady=5)

window.mainloop()