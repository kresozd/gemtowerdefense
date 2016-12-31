function setUpPlayerBar(player, id) {
  var panel = $("#player-bar-" + id);
  panel.RemoveClass('player-hidden');
  playerAva = panel.FindChildrenWithClassTraverse("player-avatar")[0];
  playerAva.steamid = player.player_steamid;  
}

function updateConnectionState(playerInfo, id) {
  var playerBar = $("#player-bar-" + id);
  playerBar.SetHasClass( "player-connection-abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED );
  playerBar.SetHasClass( "player-connection-failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED );
  playerBar.SetHasClass( "player-connection-disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED );
}

function getAllPlayers(callback) {
  var playerIDs = Game.GetAllPlayerIDs();
  
  for (var i = 0; i < playerIDs.length; i++) {
		var player = Game.GetPlayerInfo(playerIDs[i]);
    callback(player, i);
	}
}

(function() {
  getAllPlayers(setUpPlayerBar);
  // Connection state nettable is not done yet
  // CustomNetTables.SubscribeNetTableListener( 'game_state', updateConnectionState);
})();