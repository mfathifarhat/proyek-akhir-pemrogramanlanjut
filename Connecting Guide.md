## 1. Verifikasi Java & SWIPL (Pastikan arsitektur sama sama)

```powershell
# Arsitektur java (amd64 / x86_64)
java -XshowSettings:properties -version 2>&1 | Select-String "os.arch|sun.arch.data.model|java.version"
# Arsitektur SWIPL
swipl --version
# Home directory + lokasi JPL Module (harusnya didalem program files)
swipl -g "current_prolog_flag(home, H), writeln(H), use_module(library(jpl)), halt"
```

## 2. Konfigurasi System / Environment Variable
Di bawah system variable isi
1. Buat SWI_HOME_DIR isinya lokasi directory SWIPL nya (Default C:\Program Files\swipl)
2. Edit 'Path', tambahnin %SWI_HOME_DIR%\bin ama %SWI_HOME_DIR%\lib\jpl.jar

## 3. Cek aktivasi JPL Engine
Jalanin kode TestJPL.java pake command dibawah ini

```powershell
javac -cp ".;C:\Program Files\swipl\lib\jpl.jar" TestJPL.java
java -cp ".;C:\Program Files\swipl\lib\jpl.jar" TestJPL
```

Kalo keluar pesan JPL Initialized! berarti sukses