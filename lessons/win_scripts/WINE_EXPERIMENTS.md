# Experiments in WINE

## macOS


### Install 

```bash
# install wine
brew install --cask wine-stable
# setup wine data
ln -s "/Applications/Wine Stable.app/Contents/Resources/wine/share/wine" /usr/local/share/wine
ln -s "/Applications/Wine Stable.app/Contents/Resources/wine/lib/wine" /usr/local/lib/wine
```

### Wine Server

If you run a Wine Server in the background, this will speed up executing any scripts. Without the server, running a small batch file will require bringing the whole emulator stack every time a script is launched. 

```bash
# Run Server
wineserver -p &
# Verify Process is running
ps aux | grep wineserver
```

### Running Scripts

```bash
# quiet noisy output when running scripts
export MVK_CONFIG_LOG_LEVEL=0
export WINEDEBUG=-all

# run batch file
cd lessons/win_scripts/batch/scripts
wine cmd /c a00.output.cmd

# run VBSCript 
cd lessons/win_scripts/wsh.vbscript/scripts
wine cscript //Nologo a00.output.vbs

# run JSscript
cd lessons/win_scripts/wsh.jscript/scripts
wine cscript //Nologo a00.output.js
```

### Stop Wine Server

If the Wine Server is no longer needed, you can run this:

```bash
winserver -k
```

### For a list of applications

```bash
ls "/Applications/Wine Stable.app/Contents/Resources/wine/lib/wine/x86_64-windows/" | grep '\.exe$' | column
```