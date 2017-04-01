var towersT = {};
var towerPanelList = {};

function initFormulaRows(data) {
  var towers = data || {};
  var it1 = 0;
  while(it1<27){
    it1 = it1 + 1
    for (var tower in towers) {
      if (towers[tower].UINum == it1) {
        if (towers[tower].Requirements) {
          initComponents(towers[tower], tower)
        }
      } 
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

  var imageName = tower.length > 6 ? tower : tower.slice(0, 5);
  //$.Msg(imageName)
  var towerImage = towerPanel.FindChildTraverse('tower-image');
  towerImage.SetImage("file://{resources}/images/custom_game/gems/" + imageName + ".png");

  var towerLabel = towerPanel.FindChildTraverse('tower-name');
  towerLabel.text = $.Localize('#' + tower);

  if (isFinal) {
    towerPanel.AddClass('tower-result');
    setUpTowerTooltip(towerPanel, tower);
  }

  towerPanelList[tower]=towerPanel;
}


function updateComponents(data) {
  $.Msg(data);
  var updatetower = data.towerNameupdate || {};
  //$.Msg(updatetower);
  var pickstate = data.updatestate;
  if (pickstate == "pulled") {
    if (towerPanelList[updatetower]) {
      //$.Msg("true");
      towersT[updatetower].BoardPulled += 1;
      $.Msg("pull test ", towersT[updatetower].BoardPulled) 
      if (!towerPanelList[updatetower].BHasClass('tower-pulled')) {
        towerPanelList[updatetower].ToggleClass('tower-pulled');
      }
    
    //var towerLabel = towerPanelList[updatetower].FindChildTraverse('tower-name');
    //towerLabel.text = $.Localize('#' + updatetower); 

    }
  }
  if (pickstate == "picked") {
    if (towerPanelList[updatetower]) {
      //$.Msg("true");
      towersT[updatetower].BoardPicked += 1;
      $.Msg("pick selected ",towersT[updatetower].BoardPicked)
      if (towerPanelList[updatetower].BHasClass('tower-pulled')) 
      {
        towersT[updatetower].BoardPulled -= 1;
        if (towersT[updatetower].BoardPulled <2) 
        {
          towerPanelList[updatetower].ToggleClass('tower-pulled');
        }
      }

      if (!towerPanelList[updatetower].BHasClass('tower-picked')) 
      {
        towerPanelList[updatetower].ToggleClass('tower-picked');
      }
    //var towerLabel = towerPanelList[updatetower].FindChildTraverse('tower-name');
    //towerLabel.text = $.Localize('#' + updatetower); 

    }
  }
  if (pickstate == "removed") {
    if (towerPanelList[updatetower]) {
      //$.Msg("true");
      
      if (towerPanelList[updatetower].BHasClass('tower-pulled')) 
      {
        towersT[updatetower].BoardPulled -= 1;
        $.Msg(towersT[updatetower].BoardPulled)
        if (towersT[updatetower].BoardPulled <1) 
        {
          towerPanelList[updatetower].ToggleClass('tower-pulled');
        }
      }
      else 
      {
        if (towerPanelList[updatetower].BHasClass('tower-picked')) 
        {
          towersT[updatetower].BoardPicked -= 1;
          $.Msg("pick removed ",towersT[updatetower].BoardPicked)
          if (towersT[updatetower].BoardPicked < 1)
          {
            towerPanelList[updatetower].ToggleClass('tower-picked');
          }
        }
      }

      

    //towerPanelList[updatetower].ToggleClass('formula-item');
   // var towerLabel = towerPanelList[updatetower].FindChildTraverse('tower-name');
    //towerLabel.text = $.Localize('#' + updatetower); 

    }
  }

}


function setUpTowerTooltip(towerPanel, towerName) {
  
  var showTooltip = function() {

    // we need to apply tooltip target properly according to table state minimized/expanded
    var isMinimized = $.GetContextPanel().BHasClass('tab-formula-min');
    var towerInner = towerPanel.FindChildTraverse('tower-inner');
    var target = isMinimized ? towerPanel : towerInner;

    $.DispatchEvent("UIShowCustomLayoutParametersTooltip", target, "formulaTooltip", "file://{resources}/layout/custom_game/tooltips/formula_tooltip.xml", "towerName=" + towerName + "&towerType=" + towersT[towerName].Type);
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
  towersT = CustomNetTables.GetTableValue("game_state", "towers_table");
  $.Msg(towersT);
  GameEvents.Subscribe("formula_update", updateComponents);
  initFormulaRows(towersT);
})();