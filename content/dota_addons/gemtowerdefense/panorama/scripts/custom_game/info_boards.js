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
  } else {
    closeAllBoards();
    board.RemoveClass('board-hidden');
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
  if (!$('#board-formula').BHasClass('board-hidden')) {
    $.Msg('hello hide');
    $('#boards-nav-container').SetHasClass('hidden', true);
    $('#boards-nav').hittest = true;
  }
}


function showNav() {
  var navContainer = $('#boards-nav-container');
  if (!$('#board-formula').BHasClass('board-hidden') || navContainer.BHasClass('hidden')) {
    $.Msg('hello showe');
    navContainer.SetHasClass('hidden', false);
    navContainer.hittest = false;
  }
}