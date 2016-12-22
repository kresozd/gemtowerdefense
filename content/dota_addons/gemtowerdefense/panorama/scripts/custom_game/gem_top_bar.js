function OnNettableChanged( table, key, data ) {
	$.Msg('Castle hp: ' + data.value);
  if (key == 'gem_castle_health')
    updateCastleHealth(data.value);
  if (key == 'current_round')
    updateCurrentRound(data.value);
}


function updateCurrentRound(round) {
  $('#round-number').text = round;
}


function updateCastleHealth(health) {
  $("#castle-health-value").text = health + '%';
  $("#castle-health-progress").style.width = health >= 0 ? health + '%' : '0%';
}


(function() {
  CustomNetTables.SubscribeNetTableListener( 'game_state', OnNettableChanged );
})();