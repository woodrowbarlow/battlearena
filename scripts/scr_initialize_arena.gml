///scr_initialize_arena(spawn_locations, arena_gravity)

var i,j,inst_ids, hud;
inst_ids[0] = 0;
inst_ids[1] = 0;
for (i = 0; i < number_of_players; i++) {
    inst_ids[i] = instance_create(
        argument0[i,0], argument0[i,1],
        selected_characters[i]
        );
    inst_ids[i].character_instance_id = inst_ids[i];
    inst_ids[i].player_id = i;
    inst_ids[i].arena_gravity = argument1;
    inst_ids[i].airjumps_remaining = inst_ids[i].airjump_limit;
    inst_ids[i].on_ladder = false;
    inst_ids[i].character_health = starting_hp;
    inst_ids[i].character_lives = starting_lives;
    inst_ids[i].spawn_coords[0] = argument0[i,0];
    inst_ids[i].spawn_coords[1] = argument0[i,1];
    inst_ids[i].delta_x = 0;
    inst_ids[i].delta_y = 0;
    if(i % 2 == 0) inst_ids[i].facing_direction = 1;
    else inst_ids[i].facing_direction = -1;
    inst_ids[i].stun_timer = 0;
    inst_ids[i].special_timer = 0;
    inst_ids[i].weapon_timers[0] = 0;
    inst_ids[i].weapon_timers[1] = 0;
    inst_ids[i].weapon_timers[2] = 0;
    inst_ids[i].weapon_timers[3] = 0;
    inst_ids[i].weapon_timers[4] = 0;
    inst_ids[i].knockback = 0;
}

hud = instance_create(0, 0, obj_menus_hud);
hud.player_inst_ids[0] = inst_ids[0];
hud.player_inst_ids[1] = inst_ids[1];
