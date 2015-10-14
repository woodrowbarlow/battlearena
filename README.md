# battlearena

A local multiplayer arena deathmatch platformer game. Two players choose from four characters then choose from one of four arenas to play in. Ranged weapons are scattered throughout the arena. Characters each have unique movement and special attacks.

To see how to download the project, see `DEVELOPING.md`.

## Mechanics

 * Characters start with 100 health and 3 lives. When their health is depleted or they fall off the edge of an arena, they lose one life. When one of the characters loses all three lives, the game is over and the other is declared the winner.
 * Characters can always perform a basic melee, but also begin each life with a small selection of ranged weapons, each with limited ammunition. Additional ammunition, as well as some additional weapons, are scattered around the arena.

## Controls

This game requires at least one XBox360 controller plugged into your PC. If you only have one plugged in, then player one uses the keyboard and player two uses the controller. If you have two plugged in, than player one can use either the keyboard or controller one, and player two uses controller two.

 * **Move**
    * Controller: Joystick or Directional Pad
    * Keyboard: WASD or Arrow keys
 * **Jump**
    * Controller: A button or Up on the Directional Pad
	* Keyboard: W key or Up Arrow key
 * **Melee Attack**
    * Controller: B button or Left Trigger
    * Keyboard: Shift Key
 * **Weapon Attack**
    * Controller: Y button or Right Trigger
    * Keyboard: Spacebar
 * **Special Attack**:
    * Controller: X button or Y button
    * Keyboard: Control key or Tab key
 * **Select Next Weapon**:
    * Controller: Right Bumper
    * Keyboard: E key or F2 key
 * **Select Previous Weapon**:
    * Controller: Left Bumper
    * Keyboard: Q key or F1 key

## Characters

 * **Sallie** the salamander. She is fast. She is capable of a short-distance teleport, allowing her to quickly jump behind an enemy.
    * Stats: 125% movement speed, 2 second special cooldown.
    * Animations: idle, walk, run, standing jump, running jump, climb ladder, basic melee, dazed, teleport.
    * Tapping special while moving causes Sallie to instantaneously teleport horizontally 3 meters. If she was standing still, she is turned the other way when she reappears.
 * **Ruff** the rhinoceros. He is slow, but takes less damage. He can perform a groundpound that stuns nearby enemies, allowing him to get in a few easy shots.
    * Stats: 75% movement speed, 75% damage rate, 150% basic melee strength, 15 second special cooldown.
    * Animations: idle, walk, run, standing jump, running jump, climb ladder, basic melee, dazed, groundpound.
    * Tapping special causes Ruff to stomp the ground with his foot, sending a shockwave out 5 meters radially from his location. Any characters within this radius who are not airborne will be stunned for 2 seconds.
 * **Aerie** the fey. She can fly, and divebombs her enemies.
    * Stats: 150% jump height.
    * Animations: idle, walk, run, standing jump, running jump, climb ladder, basic melee, dazed, divebomb.
    * Tapping jump while in midair gives an additional half-height jump. This can be done up to three times before Aerie needs to land.
    * Tapping special while in midair causes Aerie to dive at a forty-five degree descension. Diving into another character in this manner causes 200% of the standard melee damage.
 * One more character TBD!

## Weapons

 * **Basic Melee** is always available, but you need to be standing right next to your oponnent.
    * Damage per Strike: 8 HP
    * Knockback per Strike: 0.2 meters
    * Cooldown Time: 0.75 seconds
    * Starting Ammunition: Unlimited
 * **Basic Rifle** shoots small balls of energy horizontally.
    * Damage per Strike: 3 HP
    * Knockback per Strike: none
    * Cooldown Time: 0.1 seconds
    * Starting Ammunition: 150
 * **Acid Gun** shoots globs of acid out in an arc which fall downwards, pooling on the ground for a short time.
    * Damage per Strike: 3 HP
    * Knockback per Strike: none
    * Notes: The globs do not go away once they touch an enemy, and continue to do 0.5 HP of damage for each frame that the character is standing in the glob. The globs go away after 4 seconds.
 * **Missile Launcher** shoots slow-moving missles that move towards the nearest enemy.
    * Damage per Strike: 25 HP
    * Knockback per Strike: 1.5 meters
    * Cooldown Time: 2 seconds
    * Starting Ammunition: none
 * More weapons TBD!

## Items

 * **Health Pack** restores 20 HP.
    * Respawn Time: 30 seconds
 * **Basic Rifle Ammunition Pack** provides 100 additional basic rifle ammunition.
    * Respawn Time: 10 seconds
 * **Missile Launcher Ammunition Pack** provides 3 additional missiles.
    * Respawn Time: 45 seconds
 * More items TBD!

## Arenas

 * **The Knoll** is a grassy platformer arena. There are happy flowers that dance in the background, fluffy clouds drift by, and there are cute bubbles in the water. This is the most basic level.
 * **The Station** is a mining base on the moon. There are machines trundling back and forth in the background while computer screens run simulations above you. Gravity here is lower than normal.
 * **The Ruins** is the site of an ancient temple that has since crumbled.
 * One more arena TBD!