This project simulates a simple ant farm with multiple colonies competing for food. By default, the game simulates a Meadow that’s represented as a 15x15 grid, with 4 colonies. Meadow configuration can be changed from the Meadow constructor. 

Simulation starts with 4 queen instances released on the empty meadow, which is a singleton. Every queen picks a random location on the grid to build an ant hill with a strategy randomly chosen from a list of strategies. Once the queen picks a location and a strategy, it uses the AnthillBuilder to easily build the ant hill, it needs.

During every cycle, game places a piece of food on a random cell on the Meadow, then calls Meadow’s processTurn function, which in turn lets Ant objects to take turns, and then the ant hill objects to take turns.

Every ant hill starts with 5 pieces of food, a builder ant, a forager ant, and three randomly chosen ants. Because I didn’t want to change the way ants are produced (which is through the Room objects), I used temporary rooms to create these initial ants. During the game, primary action of an ant hill is to produce ants, if there’s at least 1 piece of food available and there’s a room to build ants. Once a colony reaches the maximum number of ants allowed, its ant hill stops producing ants. 

Ants are built through Room objects, which are built through a RoomFactory. Room factory provides a simple factory method to help build Rooms given an ant type. Given that I have 3 different ants (Builder, Forager, Warrior), I have 3 different rooms (BuilderRoom, ForagerRoom, WarriorRoom).

During ant creation, rooms simply produce an ant by specifying the cell and the ant type, and later modifying the ants processTurn function at the runtime. 

At every turn, Meadow’s processTurn function lets every ant to specify where they want to move using Ant’s getMoveIntent. If the specified direction is not outside the meadow, Meadow moves the Ant object to the right cell. Once ant is moved, it’s allowed to take its turn through calling its processTurn function (which is modified by the Room object). 

Builder ant adds a room to its ant hill by consuming a piece of food and later kills itself. The type of room to build is determined by the hill’s strategy, which is a Strategy object that provides an iterator pattern. As long as there’s a room to build and enough food, builder ants build rooms so the hill can generate new types of ants.

Forager ants walk around the meadow randomly and collect food. For every piece of food they collect, they earn 1 experience. For every 5 experience points, they multiply the number of foods they collect. Formula to calculate the multiplier is: (experience / 5).round with a minimum of 1.

Warrior ant walks around the meadow to find hostile ants or hills. If it finds a hostile warrior, it fights the enemy with a 50% probability, modified by the experience (every experience point adds 0.1%). If it kills the other warrior, it gains 2 experience. If the ant finds a hostile forager, there’s a 50% chance of killing it. If it kills the forager, it gains 2 experience. Otherwise, it gains 1 experience. Finally, if the warrior walks into an ant hill, it can destroy the ant hill with a 20% probability. If it successfully destroys the ant hill, it gains 5 experience.

Once ants take their turns, ant hills are asked to take turns by calling their processTurn. During the ant hill turn, it tries to produce ants by consuming a piece of food at a room in order, going in circles. After an ant is produced at the last room, hill continues with the first room. 

After the turns are processed, game displays the status on the screen by drawing the meadow grid, printing colony stats, and printing major events occurred that turn. To differentiate the different colonies, I use different colors algorithmically selected in the Colors class. I can technically display up to 6 different colonies in colors. Ants and hills are represented on the grid as the characters below, in different colors. While drawing the game grid, I assume that there’s enough space on the terminal window. I calculate the cell size and center the text for every cell.

Characters:

^ Hill
f Food
B Builder
F Forager
W Warrior