///scr_character_death(character_instance_id)

if (argument0.y >= 1.25 * view_hview[0] || argument0.character_health <= 0) {
    argument0.character_lives --;
    if (argument0.character_lives > 0) {
        argument0.character_health = starting_hp;
        argument0.x = argument0.spawn_coords[0];
        argument0.y = argument0.spawn_coords[1];
        argument0.delta_x = 0;
        argument0.delta_y = 0;
        argument0.weapon_ammos[W_MELEE_ID] = DEFAULT_STARTING_AMMO_MELEE;
        argument0.weapon_ammos[W_AUTO_RIFLE_ID] = DEFAULT_STARTING_AMMO_AUTO_RIFLE;
        argument0.weapon_ammos[W_SHOTGUN_ID] = DEFAULT_STARTING_AMMO_SHOTGUN;
        argument0.weapon_ammos[W_ACID_GUN_ID] = DEFAULT_STARTING_AMMO_ACID_GUN;
        argument0.weapon_ammos[W_SEEKER_ROCKET_ID] = DEFAULT_STARTING_AMMO_SEEKER_ROCKET;
    }
    else {
        global.victor = (1 - argument0.player_id);
        room_goto(rm_menus_victory);
    }
}