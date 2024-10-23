# scream-jam-2024
[itch.io page](https://zerochubs.itch.io/scariatrics)

## Credits
- Eugene Mak (game design, programming)
- Febduni (art)
- Ibrahima Keita (game design, music, programming)
- Kyler Schulz (game design, music, programming)
- Miranda Zhang (art, game design)
- Nikita Singh (art, game design)
- Pablo Castilla (game design)
- Yi Wei (game design, programming)
- Yuval Shechter (art, game design, voice acting)

## Internal documentation

Every weapon hitbox should have a `get_damage` method that returns the amount of damage the weapon should do to the enemy. The enemy's hurtbox should call this method to modify its health. See the `cane_hitbox.gd` and `enemy.gd` for an idea of this relationship.
