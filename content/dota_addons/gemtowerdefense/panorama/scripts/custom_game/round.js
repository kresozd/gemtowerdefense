var dotaHUD = $.GetContextPanel().GetParent().GetParent().GetParent();
var HUDElements = dotaHUD.FindChildTraverse("HUDElements");
var quickstats = HUDElements.FindChildTraverse("quickstats");
var newUI = HUDElements.FindChildTraverse("lower_hud");
quickstats.FindChildTraverse("QuickStatsContainer").style.visibility = "collapse";
newUI.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";


function updateRound(table, key, data) {
  if (key == 'current_round') {
    var round = $('#round-value');
    round.AddClass('round-glowing');
    round.text = data.value;
    $.Schedule(2.35, function() {
      round.RemoveClass('round-glowing');
    });
  }
}


(function() {
  CustomNetTables.SubscribeNetTableListener('game_state', updateRound);
})();
