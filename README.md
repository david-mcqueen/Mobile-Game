# Mobile-Game (Head Jump)
Head Jump is a working title, and is likely to change.

This is an iOS (and Android) game created using SpriteBuilder & Swift. Being my first game, there will likely be a lot of modifications as the development process continues.

# Spec
The basic spec is;
- Vertical scroller 2D game
- The Hero (player character) is a bird body
- The player will take a self portrait photo, which will form the head of the in game hero (player head on the bird body)
- The player starts on the ground, and jumps as high as they can
  - They get 3 jumps before they have to land on a object again
  - Planes pass across the screen, which provide a platform for the user to land on
  - If they land on a plane, the 3 jumps counter resets
  - The plane is 'flying' so the user can be taken off the edge of the screen if they stay on the plane too long
    - This will cause the player to die
  - As the user jumps, the camera follows them (upwards)
    - About 30% of the screen will always be below the player
    - The camera cannot scroll down
    - If the user falls off the bottom of the view, they die
- As the user climbs the game, ballons will be present which indicate their friends high scores
  - A balloon, with the users (friends) photo dangling below the balloon
    - Green balloons indicate a friend that has been passed already
    - Red balloons indicate a friend that has NOT been passed already
  - When the user passes a friends balloon, it pop's (and falls)
    - The other player receives a notification "Your friend X has just beat your high score"
