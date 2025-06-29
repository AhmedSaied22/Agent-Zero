# ElGassos (Agent Zero)

**Important Note:** This project is just a simple game developed as an educational task in one day using the MVVM + CUBIT pattern. The project is considered a simple work and not an example of complete production applications.

## Game Overview

"ElGassos" is an Arabic version of the popular social deduction game known as "Spyfall". The game revolves around a group of players where one (or more) is assigned as a spy, while the rest of the players know a specific location or topic.

### How to Play

1. Set up the game by specifying the number of players (3-12), number of spies (1-6), and game duration in minutes.
2. Roles are randomly assigned, where each regular player knows the shared topic, while the spy doesn't.
3. Players take turns asking questions to each other, trying to:
   - If you're a regular player: Discover who the spy is without clearly revealing the shared topic.
   - If you're the spy: Try to figure out the shared topic without being exposed.
4. After the time ends or during voting, the spy's identity is revealed.

### Game Rules

- No more than two consecutive questions can be directed to the same player.
- The spy tries to figure out the location through questions and answers.
- If someone suspects a player, they can suggest their name for voting.
- During voting, if the majority agrees, the player is revealed.
- If they're innocent, the game continues. If they're the spy, the round ends.
- The spy can interrupt the game at any time to try to guess the location.
- If the spy succeeds in guessing, they win! If they fail, they lose immediately.

### Game Categories

The game includes several different categories:
- Jobs (Doctor, Engineer, Teacher, ...)
- Countries (Egypt, Saudi Arabia, UAE, ...)
- Famous Places (Eiffel Tower, Pyramids, Burj Khalifa, ...)
- Public Places (Airport, Hospital, School, ...)
- Foods (Foul, Falafel, Burger, ...)
- Football Players (Mohamed Salah, Messi, Ronaldo, ...)

## Technologies Used

- Flutter for the interface
- Cubit for state management
- Shared Preferences for storing game data

## Getting Started

This project is a starting point for a Flutter application.

For help getting started with Flutter, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.