//weapon_held
//ammo

//no weapon - 0, auto rifle - 1, shotgun - 2, acid - 3, rocket - 4
var toFire = scr_pressed_fire(argument0.player_id, true); //1 if fire held down
if (toFire = 1){ //held down fire
    if (weapon_held = 1){ //hold down auto rifle
        //have a timer set in the future
    }
} else if (toFire != 1){
    var toFire = scr_pressed_fire(argument0.player_id, false); //1 if fire pressed
}

if (toFire = 1){ //other weapons fired
    if (weapon_held = 1){ //auto rifle tapped
        bullet = instance_create(argument0.x, argument0.y - 5, obj_rifle_bullet);
        bullet.direction = -1; //1 for right, -1 for left. direction player is facing    
    }
}




//after everything, if ammo is less than 0, set weapon held by player to 0
