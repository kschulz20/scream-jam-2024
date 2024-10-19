# scream-jam-2024
[itch.io page](https://zerochubs.itch.io/scariatrics)

## Internal documentation

Every weapon hitbox should have a `get_damage` method that returns the amount of damage the weapon should do to the enemy. The enemy's hurtbox should call this method to modify its health. See the `cane_hitbox.gd` and `enemy.gd` for an idea of this relationship.