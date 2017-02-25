var MAX_GRAPH_TOWERS = 5;
var totalDamage = 0;
var panels = [];
var towers = [];


function updateStats(data) {
  var damageTable = data.damageTable || {};
  totalDamage = data.totalDamage;
  $.Msg(data);
  for (var index in damageTable) {

    if (index) {
      var tower = damageTable[index];
      var towerDamage = tower.damage;
      towers[index] = tower;
      updateGraphPanel(tower.index, index);
    }
  }
}


function updateGraphPanel(entity, index) {
  var towerName = Entities.GetUnitName(+entity);

  var graphPanel = panels[index];

  if (!graphPanel) {
    graphPanel = $.CreatePanel('Panel', $('#graph'), towerName);
    graphPanel.BLoadLayoutSnippet('graph-item');
    panels.push(graphPanel);
  }

  var damageValue = graphPanel.FindChildTraverse('graph-damage-value')
  damageValue.text = towers[index].damage;

  if (!graphPanel.imageName || graphPanel.imageName != towerName) {
    var imageName = towerName.length > 6 ? towerName : towerName.slice(0, 5);
    var towerImage = graphPanel.FindChildTraverse('graph-tower');
    towerImage.SetImage("file://{resources}/images/custom_game/gems/" + imageName + ".png");
    graphPanel.imageName = towerName;
  }

  var percentage = getPercentage(towers[index].damage);
  var graphBackground = graphPanel.FindChildTraverse('graph-item-background');
  graphBackground.style.width = percentage + '%';
}


function getPercentage(towerDamage) {
  if (towerDamage == 0 || totalDamage == 0) { return 0; }
  var percentage = towerDamage * 100 / totalDamage;
  return Math.floor(percentage);
}


function clearGraph() {
  $('#graph').RemoveAndDeleteChildren();
  totalDamage = 0;
  towers = [];
  panels = [];
}


(function() {
  // clearGraph();
  // updateStats({"totalDamage":3272,"damageTable":{"0":{"damage":1278,"index":425},"1":{"damage":701,"index":303},"2":{"damage":574,"index":494},"3":{"damage":447,"index":511},"4":{"damage":172,"index":345}}})
  GameEvents.Subscribe("update_tower_stats_damage", updateStats);
  CustomNetTables.SubscribeNetTableListener('game_state', clearGraph);
})();