@echo off
echo ------------------------------------------------------
echo 	Title	: AD's Setting git clone batch
echo 	Author	: An, Hyungjun
echo 	E-mal	: hyungjun0429@gmail.com
echo ------------------------------------------------------
echo.

mkdir library
cd library

git clone https://github.com/HyungjunAn/HyungjunAn.github.io.git blog
cd blog
git config user.email hyungjun0429@gmail.com
git config user.name hyungjun_an
cd ..

git clone https://github.com/HyungjunAn/note-english.git
cd note-english
git config user.email hyungjun0429@gmail.com
git config user.name hyungjun_an
cd ..

echo (종료를 원하시면 아무 키나 누르세요...)
pause > nul
