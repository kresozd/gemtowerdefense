
function updateEndScreen() {
  var levelContainer = $('#end-screen-level');
  var playerLevel = $.CreatePanel('Panel', levelContainer, '');
  playerLevel.BLoadLayout("file://{resources}/layout/custom_game/player_level.xml", false, false);
}


(function() {
  updateEndScreen();
})();