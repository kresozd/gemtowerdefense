

function initFormulaRows(data) {
  var towers = data || {};
  for (var tower in towers) {
    if (towers[tower].Requirements) {
      initComponents(towers[tower], tower)
    }
  }
}


function initComponents(tower, towerName) {
  var towerComponents = tower.Requirements || {};

  towerRow = $.CreatePanel('Panel', $.GetContextPanel(), towerName)
  towerRow.AddClass('formula-row');
  for (var component in towerComponents) {
    createTowerPanel(towerRow, towerComponents[component]);
    
    var formulaMark = $.CreatePanel('Label', towerRow, '');
    formulaMark.AddClass('formula-mark');

    formulaMark.text = Object.keys(towerComponents).length > component ? '+' : '=';
  }

  createTowerPanel(towerRow, towerName, true);
}


function createTowerPanel(container, tower, isFinal) {
  var towerPanel = $.CreatePanel('Panel', container, isFinal ? tower : '');

  towerPanel.BLoadLayoutSnippet('formula-item');
  towerPanel.AddClass(tower);

  var towerImg = tower.length > 6 ? tower : tower.slice(0, 5);
  var towerInner = towerPanel.FindChildTraverse('tower-image');
  towerInner.SetImage("file://{resources}/images/custom_game/gems/" + towerImg + ".png");

  var towerLabel = towerPanel.FindChildTraverse('tower-name');
  towerLabel.text = $.Localize('#' + tower);

  if (isFinal) {
    towerPanel.AddClass('tower-result');
    setUpTowerTooltip(towerPanel, tower);
  }
}


function setUpTowerTooltip(towerPanel, towerName) {
  
  var showTooltip = function() {

    // we need to apply tooltip target properly according to table state minimized/expanded
    var isMinimized = $.GetContextPanel().BHasClass('tab-formula-min');
    var towerInner = towerPanel.FindChildTraverse('tower-inner');
    var target = isMinimized ? towerPanel : towerInner;

    $.DispatchEvent("UIShowCustomLayoutParametersTooltip", target, "formulaTooltip", "file://{resources}/layout/custom_game/tooltips/formula_tooltip.xml", "towerName=" + towerName + "&towerType=" + towers[towerName].Type);
  }

  towerPanel.SetPanelEvent("onmouseover", showTooltip)

  towerPanel.SetPanelEvent(
    "onmouseout",
    function() {
      $.DispatchEvent("UIHideCustomLayoutTooltip", "formulaTooltip");
    }
  );
}


(function() {
  var towersT = CustomNetTables.GetTableValue("game_state", "towers_table");
  $.Msg(towersT);
  initFormulaRows(towersT);
})();