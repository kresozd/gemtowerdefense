
var units_killed = 1
var joinedHero   = 0


function updateRound(table, key, data) {
  if (key == 'current_round') {
    $('#round-value').text = data.value;
  }
}

function AllPicked(table, key, data)
{
  var playerAmount = GetMaxPlayers()
  $.Msg( "Players on server: ", playerAmount );
  if(key == "pick_hero")
  {
    joinedHero++;
    if(joinedHero == playerAmount)
    {
      GameEvens.SendCustomGameEventToServer("all_picked", {"key":"value"})
    }
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
})();

(function()
{
  CustomNetTables.SubscribeNetTableListener('game_state', WaveEnded);
})();

(function() {
  CustomNetTables.SubscribeNetTableListener('pickedHero', AllPicked);
})();