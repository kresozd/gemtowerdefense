function updateLevelBar() {
  var playerLevel = GameUI.CustomUIConfig().player_level;
  var playerValue = $('#player-level-value');

  if (!playerLevel) {
    playerValue.text = '1';
  } else {
    playerValue.text = playerLevel;
  }
}

(function() {
  updateLevelBar();
})();