var formulaRoot = null;

function closeAllTabs() {
  $('#tab-about').AddClass('tab-hidden');
  $('#tab-profile').AddClass('tab-hidden');
  $('#tab-rank').AddClass('tab-hidden');
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


function updateFormulaTab() {
  var formula = $('#tab-formula');
  var formulaPanel = $.CreatePanel('Panel', formula, 'formula');
  formulaPanel.BLoadLayout("file://{resources}/layout/custom_game/info_tabs/formula_tab.xml", false, false);
  formulaRoot = formulaPanel;
}


function updateProfileTab() {
  var profile = $('#tab-profile');
  var profilePanel = $.CreatePanel('Panel', profile, 'profile');
  profilePanel.BLoadLayout("file://{resources}/layout/custom_game/info_tabs/profile_tab.xml", false, false);
}


(function() {
  updateFormulaTab();
  updateProfileTab();
})();