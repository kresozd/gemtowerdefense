function setUpPlayerBar(player, id) {
  var panel = $("#player-bar-" + id);
  panel.RemoveClass('player-hidden');

  for (var i = 0; i < panel.GetChildCount(); i++) {
    panel.Children()[i].steamid = player.player_steamid;
  }
}


(function() {
  var playerIDs = Game.GetAllPlayerIDs();
  
  for (var i = 0; i < playerIDs.length; i++) {
		var player = Game.GetPlayerInfo(playerIDs[i]);
    setUpPlayerBar(player, i);
	}
})();