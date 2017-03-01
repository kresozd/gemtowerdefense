var health = 100;
var maxHealth = 100;
var healthbar = {};
var separator = ' / ';

function updateBossHealthbar(data) {
  $.Msg(data);
  if (healthbar) {
    healthbar.value.text = data.health + separator + maxHealth;
    healthbar.progress.style.width = (data.health / maxHealth) * 100 + '%';
  }
}


function initBossHealthbar(data) {
  $.Msg(data);
  health = maxHealth = data.health;
  var panel = $.CreatePanel('Panel', $.GetContextPanel(), 'final-boss-healthbar');
  panel.BLoadLayout("file://{resources}/layout/custom_game/healthbar.xml", false, false);

  var title = panel.FindChildInLayoutFile("healthbar-title");
  title.text = $.Localize('#' + data.name).toUpperCase();

  healthbarValue = panel.FindChildInLayoutFile('healthbar-value');
  healthbarProgress = panel.FindChildInLayoutFile('healthbar-progress');

  healthbar = {
    panel: panel,
    value: healthbarValue,
    progress: healthbarProgress,
  }
  
  updateBossHealthbar(data);
  
  GameEvents.Subscribe("final_boss_update", updateBossHealthbar);
}

(function() {
  GameEvents.Subscribe("final_boss", initBossHealthbar);
  // initBossHealthbar({health: 1280000});
})();