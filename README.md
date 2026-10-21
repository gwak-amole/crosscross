# CrossCross
CrossCross is a 2D endless runner developed for Hack Club's Shiba Arcade event! You're an office worker trying to cross the street to get to work but along the way you need to avoid colliding with other people.
Once you collide with someone, you will enter into dialogue with them. The catch is: you're not guaranteed to know their language, so try your best to answer with the culturally appropriate response. As you play, you'll get better at memorizing answers.
Or you could just get really good at the game and never collide with anyone!

## Gameplay

| | | |
| --- | --- | --- |
|<img width="1440" height="900" alt="Screenshot 2026-10-20 at 11 56 40" src="https://github.com/user-attachments/assets/0702953c-9f54-4a20-b86a-727b90aacc03" /> | <img width="1440" height="900" alt="Screenshot 2026-10-20 at 11 56 55" src="https://github.com/user-attachments/assets/848b488e-dfdb-49b9-b189-3e08b775da93" /> | <img width="1440" height="900" alt="Screenshot 2026-10-20 at 11 57 27" src="https://github.com/user-attachments/assets/f659075e-a4b0-4d55-9ad1-d714820fedde" /> |
| <img width="1440" height="900" alt="Screenshot 2026-10-20 at 11 58 31" src="https://github.com/user-attachments/assets/cbf03334-496d-410f-b6a0-0d24d05bfce4" /> | <img width="577" height="349" alt="Screenshot 2025-09-01 at 20 33 18" src="https://github.com/user-attachments/assets/564a02b6-80f1-4b1a-8be0-e5557d24b6b4" /> | <img width="688" height="464" alt="Screenshot 2026-10-20 at 11 57 58" src="https://github.com/user-attachments/assets/61ef694d-42a6-430c-bcf1-3200b19e5d84" /> |
| <img width="1440" height="900" alt="Screenshot 2026-10-20 at 12 01 38" src="https://github.com/user-attachments/assets/8f117b68-aba0-4163-a1b3-343fc6c1135b" /> | <img width="1420" height="799" alt="Screenshot 2026-10-20 at 12 53 56" src="https://github.com/user-attachments/assets/7e57a951-3efa-44c1-8876-15ed49771921" /> | <img width="1420" height="799" alt="Screenshot 2026-10-20 at 12 54 32" src="https://github.com/user-attachments/assets/9213ee7f-5cec-4c06-a638-463d04fe5908" /> |


## Technical Highlights
- **Godot Resource Modularity**: I made the addition of content modular! All characters, in-game collectibles, environmental obstacles, animals, etc are Godot text resources (and their own classes respectively). They are controlled in the game using singular template scripts that draw from the .tres files!
- **Difficulty Scaling**: The speed of the camera going up and characters going down is scaled by a regular exponential growth rate function. The enemy spawning cooldown is shortened by a half life function. Both functions are below.


| Speed Scaling | Cooldown Reduction |
| --- | --- |
| <img width="363" height="219" alt="Screenshot 2026-10-20 at 09 39 34" src="https://github.com/user-attachments/assets/005f7a0c-00d5-416a-ae94-488f2e6c7fd2" /> | <img width="362" height="145" alt="Screenshot 2026-10-20 at 09 38 52" src="https://github.com/user-attachments/assets/860d805d-207c-4997-87c2-cf188eddf8c1" /> |
| <img width="634" height="342" alt="Screenshot 2026-10-20 at 09 33 41" src="https://github.com/user-attachments/assets/0147bb7f-9b88-4df4-946e-ca3992195d0e" /> | <img width="810" height="220" alt="Screenshot 2026-10-20 at 09 38 04" src="https://github.com/user-attachments/assets/3305e892-67db-4b3f-9b8a-dcb6ad943222" />|

## Play it!
**_PLEASE READ_: Because I wanted to keep the original arcade vibe, MOUSE CLICKS DO NOT WORK and buttons must be navigated through/selected using WASD/arrow keys and the ENTER key**
You can play the game here on itch.io: https://gwak-amole.itch.io/crosscross
- WASD/arrow keys to navigate UI, control character
- ENTER key to confirm
- ESC key to pause the game
Have fun!! :D

## General Credits
- Godot 4.3 Game Engine / GDScript: https://docs.godotengine.org/en/4.3/
- Aseprite for pixel art: https://www.aseprite.org/

## Music Credits
- Thenudo - Heart Beat: https://freesound.org/people/thenudo/sounds/146765/
- LittleRobotSoundFactory - Coins_Single_22.wav: https://freesound.org/people/LittleRobotSoundFactory/sounds/276225/
- TheDweebMan - 8-Bit Wrong 2: https://freesound.org/people/TheDweebMan/sounds/278164/
- Sanaku - Dramatic Camera Zoom: https://freesound.org/people/sanaku/sounds/371882/
- ZenithInfinitiveStudios - Fantasy_ui_Button_6.wav: https://freesound.org/people/ZenithInfinitiveStudios/sounds/376748/
- Sirplus - LightLoop16.wav: https://freesound.org/people/sirplus/sounds/391542/
- Breviceps - 8-Bit - Collect sound / Timer / Countdown: https://freesound.org/people/Breviceps/sounds/450614/
- Arnasarnas - hip hop beat 6.wav: https://freesound.org/people/arnasarnas/sounds/467519/
- Plumaudio - Happy Blip: https://freesound.org/people/plumaudio/sounds/488227/
- Mrickey13 - Item Equip: https://freesound.org/people/mrickey13/sounds/518850/
- AbdrTar - Error.mp3: https://freesound.org/people/AbdrTar/sounds/558121/
- Metalfortress - jingle_little_achievement.wav: https://freesound.org/people/metalfortress/sounds/611793/
- Melokacool - Game Over 1: https://freesound.org/people/melokacool/sounds/615453/
- Craigscottuk - Quiz Gameshow Correct Ping 07.mp3: https://freesound.org/people/craigscottuk/sounds/644956/
- SoundDesignForYou - Squelching SFX [04]: https://freesound.org/people/SoundDesignForYou/sounds/649976/
- Code_box - Airport Lounge: https://freesound.org/people/code_box/sounds/651533/
- Mrthenoronha - 8 Bit Game Invencibility Loop.wav: https://freesound.org/people/Mrthenoronha/sounds/653527/
- Josefpres - 8 bit game loop 012 simple mix 4 short 120 bpm.wav: https://freesound.org/people/josefpres/sounds/658340/
- BlondPanda - Short Elevator Music Loop: https://freesound.org/people/BlondPanda/sounds/659889/
- Jrussell_tm - Ambient sound of shops in Japan: https://freesound.org/people/jrussell_tm/sounds/789672/
