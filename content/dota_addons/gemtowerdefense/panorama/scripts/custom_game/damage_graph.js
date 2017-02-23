var graphItems = {};


function updateStats(data) {
  var stats = data.damageTable || {};
  $.Msg(stats);
  for (var index in stats) {

    if (index) {
  
      for (var tower in stats[index]) {
        var towerName = Entities.GetUnitName(+tower);
        var towerDamage = stats[index][tower];
        
        // createGraphPanel(tower)
        // $.Msg(Entities.GetUnitName(+stats[tower]));
      }
    }
  }
}


(function() {
  GameEvents.Subscribe("update_tower_stats_damage", updateStats);
})();