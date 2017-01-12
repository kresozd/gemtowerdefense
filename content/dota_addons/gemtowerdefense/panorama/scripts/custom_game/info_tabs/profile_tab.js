
function updatePlayerProfile() {
  var profileContainer = $('#player-level-container');
  // $.Msg(profileContainer);
  var playerLevel = $.CreatePanel('Panel', profileContainer, '');
  playerLevel.BLoadLayout("file://{resources}/layout/custom_game/player_level.xml", false, false);
}


(function() {
  updatePlayerProfile();
})();