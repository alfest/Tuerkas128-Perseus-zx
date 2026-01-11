@echo off
set "VERSION=1.0.1"

echo Building ESP...
call makefile_win 0 perseus_ESP_%VERSION%.tap

echo Building POR...
call makefile_win 2 perseus_POR_%VERSION%.tap

echo Building ENG...
call makefile_win 1 perseus_ENG_%VERSION%.tap
