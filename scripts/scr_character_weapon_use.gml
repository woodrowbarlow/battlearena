#define scr_character_weapon_use
var switch_weapon = scr_pressed_next_weapon(argument0.player_id, false) - 
    scr_pressed_prev_weapon(argument0.player_id, false);
var pressed_attack = scr_pressed_fire(argument0.player_id, false);
var held_attack = scr_pressed_fire(argument0.player_id, true);
var pressed_special = scr_pressed_special(argument0.player_id, false);

var i;
for (i = 0; i < array_length_1d(argument0.weapon_timers); i++) {
    if (argument0.weapon_timers[i] > 0) {
        argument0.weapon_timers[i]--;
    }
}
if (argument0.special_timer > 0) {
    argument0.special_timer --;
}
if (argument0.stun_timer > 0) {
    argument0.stun_timer --;
}

// this block handles switching weapons
if (switch_weapon != 0) {
    argument0.weapon_held += switch_weapon;
    if (argument0.weapon_held < 0)
        argument0.weapon_held = array_length_1d(argument0.weapon_ammos) - 1;
    argument0.weapon_held %= array_length_1d(argument0.weapon_ammos);
    // if this gun is out of ammo, switch to the next one
    var orig_weapon = argument0.weapon_held;
    while (argument0.weapon_ammos[argument0.weapon_held] == 0) {
        argument0.weapon_held += sign(switch_weapon);
        argument0.weapon_held %= array_length_1d(argument0.weapon_ammos);
        // in order to prevent an infinite loop if all weapons have no ammo,
        // we only go through one cycle of the weapons before giving up.
        if (argument0.weapon_held == orig_weapon) {
            // this should never happen since melee attack has infinite ammo.
            argument0.weapon_held = W_MELEE_ID;
            break;
        }
    }
}

// this block handles the actual firing of the weapon / melee attack
// if the character is on a ladder, they can't attack, so skip this
// if the character just switched to this weapon, don't start firing yet
// if the attack button isn't pressed, skip this
// if character is out of ammo in current weapon, skip this
if (!argument0.on_ladder && held_attack > 0 && switch_weapon == 0 &&
    argument0.weapon_ammos[argument0.weapon_held] != 0 &&
    argument0.weapon_timers[argument0.weapon_held] <= 0) {
    
    switch (argument0.weapon_held) {
    
    case W_MELEE_ID:
        // for melee attack, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (pressed_attack == 0) break;
        // reset the timer
        argument0.weapon_timers[W_MELEE_ID] =
            argument0.weapon_delays[W_MELEE_ID] * room_speed;
        scr_perform_melee_attack(argument0);
        break;
    case W_AUTO_RIFLE_ID:
        // reset the timer
        argument0.weapon_timers[W_AUTO_RIFLE_ID] =
            argument0.weapon_delays[W_AUTO_RIFLE_ID] * room_speed;
        scr_shoot_auto_rifle(argument0);
        break;
    case W_SHOTGUN_ID:
        // for shotgun, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (pressed_attack == 0) break;
        // reset the timer
        argument0.weapon_timers[W_SHOTGUN_ID] =
            argument0.weapon_delays[W_SHOTGUN_ID] * room_speed;
        scr_shoot_shotgun(argument0);
        break;
    case W_ACID_GUN_ID:
        // reset the timer
        argument0.weapon_timers[W_ACID_GUN_ID] =
            argument0.weapon_delays[W_ACID_GUN_ID] * room_speed;
        scr_shoot_acid_gun(argument0);
        break;
    case W_SEEKER_ROCKET_ID:
        // for seeker rocket, you can't hold down the fire button
        // so if it wasn't just pressed, then terminate.
        if (pressed_attack == 0) break;
        // reset the timer
        argument0.weapon_timers[W_SEEKER_ROCKET_ID] =
            argument0.weapon_delays[W_SEEKER_ROCKET_ID] * room_speed;
        scr_shoot_seeker_rocket(argument0);
        break;
    // error state
    default:
        // this shouldn't be possible unless a weapon has been added
        // but wasn't added here. log the error and recover.
        show_debug_message("player " + string(argument0.player_id) +
            " weapon_held variable is invalid (=" +
            string(argument0.weapon_held) + ")");
        argument0.weapon_held = W_MELEE_ID;  // recover
    }
}

