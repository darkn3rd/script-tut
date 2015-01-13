
* http://gnuwin64.sourceforge.net/
* http://mingw-w64.sourceforge.net/

```


The reader who initially asked the question researched this solution using PowerShell. As you can see it adds a folder called 'runas' under the \Directory\shell.

new-Item Registry::HKEY_CLASSES_ROOT\Directory\shell\runas -Force

new-ItemProperty Registry::HKEY_CLASSES_ROOT\Directory\shell\runas -Name "(default)" -Value "Open Command Prompt as Admin" -Type string -Force

new-ItemProperty Registry::HKEY_CLASSES_ROOT\Directory\shell\runas -Name "Icon" -Value "C:\Windows\System32\imageres.dll,-78" -Type string -Force

new-Item Registry::HKEY_CLASSES_ROOT\Directory\shell\runas\command -Force

new-ItemProperty Registry::HKEY_CLASSES_ROOT\Directory\shell\runas\command -Name "(default)" -Value 'cmd.exe /k pushd %L' -type string -Force
```

* http://www.howtogeek.com/howto/windows-vista/add-run-as-administrator-to-any-file-type-in-windows-vista/
