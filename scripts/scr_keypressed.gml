#define scr_keypressed
var i, player;
if(argument0 < 0) {

    // if a negative value was passed as the player argument, that means "any player"
    // this is used in menus
    for(i = 0; i < max(controller_count, 2); i++) {
        if(scr_keypressed(i, argument1, argument2, argument3) > 0) return 1;
    }
    return 0;
}
else if(argument0 == 0) {

    // the keyboard is always player 0, even if player 0 also has a controller
    for(i = 0; i < array_length_1d(argument1); i++) {
        if(argument3 && keyboard_check(argument1[i]) > 0) return 1;
        else if(keyboard_check_pressed(argument1[i]) > 0) return 1;
    }
    
    // if we have more than one controller, controller 0 is player 0
    // otherwise, controller 0 is player 1
    if(controller_count > 1) {
        for(i = 0; i < array_length_1d(argument2); i++) {
            if(argument3 && gamepad_button_check(0, argument2[i]) > 0) return 1;
            else if(gamepad_button_check_pressed(0, argument2[i]) > 0) return 1;
        }
    }
    return 0;
}
else {

    if(argument0 > 1 && argument0 >= controller_count) return -1;
    player = argument0;
    
    // if we only have one controller, the keyboard is player 0
    // so controller 0 is actually player 1
    if(controller_count == 1) {
        player = 0;
    }
    
    for(i = 0; i < array_length_1d(argument2); i++) {
        if(argument3 && gamepad_button_check(player, argument2[i]) > 0) return 1;
        else if(gamepad_button_check_pressed(player, argument2[i]) > 0) return 1;
    }
    
    return 0;
}

#define scr_pressed_up
var keys, buttons;
keys[0] = vk_up;
keys[1] = ord("W");
buttons[0] = gp_padu;
return scr_keypressed(argument0, keys, buttons, argument1);

#define scr_pressed_down
var keys, buttons;
keys[0] = vk_down;
keys[1] = ord("S");
buttons[0] = gp_padd;
return scr_keypressed(argument0, keys, buttons, argument1);

#define scr_pressed_left
var keys, buttons;
keys[0] = vk_left;
keys[1] = ord("A");
buttons[0] = gp_padl;
return scr_keypressed(argument0, keys, buttons, argument1);

#define scr_pressed_right
var keys, buttons;
keys[0] = vk_right;
keys[1] = ord("D");
buttons[0] = gp_padr;
return scr_keypressed(argument0, keys, buttons, argument1);

#define scr_pressed_primary
var keys, buttons;
keys[0] = vk_enter;
keys[1] = vk_space;
buttons[0] = gp_face1;
return scr_keypressed(argument0, keys, buttons, argument1);

#define scr_pressed_secondary
var keys, buttons;
keys[0] = vk_shift;
keys[1] = vk_control;
buttons[0] = gp_face2;
return scr_keypressed(argument0, keys, buttons, argument1);

#define scr_pressed_start
var keys, buttons;
keys[0] = vk_escape;
buttons[0] = gp_start;
return scr_keypressed(argument0, keys, buttons, argument1);

#define scr_pressed_back
var keys, buttons;
keys[0] = vk_backspace;
keys[1] = vk_escape;
buttons[0] = gp_select;
buttons[1] = gp_start;
return scr_keypressed(argument0, keys, buttons, argument1);