// this block handles switching to the next weapon if the last of the
// ammo in the current weapon was used up.
orig_weapon = argument0.weapon_held;
while (argument0.weapon_ammos[argument0.weapon_held] == 0) {
    argument0.weapon_held ++;
    argument0.weapon_held %= array_length_1d(argument0.weapon_ammos);
    // in order to prevent an infinite loop if all weapons have no ammo,
    // we only go through one cycle of the weapons before giving up.
    if (argument0.weapon_held == orig_weapon) {
        argument0.weapon_held = W_MELEE_ID;
        break;
    }
}

// this block handles activating the special attack / ability
// it checks to see which character you are then calls the appropriate script
if (pressed_special > 0 && argument0.special_timer <= 0) {
    argument0.special_timer = special_cooldown * room_speed;
    switch (argument0.character_id) {
    case CHARACTER_ID_SALLIE:
        scr_perform_special_sallie(argument0);
        break;
    case CHARACTER_ID_RUFF:
        scr_perform_special_ruff(argument0);
        break;
    case CHARACTER_ID_AERIE:
        scr_perform_special_aerie(argument0);
        break;
    case CHARACTER_ID_PENN:
        scr_perform_special_penn(argument0);
        break;
    // error state
    default:
        // this shouldn't be possible unless a character has been added
        // but wasn't added here. log the error.
        show_debug_message("player " + string(argument0.player_id) +
            " character_id constant is unexpected (=" +
            string(argument0.weapon_held) + ")");
    }
}

#define scr_perform_melee_attack
///scr_perform_melee_attack(character_instance_id)

var damage = 8;
var knockback = 0.2;
var range = 0.5;
var min_x, max_x;
var min_y, max_y;
var enemy;

// set up the rectangular hitbox
min_y = argument0.y - argument0.sprite_height / 2;
max_y = argument0.y + argument0.sprite_height / 2;
if (argument0.facing_direction > 0) {
    min_x = argument0.x;
    max_x = argument0.x + range * G_GRID_SIZE;
    audio_play_sound(snd_shoot1, 1, false);
}
else {
    min_x = argument0.x - range * G_GRID_SIZE;
    max_x = argument0.x;
    audio_play_sound(snd_shoot1, 1, false);
}

for (i = 0; i < instance_number(obj_characters_parent); i++) {
    enemy = instance_find(obj_characters_parent, i);
    if (enemy == argument0) continue;   // WHY ARE YOU HITTING YOURSELF?
    
    // if the enemy is within the hitbox, they get hit
    if (enemy.x >= min_x && enemy.x <= max_x &&
        enemy.y >= min_y && enemy.y <= max_y) {
        
        enemy.character_health -= (1 - other.damage_reduction) * damage;
        enemy.knockback += sign(argument0.facing_direction) * G_GRID_SIZE * knockback;
        return 0;   // remove return if punches should go through multiple people
    }
}

#define scr_shoot_auto_rifle
// deduct one ammo.
argument0.weapon_ammos[W_AUTO_RIFLE_ID] --;
// spawn a bullet and set its speed.
var bullet = instance_create(argument0.x + sign(argument0.facing_direction) * 4,
    argument0.y - 8, obj_proj_rifle_bullet);
bullet.hspeed = 12 * argument0.facing_direction;
bullet.fired_by = argument0.player_id;
audio_play_sound(snd_shoot2, 1, false);



#define scr_shoot_acid_gun
show_debug_message("player " + string(argument0.player_id) +
    " firing acid gun");

// deduct one ammo.
argument0.weapon_ammos[W_ACID_GUN_ID] --;
// spawn a bullet and set its speed.
var bullet = instance_create(argument0.x + sign(argument0.facing_direction) * 4,
    argument0.y-8, obj_proj_acid_gun_bullet);
