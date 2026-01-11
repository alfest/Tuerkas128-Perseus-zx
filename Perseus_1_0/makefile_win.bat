@echo off

SET "LANG=1"
SET "TAP=perseus.tap"
IF "%1" NEQ "" SET "LANG=%1"
IF "%2" NEQ "" SET "TAP=%2"

::echo LANG=%LANG%, TAP=%TAP%

echo Assembling data block on RAM 2
pasmo --public bank_2_data.asm nul bank_2_data.sym

echo Assembling RAM 5
pasmo --public bank_5.asm bank_5.bin bank_5.sym

echo Assembling RAM 7
pasmo --public bank_7.asm bank_7.bin bank_7.sym

echo Assembling Slow RAM #1
pasmo --public --equ T128_LANGUAGE=%LANG% bank_S1.asm bank_S1.bin bank_S1.sym

echo Assembling Slow RAM #2
pasmo --public bank_S2.asm bank_S2.bin bank_S2.sym

echo Assembling Fast RAM #1
pasmo --public bank_F1.asm bank_F1.bin bank_F1.sym

echo Assembling Fast RAM #2
pasmo --public bank_F2.asm bank_F2.bin bank_F2.sym

echo Assembling RAM 0
pasmo --public bank_0.asm bank_0.bin bank_0.sym

echo Assembling main block on RAM 2
pasmo --public bank_2.asm bank_2.bin bank_2.sym

echo Compressing blocks
for %%f in (bank_*.bin, perseus.scr) do salvador %%f %%f.zx0

powershell -ExecutionPolicy Bypass -file .\makefile_win.ps1

echo Assembling loader
pasmo --public loader.asm loader.bin loader.sym

echo Generating TAP file
GenTape %TAP% basic Perseus 10 loader.bin ^
	data perseus.scr.zx0^
	data bank_5.bin.zx0^
	data bank_0.bin.zx0^
	data bank_7.bin.zx0^
	data bank_S1.bin.zx0^
	data bank_S2.bin.zx0^
	data bank_F1.bin.zx0^
	data bank_F2.bin.zx0^
	data bank_2.bin.zx0
echo.