@echo off
c:
cd \
cd C:\Program Files (x86)\DOSBox-0.74-3
DOSBox.exe -c "mount c c:\MASM" -c "c:" -c "cd MASM611" -c "cd BIN"-c "ml Practica\main.asm" -c "main.exe"