var formulaRoot = null;
var tabs = ['formula', 'leaderboard', 'profile'];

function closeAllTabs() {
  $('#tab-about').AddClass('tab-hidden');
  $('#tab-profile').AddClass('tab-hidden');
  $('#tab-leaderboard').AddClass('tab-hidden');
  $('#tab-formula').AddClass('tab-hidden');
}


function activateTab(tabName) {
  var tab = $('#' + tabName);
  if (!tab.BHasClass('tab-hidden')) {
    tab.AddClass('tab-hidden');
    $.GetContextPanel().AddClass('tabs-hidden');
  } else {
    closeAllTabs();
    tab.RemoveClass('tab-hidden');
    $.GetContextPanel().RemoveClass('tabs-hidden');
  }
}


function toggleFormulaLayout() {
  var isMinimized = formulaRoot.BHasClass('tab-formula-min');
  var label = $('#minify-label');
  formulaRoot.SetHasClass('tab-formula-min', !isMinimized)
  label.text = !isMinimized ? 'expand table' : 'minimize table'
  Game.EmitSound("ui_generic_button_click");
}


function hideNav() {
  if (!$.GetContextPanel().BHasClass('tabs-hidden')) {
    $('#tabs-nav-container').AddClass('hidden', true);
    $('#tabs-nav').hittest = true;
  }
}


function showNav() {
  var navContainer = $('#tabs-nav-container');
  if (!$.GetContextPanel().BHasClass('tabs-hidden') || navContainer.BHasClass('hidden')) {
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
  for (var name of tabs) {
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