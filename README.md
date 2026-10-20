# CrossCross
CrossCross is a 2D endless runner developed for Hack Club's Shiba Arcade event! You're an office worker trying to cross the street to get to work but along the way you need to avoid colliding with other people.
Once you collide with someone, you will enter into dialogue with them. The catch is: you're not guaranteed to know their language, so try your best to answer with the culturally appropriate response. As you play, you'll get better at memorizing answers.
Or you could just get really good at the game and never collide with anyone!

## Gameplay

## Technical Highlights
- **Godot Resource Modularity**: I made the addition of content modular! All characters, in-game collectibles, environmental obstacles, animals, etc are Godot text resources (and their own classes respectively). They are controlled in the game using singular template scripts that draw from the .tres files!
- **Difficulty Scaling**: The speed of the camera going up and characters going down is scaled by a regular exponential growth rate function. The enemy spawning cooldown is shortened by a half life function. Both functions are below.


| Speed Scaling | Cooldown Reduction |
| --- | --- |
| <img width="363" height="219" alt="Screenshot 2026-10-20 at 09 39 34" src="https://github.com/user-attachments/assets/005f7a0c-00d5-416a-ae94-488f2e6c7fd2" /> | <img width="362" height="145" alt="Screenshot 2026-10-20 at 09 38 52" src="https://github.com/user-attachments/assets/860d805d-207c-4997-87c2-cf188eddf8c1" /> |
| <img width="634" height="342" alt="Screenshot 2026-10-20 at 09 33 41" src="https://github.com/user-attachments/assets/0147bb7f-9b88-4df4-946e-ca3992195d0e" /> | <img width="810" height="220" alt="Screenshot 2026-10-20 at 09 38 04" src="https://github.com/user-attachments/assets/3305e892-67db-4b3f-9b8a-dcb6ad943222" />|

