
var units_killed = 1

function updateRound(table, key, data) {
  if (key == 'current_round') {
    $('#round-value').text = data.value;
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
})();

(function()
{
  CustomNetTables.SubscribeNetTableListener('game_state', WaveEnded);
})();

(function() {
  CustomNetTables.SubscribeNetTableListener('game_state', AllPicked);
})();