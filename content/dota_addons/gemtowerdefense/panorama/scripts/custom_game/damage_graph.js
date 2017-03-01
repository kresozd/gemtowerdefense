var MAX_TOP_TOWERS = 5;
var totalDamage = 0;
var towers = [];


function updateStats(data) {
  totalDamage = data.totalDamage;

  var tower = data.tower;
  var place = tower.place;

  if (towers[place] && towers[place].entity == tower.entity) {
    towers[place].damage = tower.damage;
    updateTowerDamage(towers[place]);
    return;
  }

  var index = getIndexByEntity(tower.entity);

  if (!!index) {
    rearangeTowers(index, place);
    towers[place].damage = tower.damage;
    updateTowerDamage(towers[place]);
    return;
  }

  updateGraphPanel(tower)
}


function updateGraphPanel(tower) {
  var towerName = Entities.GetUnitName(+tower.entity);

  if (towers.length < MAX_TOP_TOWERS) {
    tower.panel = $.CreatePanel('Panel', $('#graph'), towerName);
    tower.panel.BLoadLayoutSnippet('graph-item');
  } else {
    tower.panel = towers[towers.length - 1].panel;
  }

  if (!tower.panel.imageName || tower.panel.imageName != towerName) {
    var imageName = towerName.length > 6 ? towerName : towerName.slice(0, 5);
    var towerImage = tower.panel.FindChildTraverse('graph-tower');
    towerImage.SetImage("file://{resources}/images/custom_game/gems/" + imageName + ".png");
    tower.panel.imageName = towerName;
  }

  towers.push(tower);
  updateTowerDamage(tower);
  rearangeTowers(towers.length - 1, tower.place);

  if (towers.length > MAX_TOP_TOWERS) {
    towers.pop();
  }
}


function updateTowersProgress() {
  for (var index in towers) {
    var tower = towers[index];
    var percentage = getPercentage(tower.damage);
    var graphBackground = tower.panel.FindChildTraverse('graph-item-background');
    graphBackground.style.width = percentage + '%'; 
  }
}


function rearangeTowers(place1, place2) {
  if (place1 !== place2) {
    if (place2 != MAX_TOP_TOWERS - 1) {
      $('#graph').MoveChildBefore(towers[place1].panel, towers[place2].panel);
    } else {
      $('#graph').MoveChildAfter(towers[place1].panel, towers[place2].panel)
    }
    move(towers, place1, place2);
  }
}


function updateTowerDamage(tower) {
  if (tower.panel) {
    var damageValue = tower.panel.FindChildTraverse('graph-damage-value')
    damageValue.text = tower.damage;
    updateTowersProgress();
  }
}


function getPercentage(towerDamage) {
  if (towerDamage == 0 || totalDamage == 0) { return 0; }
  var percentage = towerDamage * 100 / totalDamage;
  return Math.floor(percentage);
}


function move(arr, oldIndex, newIndex) {
  if (newIndex >= arr.length) {
    var k = newIndex - arr.length;
    while ((k--) + 1) {
      arr.push(undefined);
    }
  }
  arr.splice(newIndex, 0, arr.splice(oldIndex, 1)[0]);
};


function getIndexByEntity(entity) {
  for (var index in towers) {
    var tower = towers[index];
    if (tower && tower.entity == entity) {
      return index;
    }
  }
}


function clearGraph(table, key) {
  if (key == 'current_round') {
    $('#graph').RemoveAndDeleteChildren();
    totalDamage = 0;
    towers = [];
  }
}


(function() {
  GameEvents.Subscribe("update_tower_stats_damage", updateStats);
  CustomNetTables.SubscribeNetTableListener('game_state', clearGraph);
})();