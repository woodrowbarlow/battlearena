///scr_character_weapon_use(character_instance_id)

var switch_weapon = scr_pressed_next_weapon(argument0.player_id, false) - 
    scr_pressed_prev_weapon(argument0.player_id, false);
var pressed_attack = scr_pressed_fire(argument0.player_id, false);
var held_attack = scr_pressed_fire(argument0.player_id, true);
var pressed_special = scr_pressed_special(argument0.player_id, false);

// this is only for debugging purposes, don't use this variable for real game logic
var weapon_names;
weapon_names[0] = "melee attack";
weapon_names[1] = "auto rifle";
weapon_names[2] = "shotgun";
weapon_names[3] = "acid gun";
weapon_names[4] = "seeker rocket";

var i;
for (i = 0; i < array_length_1d(argument0.weapon_timers); i++) {
    if (argument0.weapon_timers[i] > 0) {
        argument0.weapon_timers[i]--;
    }
}

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

// this block handles the actual firing of the weapon / melee attack
// if the character is on a ladder, they can't attack, so skip this
// if the attack button isn't being held down, skip this
// if character is out of ammo in current weapon, skip this
if (!argument0.on_ladder && held_attack > 0 &&
    argument0.weapon_ammos[argument0.weapon_held] != 0 &&
    argument0.weapon_timers[argument0.weapon_held] <= 0) {
    switch (argument0.weapon_held) {
    // melee attack
    case 0:
        // for melee attack, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (pressed_attack == 0) break;
        // reset the timer
        argument0.weapon_timers[0] = argument0.weapon_delays[0] * room_speed;
        show_debug_message("player " + string(argument0.player_id) +
            " performing melee attack");
        break;
    // auto rife
    case 1:
        // reset the timer
        argument0.weapon_timers[1] = argument0.weapon_delays[1] * room_speed;
        // deduct one ammo.
        argument0.weapon_ammos[1] --;
        // spawn a bullet and set its speed.
        show_debug_message("player " + string(argument0.player_id) +
            " firing auto rifle");
        show_debug_message("auto rifle ammo remaining: " +
            string(argument0.weapon_ammos[1]));
        var bullet = instance_create(argument0.x, argument0.y,
            obj_proj_rifle_bullet);
        bullet.hspeed = 3 * argument0.facing_direction;
        bullet.fired_by = argument0.player_id;
        break;
    // shotgun
    case 2:
        // for shotgun, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (pressed_attack == 0) break;
        // reset the timer
        argument0.weapon_timers[2] = argument0.weapon_delays[2] * room_speed;
        // shotgun uses 5 bullets per shot, so if the player
        // doesn't have at least that much ammo, terminate.
        if (argument0.weapon_ammos[2] < 5) {
            // this should be impossible since we give ammo packs in
            // multiples of 5, but we need to be sure.
            show_debug_message("player " + string(argument0.player_id) +
                " doesn't have enough ammo to fire the shotgun (=" +
                string(argument0.weapon_ammos[2]));
            break;
        }
        // otherwise, go ahead and deduct the ammo.
        argument0.weapon_ammos[2] -= 5;
        show_debug_message("player " + string(argument0.player_id) +
            " firing shotgun");
        show_debug_message("shotgun ammo remaining: " +
            string(argument0.weapon_ammos[2]));
        // fired at 30 degree ascension
        var bullet = instance_create(argument0.x, argument0.y,
            obj_proj_shotgun_bullet);
        bullet.hspeed = 2.6 * argument0.facing_direction;
        bullet.vspeed = -1.5;
        bullet.fired_by = argument0.player_id;
        // fired at 15 degree ascension
        bullet = instance_create(argument0.x, argument0.y,
            obj_proj_shotgun_bullet);
        bullet.hspeed = 2.9 * argument0.facing_direction;
        bullet.vspeed = -0.78;
        bullet.fired_by = argument0.player_id;
        // fired at level
        bullet = instance_create(argument0.x, argument0.y,
            obj_proj_shotgun_bullet);
        bullet.hspeed = 3 * argument0.facing_direction;
        bullet.vspeed = 0;
        bullet.fired_by = argument0.player_id;
        // fired at 15 degree descension
        bullet = instance_create(argument0.x, argument0.y,
            obj_proj_shotgun_bullet);
        bullet.hspeed = 2.9 * argument0.facing_direction;
        bullet.vspeed = 0.78;
        bullet.fired_by = argument0.player_id;
        // fired at 30 degree descension
        bullet = instance_create(argument0.x, argument0.y,
            obj_proj_shotgun_bullet);
        bullet.hspeed = 2.6 * argument0.facing_direction;
        bullet.vspeed = 1.5;
        bullet.fired_by = argument0.player_id;
        break;
    // acid gun
    case 3:
        // reset the timer
        argument0.weapon_timers[3] = argument0.weapon_delays[3] * room_speed;
        show_debug_message("player " + string(argument0.player_id) +
            " firing acid gun");
        show_debug_message("acid gun not yet implemented");
        break;
    // seeker rocket
    case 4:
        // for seeker rocket, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (pressed_attack == 0) break;
        // reset the timer
        argument0.weapon_timers[4] = argument0.weapon_delays[4] * room_speed;
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