bullet.hspeed = 2 * argument0.facing_direction;
bullet.vspeed = -2;
audio_play_sound(snd_ooze, 1, false);



#define scr_shoot_shotgun

// shotgun uses 5 bullets per shot, so if the player
// doesn't have at least that much ammo, terminate.
if (argument0.weapon_ammos[W_SHOTGUN_ID] < 5) {
    // this should be impossible since we give ammo packs in
    // multiples of 5, but we need to be sure.
    return 0;
}
// otherwise, go ahead and deduct the ammo.
argument0.weapon_ammos[W_SHOTGUN_ID] -= 5;
// fired at 15 degree ascension
var bullet = instance_create(argument0.x + sign(argument0.facing_direction) * 4,
    argument0.y - 8, obj_proj_shotgun_bullet);
bullet.hspeed = 7.72 * argument0.facing_direction;
bullet.vspeed = -2.07;
bullet.fired_by = argument0.player_id;
// fired at 7.5 degree ascension
bullet = instance_create(argument0.x + sign(argument0.facing_direction) * 4,
    argument0.y - 8, obj_proj_shotgun_bullet);
bullet.hspeed = 7.93 * argument0.facing_direction;
bullet.vspeed = -1.044;
bullet.fired_by = argument0.player_id;
// fired at level
bullet = instance_create(argument0.x + sign(argument0.facing_direction) * 4,
    argument0.y - 8, obj_proj_shotgun_bullet);
bullet.hspeed = 8 * argument0.facing_direction;
bullet.vspeed = 0;
bullet.fired_by = argument0.player_id;
// fired at 7.5 degree descension
bullet = instance_create(argument0.x + sign(argument0.facing_direction) * 4,
    argument0.y - 8, obj_proj_shotgun_bullet);
bullet.hspeed = 7.93 * argument0.facing_direction;
bullet.vspeed = 1.044;
bullet.fired_by = argument0.player_id;
// fired at 15 degree descension
bullet = instance_create(argument0.x + sign(argument0.facing_direction) * 4,
    argument0.y - 8, obj_proj_shotgun_bullet);
bullet.hspeed = 7.72 * argument0.facing_direction;
bullet.vspeed = 2.07;
bullet.fired_by = argument0.player_id;
audio_play_sound(snd_shotgun, 1, false);


#define scr_shoot_seeker_rocket
// deduct one ammo.
argument0.weapon_ammos[W_SEEKER_ROCKET_ID] --;
// spawn a rocket.
var rocket = instance_create(argument0.x + sign(argument0.facing_direction) * 4,
    argument0.y - 8, obj_proj_seeker_rocket);
rocket.fired_by = argument0.player_id;

#define scr_perform_special_sallie
var dx = argument0.teleport_distance * G_GRID_SIZE
    * sign(argument0.facing_direction);
var dy = 0;

if (scr_pressed_up(argument0.player_id, true)) {
    dy = argument0.teleport_distance * G_GRID_SIZE / 3;
}

if (!scr_pressed_left(argument0.player_id, true)
    && !scr_pressed_right(argument0.player_id, true)) {
    if (scr_pressed_up(argument0.player_id, true)) {
        dx = 0;
        dy *= 3;
    }
    else {
        argument0.facing_direction *= -1;
    }
}

argument0.x += dx;
argument0.y -= dy;

#define scr_perform_special_ruff
var enemy;

for (i = 0; i < instance_number(obj_characters_parent); i++) {
    enemy = instance_find(obj_characters_parent, i);
    if (enemy == argument0) continue;   // ruff is not affected by his own special
    with (argument0) {
        if (distance_to_object(enemy) <= stun_range * G_GRID_SIZE &&
            scr_is_on_floor(enemy)) {
            enemy.stun_timer = stun_duration * room_speed;  // stun 'em
        }
    }
}

#define scr_perform_special_aerie
show_debug_message("player " + string(argument0.player_id) +
    "performing aerie's special");
show_debug_message("aerie's special not yet implemented");

#define scr_perform_special_penn
show_debug_message("player " + string(argument0.player_id) +
    "performing penn's special");
show_debug_message("penn's special not yet implemented");