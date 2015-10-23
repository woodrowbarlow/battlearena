//no weapon - 0, auto rifle - 1, shotgun - 2, acid - 3, rocket - 4
var toFire = scr_pressed_fire(argument0.player_id, true); //weapon held down


if (toFire != 1){
    var toFire = scr_pressed_fire(argument0.player_id, false);
}




//after everything, if ammo is less than 0, set weapon held by player to 0