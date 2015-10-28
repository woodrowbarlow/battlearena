var switch_weapon = scr_pressed_next_weapon(argument0.player_id, false) - 
    scr_pressed_prev_weapon(argument0.player_id, false);
var pressed_attack, held_attack, pressed_special;

argument0.weapon_held += switch_weapon;
argument0.weapon_held %= 5;     // weapon_held ranges from 0 through 4

// if this gun is out of ammo, switch to the next one
var orig_weapon = argument0.weapon_held;
while (argument0.weapon_ammos[argument0.weapon_held] == 0) {
    argument0.weapon_held ++;
    argument0.weapon_held %= 5;
    // in order to prevent an infinite loop if all weapons have no ammo,
    // we only go through one cycle of the weapons before giving up.
    if (argument0.weapon_held == orig_weapon) break;
}

// if weapon_held is not 0, character is holding a weapon
if (argument0.weapon_held > 0) {
    preseed_attack = scr_pressed_fire(argument0.player_id, false);
    held_attack = scr_pressed_fire(argument0.player_id, true);
}
// otherwise, no weapon (basic melee attack)
else {
    pressed_attack = scr_pressed_melee(argument0.player_id, false);
    held_attack = scr_pressed_melee(argument0.player_id, true);
}
pressed_special = scr_pressed_special(argument0.player_id, false);

// if the character is on a ladder, they can't attack, so skip this
// if the attack button isn't being held down, no need to check for attacks
if (!argument0.on_ladder && held_attack > 0 &&
    argument0.weapon_ammos[argument0.weapon_held] != 0) {
    switch (argument0.weapon_held) {
    // melee attack
    case 0:
        break;
    // auto rife
    case 1:
        // deduct one ammo.
        argument0.weapon_ammos[1] --;
        // spawn a bullet and set its speed.
        // TODO: don't spawn a bullet every single frame.
        var bullet = instance_create(argument0.x, argument0.y,
            obj_proj_rifle_bullet);
        bullet.bullet_speed = 2 * argument0.facing_direction;
        break;
    // shotgun
    case 2:
        // for shotgun, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (argument0.pressed_attack == 0) break;
        // shotgun uses 6 bullets per shot, so if the player
        // doesn't have at least that much ammo, terminate.
        if (argument0.weapon_ammos[2] < 6) break;
        // otherwise, go ahead and deduct the ammo.
        argument0.weapon_ammos[2] -= 6;
        // TODO: spawn 6 shotgun bullets in a fan spread
        break;
    // acid gun
    case 3:
        break;
    // seeker rocket
    case 4:
        break;
    // error state
    default:
        // this shouldn't be possible unless a weapon has been added
        // but wasn't added here. log the error and recover.
        show_debug_message("Player " + argument0.player_id +
            " weapon_held variable is invalid (=" + argument0.weapon_held + ").");
        argument0.weapon_held = 0;  // recover
    }
}

// if this gun is out of ammo, switch to the next one
orig_weapon = argument0.weapon_held;
while (argument0.weapon_ammos[argument0.weapon_held] == 0) {
    argument0.weapon_held ++;
    argument0.weapon_held %= 5;
    // in order to prevent an infinite loop if all weapons have no ammo,
    // we only go through one cycle of the weapons before giving up.
    if (argument0.weapon_held == orig_weapon) break;
}
