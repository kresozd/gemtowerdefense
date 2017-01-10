function closeAllBoards() {
  $('#board-about').AddClass('board-hidden');
  $('#board-store').AddClass('board-hidden');
  $('#board-rank').AddClass('board-hidden');
  $('#board-formula').AddClass('board-hidden');
}


function activateBoard(boardName) {
  var board = $('#' + boardName);
  if (!board.BHasClass('board-hidden')) {
    board.AddClass('board-hidden');
    $.GetContextPanel().AddClass('boards-hidden');
  } else {
    closeAllBoards();
    board.RemoveClass('board-hidden');
    $.GetContextPanel().RemoveClass('boards-hidden');
  }
}


function toggleFormulaLayout() {
  var board = $('#board-formula');
  var label = $('#minify-label');
  Game.EmitSound("ui_generic_button_click");
  if (board.BHasClass('board-formula-min')) {
    board.SetHasClass('board-formula-min', false);
    label.text = 'minify table';
  } else {
    board.SetHasClass('board-formula-min', true);
    label.text = 'expand table';
  }
}


function hideNav() {
  if (!$.GetContextPanel().BHasClass('boards-hidden')) {
    $('#boards-nav-container').SetHasClass('hidden', true);
    $('#boards-nav').hittest = true;
  }
}


function showNav() {
  var navContainer = $('#boards-nav-container');
  if (!$.GetContextPanel().BHasClass('boards-hidden') || navContainer.BHasClass('hidden')) {
    navContainer.SetHasClass('hidden', false);
    navContainer.hittest = false;
  }
}


// Temporary dynamic event setting, until we get full list of towers
function initTooltips() {
  var results = $("#board-formula").FindChildrenWithClassTraverse("formula-result");
  var resultContainer;
  for (var i = 0; i < results.length; i++) {
    
    resultContainer = results[i].GetParent();

    resultContainer.SetPanelEvent(
      "onmouseover",
      function(resultContainer) {
        return function() {
          // we need to apply tooltip target properly according to table state minimized/expanded
          var isMinimized = $("#board-formula").BHasClass('board-formula-min');
          var resultInner = resultContainer.FindChildrenWithClassTraverse('formula-tower-inner')[0];
          var target = isMinimized ? resultContainer : resultInner;
          
          $.DispatchEvent("UIShowCustomLayoutParametersTooltip", target, "formulaTooltip", "file://{resources}/layout/custom_game/tooltips/formula_tooltip.xml", "nameid=" + resultContainer.id);
        }
      }(resultContainer));
      
    resultContainer.SetPanelEvent(
      "onmouseout",
      function() {
        $.DispatchEvent("UIHideCustomLayoutTooltip", "formulaTooltip");
      }
    ); 
  }
}


function showHotkeyTooltip() {
  $.DispatchEvent("DOTAShowTextTooltip", $("#button-formula"), "Hotkey info");
}


function hideHotkeyTooltip() {
  $.DispatchEvent("DOTAHideTextTooltip", $("#button-formula"));
}


function updatePlayerProfile() {
  var profileContainer = $('#player-level-container');
  $.Msg(profileContainer);
  var playerLevel = $.CreatePanel('Panel', profileContainer, '');
  playerLevel.BLoadLayout("file://{resources}/layout/custom_game/player_level.xml", false, false);
}


(function() {
  initTooltips();
  updatePlayerProfile();
})();