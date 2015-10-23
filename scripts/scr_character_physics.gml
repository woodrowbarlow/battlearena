#define scr_character_physics
///scr_character_physics(character_instance_id)

// read input from controller/keyboard
var move_horiz = scr_pressed_right(argument0.player_id, true) - scr_pressed_left(argument0.player_id, true);
var move_vert = scr_pressed_down(argument0.player_id, true) - scr_pressed_up(argument0.player_id, true);
var jump = scr_pressed_jump(argument0.player_id, false);
var max_move_speed = 4 * argument0.move_speed;
var max_jump_height = 12 * argument0.jump_height;
var terminal_velocity = 10*argument0.arena_gravity;

if(argument0.on_ladder) {
    var dx = move_horiz * max_move_speed;
    var dy = move_vert * max_move_speed;
    if(jump > 0) {
        argument0.delta_y -= max_jump_height / 1.5;
        argument0.on_ladder = false;
        return 0;
    }
    argument0.x += dx;
    argument0.y += dy;
    if(!place_meeting(argument0.x, argument0.y, obj_deco_elem_ladder)) {
        argument0.on_ladder = false;
    }
    return 0;
}

// if we're standing on solid ground
if(place_meeting(argument0.x,argument0.y+1,obj_plat_par_solid)
    || (move_vert <= 0 && place_meeting(argument0.x,argument0.y+1,obj_plat_par_semisolid) &&
    !place_meeting(argument0.x,argument0.y,obj_plat_par_semisolid))) {
    // move_speed is a signed float from -1 to 1 indicating magnitude and direction
    argument0.delta_x = max_move_speed * move_horiz;
    argument0.delta_y = 0;
    if(place_meeting(argument0.x,argument0.y,obj_deco_elem_ladder) && move_vert <= 0.7) {
        argument0.on_ladder = true;
        return 0;
    }
    // if jump was pressed since last frame
    if(jump > 0) {
        // for y-axis, positive is down and negative is up
        argument0.delta_y = -max_jump_height;
    }
    argument0.airjumps_remaining = argument0.airjump_limit;
}

// if we're in mid-air
else {
    if(jump && argument0.airjumps_remaining > 0) {
        argument0.delta_y = -max_jump_height * argument0.airjump_height;
        argument0.airjumps_remaining --;
    }
    // you can't control movement in mid-air as well
    argument0.delta_x += 0.15 * max_move_speed * move_horiz;
    if(abs(argument0.delta_x) > max_move_speed) {
        argument0.delta_x = sign(move_horiz) * max_move_speed;
    }
    // apply a force downward
    argument0.delta_y += argument0.arena_gravity;
    // terminal velocity check
    if(argument0.delta_y > terminal_velocity) {
        argument0.delta_y = terminal_velocity;
    }
    if(argument0.delta_y < (-max_jump_height + 5*argument0.arena_gravity) &&
        !scr_pressed_jump(argument0.player_id, true)) {
        argument0.delta_y += max_jump_height / 2;
    }
}

// if we're about to collide horizontally with a solid object
if(place_meeting(argument0.x + argument0.delta_x, argument0.y, obj_plat_par_solid)) {
    // get as close to it as we can without actually intersecting
    while(!place_meeting(argument0.x + sign(argument0.delta_x), y, obj_plat_par_solid)) {
        argument0.x += sign(argument0.delta_x);
    }
    // then stop moving horizontally
    argument0.delta_x = 0;
}

// if we're about to collide vertically with a solid object
if(place_meeting(argument0.x, argument0.y + argument0.delta_y, obj_plat_par_solid)) {
    // get as close to it as we can without actually intersecting
    while(!place_meeting(argument0.x, argument0.y + sign(argument0.delta_y), obj_plat_par_solid)) {
        argument0.y += sign(argument0.delta_y);
    }
    // then stop moving vertically
    argument0.delta_y = 0;
}

if(place_meeting(argument0.x,argument0.y + 1,obj_plat_par_semisolid) &&
    !place_meeting(argument0.x,argument0.y,obj_plat_par_semisolid) &&
    place_meeting(argument0.x + argument0.delta_x,argument0.y,obj_plat_par_semisolid)) {
    var dx;
    for(dx = 0; dx <= delta_x; dx++) {
        if(!place_meeting(argument0.x + 1,argument0.y,obj_plat_par_solid)) argument0.x ++;
        if(place_meeting(argument0.x + 1,argument0.y,obj_plat_par_semisolid)) {
            if(!place_meeting(argument0.x + 1, argument0.y - 1, obj_plat_par_semisolid)) {
                argument0.y --;
            }
            else if(!place_meeting(argument0.x + 1, argument0.y - 2, obj_plat_par_semisolid)) {
                argument0.y -= 2;
            }
            else break;
        }
    }
    argument0.delta_x = 0;
}

// if we're falling onto a semisolid platform
// (these are platforms that you can only collide with from above)
if(argument0.delta_y > 0 && move_vert <= 0.7 &&
    place_meeting(argument0.x, argument0.y + argument0.delta_y, obj_plat_par_semisolid) &&
    !place_meeting(argument0.x,argument0.y,obj_plat_par_semisolid)) {
    // get as close to it as we can without actually intersecting
    while(!place_meeting(argument0.x, argument0.y+1, obj_plat_par_semisolid)) {
        argument0.y ++;
    }
    // then stop moving vertically
    argument0.delta_y = 0;
}

// update our coordinates
argument0.x += argument0.delta_x;
argument0.y += argument0.delta_y;

#define scr_is_on_floor
///scr_is_on_floor(character_instance_id)

return (place_meeting(argument0.x,argument0.y+1,obj_plat_par_solid) ||
    (argument0.delta_y == 0 && 
    place_meeting(argument0.x,argument0.y+1,obj_plat_par_semisolid) &&
    !place_meeting(argument0.x,argument0.y,obj_plat_par_semisolid)));