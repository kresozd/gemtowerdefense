var health;
var healthbar = {};


function updateThroneHealth(table, key, data) {
  if (key == 'gem_castle_health') {
    
    if (health != data.value) {
      showDistinction(health, data.value);
    }

    health = data.value;

    if (health > 100) health = 100;
    var healthStr = health > 0 ? health + '%' : '0%';
    healthbar.value.text = healthStr;
    healthbar.progress.style.width = healthStr;
  }
}


function showDistinction(oldHealth, updHealth) {
  var isPositive = false;
  var parent = $("#health-changed");
  var distinction = updHealth - oldHealth;

  if (distinction >= 0 ) {
    distinction = '+' + distinction;
    isPositive = true;
  }
  
  if (parent.GetChildCount() > 0)
    parent.GetChild(parent.GetChildCount() - 1).visible = false;
  
  var valueLabel = $.CreatePanel('Label', parent, '');
  valueLabel.text = distinction;
  valueLabel.AddClass('health-changed-value');
  valueLabel.SetHasClass("health-changed-healed", isPositive);
  
  $.Schedule(1.25, function() {
      valueLabel.DeleteAsync(0);
  }); 
}

 
 function initThroneHealthbar() {
  var container = $('#throne-health-container');
  var panel = $.CreatePanel('Panel', container, 'throne-healthbar');
  panel.BLoadLayout("file://{resources}/layout/custom_game/healthbar.xml", false, false);

  var title = panel.FindChildInLayoutFile("healthbar-title");
  title.text = 'Throne'.toUpperCase();

  container.MoveChildBefore(panel, $('#throne-health-status'));

  healthbarValue = panel.FindChildInLayoutFile('healthbar-value');
  healthbarProgress = panel.FindChildInLayoutFile('healthbar-progress');

  healthbar = {
    panel: panel,
    value: healthbarValue,
    progress: healthbarProgress,
  }
  
  var data = CustomNetTables.GetTableValue('game_state', 'gem_castle_health');
  health = data ? data.value : 100;
  
  updateThroneHealth('', 'gem_castle_health', {value: health});
  CustomNetTables.SubscribeNetTableListener( 'game_state', updateThroneHealth );
}


(function() {
  initThroneHealthbar();
})();