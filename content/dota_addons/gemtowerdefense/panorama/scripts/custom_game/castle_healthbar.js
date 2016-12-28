var health = 100;


function updateCastleHealth(table, key, data) {
  if (key == 'gem_castle_health') {
    showDistinction(health, data.value);
    health = data.value;

    if (health > 100) health = 100;

    $("#castle-health-value").text = health > 0 ? health + '%' : '0%';
    $("#castle-health-progress").style.width = health > 0 ? health + '%' : '0%';
  }
}


function showDistinction(oldHealth, updHealth) {
  
  var distinction;
  var parent;
  
  if ( updHealth > 0 || oldHealth > 0 )
    distinction = -Math.abs(oldHealth) + Number(updHealth);
  else
    distinction = Math.abs(oldHealth) + Number(updHealth);
  
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
  
  $.Schedule(1.3, function() {
      if (valueLabel.deleted) {
        $.Msg('debug');
        return;    
      }
      
      valueLabel.deleted = true;
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