///scr_character_death(character_instance_id)

if(argument0.y >= 1.25 * view_hview[0] || argument0.character_health <= 0) {
    if(argument0.character_lives > 0) {
        argument0.character_lives --;
        argument0.character_health = starting_hp;
        argument0.x = argument0.spawn_coords[0];
        argument0.y = argument0.spawn_coords[1];
        argument0.delta_x = 0;
        argument0.delta_y = 0;
    }
    else {
        // todo: go to a victory screen
        // milestone: polish menus
        room_goto(rm_menus_characterselect);
    }
}