"use strict";

function OnPlayerLumberChanged ( args ) {
	var iPlayerID = Players.GetLocalPlayer()
	var lumber = args.lumber
	$.Msg("Player "+iPlayerID+" Lumber: "+lumber)
	$('#LumberText').text = lumber
}

function OnPlayerFoodChanged ( args ) {
	var iPlayerID = Players.GetLocalPlayer()
	var food = args.food
	$.Msg("Player "+iPlayerID+" Food: "+food)
	$('#FoodText').text = food
}

function OnPlayerLifesChanged ( args ) {
	var iPlayerID = Players.GetLocalPlayer()
	var lifes = args.lifes
	$.Msg("Player "+iPlayerID+" lifes: "+lifes)
	$('#LifesText').text = lifes
}

(function () {
	GameEvents.Subscribe( "player_lumber_changed", OnPlayerLumberChanged );
	GameEvents.Subscribe( "player_food_changed", OnPlayerFoodChanged );
	GameEvents.Subscribe( "player_lifes_changed", OnPlayerLifesChanged );
})();