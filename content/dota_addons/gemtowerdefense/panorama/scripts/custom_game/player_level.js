function updateLevelBar() {
  var playerLevel = GameUI.CustomUIConfig().player_level;
  var playerValue = $('#player-level-value');

  if (!playerLevel) {
    playerValue.text = 'level 1';
  } else {
    playerValue.text = 'level ' + playerLevel;
  }
}

(function() {
  updateLevelBar();
})();