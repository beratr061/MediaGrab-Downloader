import sys
import os
import tkinter as tk
from tkinter import messagebox
import threading
import subprocess

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

def start_download():
    download_thread = threading.Thread(target=download_video_with_yt_dlp)
    download_thread.start()

def download_video_with_yt_dlp():
    url = url_entry.get()
    download_choice = choice_var.get()

    if not url:
        messagebox.showerror("Hata", "Lütfen bir URL girin.")
        return

    try:
        status_label.config(text="İşlem hazırlanıyor, lütfen bekleyin...")
        for btn in choice_buttons:
            btn.config(state=tk.DISABLED)
        download_button.config(state=tk.DISABLED)
        
        safe_filename_flag = "--restrict-filenames"
        command = ["yt-dlp", safe_filename_flag]

        if download_choice == "video_audio":
            status_label.config(text="En iyi video ve ses indiriliyor/birleştiriliyor...")
            command.extend(["-f", "bestvideo+bestaudio/best", "--merge-output-format", "mp4", "-o", "%(title)s.%(ext)s", url])
        elif download_choice == "audio_mp3":
            status_label.config(text="Yüksek kaliteli ses MP3 olarak indiriliyor...")
            command.extend(["-f", "bestaudio/best", "-x", "--audio-format", "mp3", "--audio-quality", "0", "-o", "%(title)s.%(ext)s", url])
        elif download_choice == "audio_original":
            status_label.config(text="Orijinal ses dosyası (Maks. Kalite) ayıklanıyor...")
            command.extend(["-f", "bestaudio/best", "-x", "--audio-format", "m4a", "-o", "%(title)s.%(ext)s", url])
        elif download_choice == "video_only":
            status_label.config(text="En iyi kalitede sadece video indiriliyor...")
            command.extend(["-f", "bestvideo/best", "-o", "%(title)s.%(ext)s", url])

        startupinfo = subprocess.STARTUPINFO()
        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        
        process = subprocess.run(command, check=True, capture_output=True, text=True, encoding='utf-8', startupinfo=startupinfo)
        
        messagebox.showinfo("Başarılı", f"İndirme başarıyla tamamlandı!")

    except subprocess.CalledProcessError as e:
        error_message = e.stderr or str(e)
        messagebox.showerror("Hata", f"yt-dlp bir hata verdi:\n\n{error_message[:500]}")
    except Exception as e:
        messagebox.showerror("Hata", f"Beklenmedik bir hata oluştu: {e}")
    finally:
        status_label.config(text="İndirmek için URL girin ve bir seçenek belirleyin.")
        url_entry.delete(0, tk.END)
        for btn in choice_buttons:
            btn.config(state=tk.NORMAL)
        download_button.config(state=tk.NORMAL)

window = tk.Tk()
window.title("MediaGrab v1.0")

try:
    icon_path = resource_path("logo.ico")
    window.iconbitmap(icon_path)
except Exception:
    print("İkon dosyası (logo.ico) bulunamadı veya yüklenemedi.")

window.geometry("600x200")

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

download_button = tk.Button(window, text="İndir", font=("Arial", 14, "bold"), command=start_download, bg="#4CAF50", fg="white")
download_button.pack(pady=15, ipadx=20, ipady=5)

status_label = tk.Label(window, text="İndirmek için URL girin ve bir seçenek belirleyin.", font=("Arial", 10))
status_label.pack(pady=5)

window.mainloop()