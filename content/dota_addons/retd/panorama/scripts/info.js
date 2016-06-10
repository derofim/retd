"use strict";

function OnUpdateStatGUI ( args ) {
	var iPlayerID = Players.GetLocalPlayer()
	var rad_lifes = args.radiant_lifes
	var dire_lifes = args.dire_lifes
	$('#LifesRad').text = "Radiant: "+rad_lifes
	$('#LifesDire').text = "Dire: "+dire_lifes
}

(function () {
	GameEvents.Subscribe( "stat_gui_changed", OnUpdateStatGUI );
})();