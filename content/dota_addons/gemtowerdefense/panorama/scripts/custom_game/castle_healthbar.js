var health = 100;


function updateCastleHealth(table, key, data) {
  if (key == 'gem_castle_health') {
    showDistinction(health, data.value);
    health = data.value;

    if (health > 100) health = 100;
    var healthStr = health > 0 ? health + '%' : '0%';
    $("#castle-health-value").text = healthStr;
    $("#castle-health-progress").style.width = healthStr;
  }
}


function showDistinction(oldHealth, updHealth) {
  
  var parent;
  var distinction = updHealth - oldHealth;
  
  if (distinction < 0 )
    parent = $('#health-damaged');
  else {
    parent = $('#health-healed');
    distinction = '+' + distinction;
  }
  
  if (parent.GetChildCount() > 0)
    parent.GetChild(parent.GetChildCount() - 1).visible = false;
  
  var valueLabel = $.CreatePanel('Label', parent, '');
  valueLabel.text = distinction;
  valueLabel.AddClass('health-changed-value');
  
  $.Schedule(1.25, function() {
      valueLabel.DeleteAsync(0);
  }); 
}


function triggerHealth(min, max) {

  var random = Math.floor(Math.random() * (max - min + 1)) + min;
  
  var data = {
    value: health + random
  }

  updateCastleHealth('table', 'gem_castle_health', data)
}


(function() {
  CustomNetTables.SubscribeNetTableListener( 'game_state', updateCastleHealth );
})();