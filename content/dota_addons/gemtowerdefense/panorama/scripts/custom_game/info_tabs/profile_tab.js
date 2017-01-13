
function updatePlayerProfile() {
  var profileContainer = $('#player-level-container');
  var playerLevel = $.CreatePanel('Panel', profileContainer, '');
  playerLevel.BLoadLayout("file://{resources}/layout/custom_game/player_level.xml", false, false);
  
  var localInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());
  var localID = localInfo.player_steamid;
 
  var playerAva = $.GetContextPanel().FindChildTraverse('profile-player-avatar');
  var playerName = $.GetContextPanel().FindChildTraverse('profile-player-username');
  
  playerAva.steamid = localID;
  playerName.steamid = localID;
}


(function() {
  updatePlayerProfile();
})();