

function updatePlayerPanel(playerId) {
  var playersContainer = $('#players-bar');
  var playerPanelName = 'player-bar-' + playerId;
  var playerPanel = playersContainer.FindChild(playerPanelName);

  if (playerPanel === null) {
    playerPanel = $.CreatePanel('Panel', playersContainer, playerPanelName);
    playerPanel.SetAttributeInt('player_id', playerId);
    playerPanel.BLoadLayout('file://{resources}/layout/custom_game/players_bar_player.xml', false, false);
  }
  
  var playerInfo = Game.GetPlayerInfo(0);
  var playerAva = playerPanel.FindChildInLayoutFile('player-avatar');
  
  if (playerAva) {
    playerAva.steamid = playerInfo.player_steamid;
  }
  
  var playerColorBar = playerPanel.FindChildInLayoutFile('player-color')
  
  if (playerColorBar !== null) {
    if (GameUI.CustomUIConfig().player_colors) {
      var playerColor = GameUI.CustomUIConfig().player_colors[playerId];
    } else {
      playerColor = "#d5d5d5";
    }
    playerColorBar.style.backgroundColor = playerColor;
  }
  playerPanel.SetHasClass( 'player-is-local', (playerId == Game.GetLocalPlayerID()));
  
  playerPanel.SetHasClass( "player-connection-abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED );
  playerPanel.SetHasClass( "player-connection-failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED );
  playerPanel.SetHasClass( "player-connection-disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED );
}

function getAllPlayers() {
  var players = Game.GetAllPlayerIDs();
  for (var player of players) {
    updatePlayerPanel(player)
	}
  
  // for (i = 0; i < 4; i++) {
  //   updatePlayerPanel(i);
  // }
}

(function() {
  getAllPlayers();
  // Connection state nettable is not done yet
  // CustomNetTables.SubscribeNetTableListener( 'game_state', updateConnectionState);
})();