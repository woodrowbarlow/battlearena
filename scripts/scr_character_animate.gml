///scr_character_animate(character_instance_id)

// read input from controller/keyboard
var move_horiz = scr_pressed_right(argument0.player_id, true) - scr_pressed_left(argument0.player_id, true);
var move_vert = scr_pressed_down(argument0.player_id, true) - scr_pressed_up(argument0.player_id, true);
var jump = scr_pressed_jump(argument0.player_id, false);

// if character is stunned, set the stun animation
if (argument0.stun_timer > 0) {
    // TODO: set the stun animation
    return 0;
}

if(scr_is_on_floor(argument0)) {
    if(jump > 0 && abs(move_horiz) < 0.03) {
        sprite_index = argument0.standing_jump_sprite;
    }
    else if(jump > 0) {
        sprite_index = argument0.running_jump_sprite;
    }
    else if(abs(move_horiz) > 0.65) {
        sprite_index = argument0.run_sprite;
    }
    else if(abs(move_horiz) > 0) {
        sprite_index = argument0.walk_sprite;
    }
    else {
        sprite_index = argument0.idle_sprite;
    }
    image_speed = 0.25 * argument0.move_speed;
}
else if(sprite_index == argument0.standing_jump_sprite ||
    sprite_index == argument0.running_jump_sprite) {
    // in the middle of a jump
    image_speed = 0;
}
else {
    // in free-fall
    sprite_index = argument0.idle_sprite;
    image_speed = 0;
}

if(argument0.facing_direction < 0) {
    image_xscale = -1;
}
else if(argument0.facing_direction > 0) {
    image_xscale = 1;
}
