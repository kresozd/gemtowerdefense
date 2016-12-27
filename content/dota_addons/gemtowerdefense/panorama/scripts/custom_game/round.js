var dotaHUD = $.GetContextPanel().GetParent().GetParent().GetParent();
var HUDElements = dotaHUD.FindChildTraverse("HUDElements");
var quickstats = HUDElements.FindChildTraverse("quickstats");
var newUI = HUDElements.FindChildTraverse("lower_hud");
quickstats.FindChildTraverse("QuickStatsContainer").style.visibility = "collapse";
newUI.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";

var units_killed = 1

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

function AllPicked(table, key, data)
{
  
  if(key == "all_picked")
  {
     GameEvents.SendCustomGameEventToServer("all_picked", {"key":"value"})
    $.Msg( "In all Picked function panorama! ");
      
  }

}


function WaveEnded(table, key, data)
{
  if(key == "unit_killed")  
  {
    $.Msg( "units_killed update: ", units_killed );
    units_killed++;
    if (units_killed % 10 == 0)
    {
        GameEvents.SendCustomGameEventToServer("wave_end", {"key":"value"})
    }

  }

}

(function() {
  CustomNetTables.SubscribeNetTableListener('game_state', updateRound);
  CustomNetTables.SubscribeNetTableListener('game_state', WaveEnded);
  CustomNetTables.SubscribeNetTableListener('game_state', AllPicked);
})();