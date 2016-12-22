function closeAllBoards() {
  $('#board-about').SetHasClass('board-hidden', true);
  $('#board-store').SetHasClass('board-hidden', true);
  $('#board-rank').SetHasClass('board-hidden', true);
  $('#board-formula').SetHasClass('board-hidden', true);
}


var activatedBoard;

function activateBoard(board) {
  closeAllBoards();
  if (activatedBoard == board) {
    activatedBoard = 'none';
  } else {
    activatedBoard = board;
    $('#' + board).SetHasClass('board-hidden', false);
  }
}


function changeFormulaLayout() {
  var board = $('#board-formula');
  var label = $('#minify-label');
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
    $('#gem-nav-container').SetHasClass('hidden', true);
  }
}

function showNav() {
  if (!$('#board-formula').BHasClass('board-hidden')) {
    $('#gem-nav-container').SetHasClass('hidden', false)
  }
}