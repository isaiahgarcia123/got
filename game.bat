@echo off
title KNIGHT MANAGER
color 0a

:: ===== PLAYER DATA =====
set hp=100
set maxhp=100
set gold=50
set potion=2
set sword=1
set dragonhp=150
set phase=1

:menu
cls
echo =============================
echo        KNIGHT MANAGER
echo =============================
echo HP: %hp%/%maxhp%   Gold: %gold%
echo Potions: %potion%
echo.
echo 1 Explore
echo 2 Kingdom
echo 3 Inventory
echo 4 Rest at Castle
echo 5 Save Game
echo 6 Load Game
echo 7 Quit
echo.

set /p choice=Choose:

if "%choice%"=="1" goto explore
if "%choice%"=="2" goto kingdom
if "%choice%"=="3" goto inventory
if "%choice%"=="4" goto rest
if "%choice%"=="5" goto save
if "%choice%"=="6" goto load
if "%choice%"=="7" exit
goto menu


:: ===== REST =====
:rest
cls
echo You rest at the castle...
timeout /t 2 >nul
set hp=%maxhp%
echo HP fully restored!
pause
goto menu


:: ===== MAP =====
:explore
cls
echo =============================
echo           MAP
echo =============================
echo.
echo      [Castle]
echo         |
echo   [Forest]----[Cave]
echo.
echo 1 Forest
echo 2 Dragon Cave
echo 3 Return
echo.

set /p area=Where go?

if "%area%"=="1" goto forest
if "%area%"=="2" goto dragonintro
if "%area%"=="3" goto menu
goto explore


:: ===== FOREST =====
:forest
cls
echo You walk into the forest...
timeout /t 1 >nul
set enemyhp=40
goto fight


:: ===== GENERIC FIGHT =====
:fight
cls
set /a damage=10*sword

echo Enemy HP: %enemyhp%
echo Your HP: %hp%
echo Potions: %potion%
echo.
echo 1 Attack
echo 2 Potion
echo 3 Defend
echo 4 Run
echo.

set /p action=Choose:

if "%action%"=="1" goto attack
if "%action%"=="2" goto heal
if "%action%"=="3" goto defend
if "%action%"=="4" goto run
goto fight


:attack
set /a enemyhp=%enemyhp%-%damage%
echo You strike with your sword!
timeout /t 1 >nul

if %enemyhp% LEQ 0 goto win

set /a hp=%hp%-8
echo Enemy hits you!
timeout /t 1 >nul

if %hp% LEQ 0 goto gameover
goto fight


:defend
echo You brace for attack!
set /a hp=%hp%-3
echo Damage reduced!
pause
goto fight


:run
echo You escape safely!
pause
goto menu


:heal
if %potion% LEQ 0 (
echo No potions!
pause
goto fight
)

set /a potion=%potion%-1
set /a hp=%hp%+25
if %hp% GTR %maxhp% set hp=%maxhp%

echo You drink a potion!
pause
goto fight


:win
echo Enemy defeated!
set /a gold=%gold%+20
echo You gained 20 gold!
pause
goto menu


:: ===== DRAGON =====
:dragonintro
cls
echo You enter the cave...
timeout /t 2 >nul
echo A massive dragon awakens!
pause
goto dragonfight


:dragonfight
cls
echo =====================
echo DRAGON PHASE %phase%
echo =====================
echo Dragon HP: %dragonhp%
echo Your HP: %hp%
echo.
echo 1 Attack
echo 2 Potion
echo 3 Run
echo.

set /p dchoice=Choose:

if "%dchoice%"=="1" goto dragonattack
if "%dchoice%"=="2" goto heal
if "%dchoice%"=="3" goto menu
goto dragonfight


:dragonattack
set /a damage=15*sword
set /a dragonhp=%dragonhp%-%damage%

echo You strike the dragon!
timeout /t 1 >nul

if %dragonhp% LEQ 0 goto dragonphase

set /a hp=%hp%-15
echo Dragon breathes fire!
timeout /t 1 >nul

if %hp% LEQ 0 goto gameover
goto dragonfight


:dragonphase
if "%phase%"=="1" goto phase2
if "%phase%"=="2" goto victory


:phase2
set phase=2
set dragonhp=100

cls
echo THE DRAGON TRANSFORMS!
echo Flames erupt around the cave!
pause
goto dragonfight


:victory
cls
echo =====================
echo YOU SLAIN THE DRAGON
echo =====================
echo The kingdom is saved!
pause
goto menu


:: ===== KINGDOM =====
:kingdom
cls
echo ======================
echo        KINGDOM
echo ======================
echo Gold: %gold%
echo.
echo 1 Buy Potion (20 gold)
echo 2 Upgrade Sword (50 gold)
echo 3 Return
echo.

set /p shop=Choose:

if "%shop%"=="1" goto buypotion
if "%shop%"=="2" goto sword
if "%shop%"=="3" goto menu
goto kingdom


:buypotion
if %gold% LSS 20 (
echo Not enough gold!
pause
goto kingdom
)

set /a gold=%gold%-20
set /a potion=%potion%+1
echo Potion bought!
pause
goto kingdom


:sword
if %gold% LSS 50 (
echo Not enough gold!
pause
goto kingdom
)

set /a gold=%gold%-50
set /a sword=%sword%+1
echo Sword upgraded! Level %sword%
pause
goto kingdom


:: ===== INVENTORY =====
:inventory
cls
echo ========= INVENTORY =========
echo HP: %hp%/%maxhp%
echo Potions: %potion%
echo Sword Level: %sword%
echo Gold: %gold%
pause
goto menu


:: ===== SAVE =====
:save
(
echo hp=%hp%
echo gold=%gold%
echo potion=%potion%
echo sword=%sword%
echo phase=%phase%
echo dragonhp=%dragonhp%
) > savegame.txt

echo Game Saved!
pause
goto menu


:: ===== LOAD =====
:load
if not exist savegame.txt (
echo No save found!
pause
goto menu
)

call savegame.txt
echo Game Loaded!
pause
goto menu


:: ===== GAME OVER =====
:gameover
cls
echo You have fallen...
pause
exit
