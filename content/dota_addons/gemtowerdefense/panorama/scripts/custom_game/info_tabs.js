var formulaRoot = null;
var tabNames = ['formula', 'leaderboard', 'profile'];
var Root = $.GetContextPanel();
var tabs = Root.FindChildrenWithClassTraverse('info-tab');


function closeAllTabs() {
  for (var tab of tabs) {
    tab.AddClass('tab-hidden');
  }
}


function activateTab(tabName) {
  var tab = $('#' + tabName);

  if (!tab.BHasClass('tab-hidden')) {
    tab.AddClass('tab-hidden');
    Root.AddClass('tabs-hidden');
  } else {
    closeAllTabs();
    tab.RemoveClass('tab-hidden');
    Root.RemoveClass('tabs-hidden');
  }
}


function toggleFormulaLayout() {
  formulaRoot.ToggleClass('tab-formula-min');
  Game.EmitSound("ui_generic_button_click");
}


function hideNav() {
  if (!Root.BHasClass('tabs-hidden')) {
    $('#tabs-nav-container').AddClass('hidden', true);
    $('#tabs-nav').hittest = true;
  }
}


function showNav() {
  var navContainer = $('#tabs-nav-container');

  if (!Root.BHasClass('tabs-hidden') || navContainer.BHasClass('hidden')) {
    navContainer.RemoveClass('hidden');
    navContainer.hittest = false;
  }
}


function showHotkeyTooltip() {
  $.DispatchEvent("DOTAShowTextTooltip", $("#button-formula"), "Hotkey info");
}


function hideHotkeyTooltip() {
  $.DispatchEvent("DOTAHideTextTooltip", $("#button-formula"));
}


function initInfoTabs() {
  for (var name of tabNames) {
    var tab = $('#tab-' + name);
    var tabPanel = $.CreatePanel('Panel', tab, name);
    tabPanel.BLoadLayout("file://{resources}/layout/custom_game/info_tabs/" + name + "_tab.xml", false, false);
    
    if (name == 'formula') {
      formulaRoot = tabPanel;
    }
  }
}


(function() {
  initInfoTabs();
})();