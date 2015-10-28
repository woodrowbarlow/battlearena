///scr_character_weapon_use(character_instance_id)

var switch_weapon = scr_pressed_next_weapon(argument0.player_id, false) - 
    scr_pressed_prev_weapon(argument0.player_id, false);
var pressed_attack = 0, held_attack = 0, pressed_special = 0;

// this is only for debugging purposes, don't use this variable for real game logic
var weapon_names;
weapon_names[0] = "melee attack";
weapon_names[1] = "auto rifle";
weapon_names[2] = "shotgun";
weapon_names[3] = "acid gun";
weapon_names[4] = "seeker rocket";

// this block handles switching weapons
if (switch_weapon != 0) {
    argument0.weapon_held += switch_weapon;
    argument0.weapon_held %= 5;     // weapon_held ranges from 0 through 4
    show_debug_message("player " + string(argument0.player_id) +
        " switching to " + weapon_names[argument0.weapon_held]);
    // if this gun is out of ammo, switch to the next one
    var orig_weapon = argument0.weapon_held;
    while (argument0.weapon_ammos[argument0.weapon_held] == 0) {
        show_debug_message("player " + string(argument0.player_id) + " " +
            weapon_names[argument0.weapon_held] + " is out of ammo.");
        argument0.weapon_held += sign(switch_weapon);
        argument0.weapon_held %= 5;
        show_debug_message("player " + string(argument0.player_id) +
            " switching to " + weapon_names[argument0.weapon_held]);
        // in order to prevent an infinite loop if all weapons have no ammo,
        // we only go through one cycle of the weapons before giving up.
        if (argument0.weapon_held == orig_weapon) {
            // this should never happen since melee attack is -1 (infinite).
            show_debug_message("player " + string(argument0.player_id) +
                " out of ammo in all weapons.");
            argument0.weapon_held = 0;
            show_debug_message("player " + string(argument0.player_id) +
                " switching to melee attack.");
            break;
        }
    }
}

// this block handles getting control input to determine if we need to attack
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

// this block handles the actual firing of the weapon / melee attack
// if the character is on a ladder, they can't attack, so skip this
// if the attack button isn't being held down, skip this
// if character is out of ammo in current weapon, skip this
if (!argument0.on_ladder && held_attack > 0 &&
    argument0.weapon_ammos[argument0.weapon_held] != 0) {
    switch (argument0.weapon_held) {
    // melee attack
    case 0:
        if(pressed_attack == 0) break;
        show_debug_message("player " + string(argument0.player_id) +
            " performing melee attack");
        break;
    // auto rife
    case 1:
        // deduct one ammo.
        argument0.weapon_ammos[1] --;
        // spawn a bullet and set its speed.
        // TODO: don't spawn a bullet every single frame.
        show_debug_message("player " + string(argument0.player_id) +
            " firing auto rifle");
        show_debug_message("auto rifle ammo remaining: " +
            string(argument0.weapon_ammos[1]));
        var bullet = instance_create(argument0.x, argument0.y,
            obj_proj_rifle_bullet);
        bullet.hspeed = 2 * argument0.facing_direction;
        break;
    // shotgun
    case 2:
        // for shotgun, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (pressed_attack == 0) break;
        // shotgun uses 6 bullets per shot, so if the player
        // doesn't have at least that much ammo, terminate.
        if (argument0.weapon_ammos[2] < 6) {
            // this should be impossible since we give ammo packs in
            // multiples of 6, but we need to be sure.
            show_debug_message("player " + string(argument0.player_id) +
                " doesn't have enough ammo to fire the shotgun (=" +
                string(argument0.weapon_ammos[2]));
            break;
        }
        // otherwise, go ahead and deduct the ammo.
        argument0.weapon_ammos[2] -= 6;
        show_debug_message("player " + string(argument0.player_id) +
            " firing shotgun");
        show_debug_message("shotgun ammo remaining: " +
            string(argument0.weapon_ammos[2]));
        // TODO: spawn 6 shotgun bullets in a fan spread
        break;
    // acid gun
    case 3:
        show_debug_message("player " + string(argument0.player_id) +
            " firing acid gun");
        show_debug_message("acid gun not yet implemented");
        break;
    // seeker rocket
    case 4:
        // for seeker rocket, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (pressed_attack == 0) break;
        show_debug_message("player " + string(argument0.player_id) +
            " firing seeker rocket");
        show_debug_message("seeker rocket not yet implemented");
        break;
    // error state
    default:
        // this shouldn't be possible unless a weapon has been added
        // but wasn't added here. log the error and recover.
        show_debug_message("player " + string(argument0.player_id) +
            " weapon_held variable is invalid (=" +
            string(argument0.weapon_held) + ")");
        show_debug_message("player " + string(argument0.player_id) +
            " switching to melee attack.");
        argument0.weapon_held = 0;  // recover
    }
}

// this block handles switching to the next weapon if the last of the
// ammo in the current weapon was used up.
orig_weapon = argument0.weapon_held;
while (argument0.weapon_ammos[argument0.weapon_held] == 0) {
    show_debug_message("player " + string(argument0.player_id) + " " +
        weapon_names[argument0.weapon_held] + " is out of ammo.");
    argument0.weapon_held ++;
    argument0.weapon_held %= 5;
    show_debug_message("player " + string(argument0.player_id) +
        " switching to " + weapon_names[argument0.weapon_held]);
    // in order to prevent an infinite loop if all weapons have no ammo,
    // we only go through one cycle of the weapons before giving up.
    if (argument0.weapon_held == orig_weapon) {
        show_debug_message("player " + string(argument0.player_id) +
            " out of ammo in all weapons.");
        argument0.weapon_held = 0;
        show_debug_message("player " + string(argument0.player_id) +
            " switching to melee attack.");
        break;
    }
}
