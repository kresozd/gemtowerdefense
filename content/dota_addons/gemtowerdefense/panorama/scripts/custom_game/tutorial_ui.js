var tutorialPages = ['intro', 'basics', 'mazing'];
var currentPage = 0;


function initTutorial() {

  var content = $('#tutorial-content');
  var menu = $('#menu-list');

  for (var page in tutorialPages) {

    var pageName = tutorialPages[page];
    var menuItem = $.CreatePanel('Panel', menu, 'menu-item-' + page);

    menuItem.AddClass('menu-item');
    $.CreatePanel('Label', menuItem, '').text = +page + 1;

    addMenuEvent(menuItem, page);

    var tutorialPage = $.CreatePanel('Panel', content, 'content-' + page);

    tutorialPage.BLoadLayout('file://{resources}/layout/custom_game/tutorial_pages/tutorial_' + pageName + '.xml', false, false);
  }

  updateNavigation();
  showPage(0);
}


function addMenuEvent(menu, page) {
  menu.SetPanelEvent('onactivate', function () {
    showPage(page);
  });
}


function showPage(page) {

  if (page >= 0 && page < tutorialPages.length) {

    var currentMenuItem = $('#menu-item-' + currentPage);
    var currentPageContent = $('#content-' + currentPage);

    $('#title-label').text = tutorialPages[page].toUpperCase();

    if (currentMenuItem) {
      currentMenuItem.RemoveClass('menu-item-selected')
      $('#menu-item-' + page).AddClass('menu-item-selected')
    }

    if (currentPageContent) {
      currentPageContent.RemoveClass('content-active');
      $('#content-' + page).AddClass('content-active');
    }
  } else {
    return;
  }

  currentPage = page;
  updateNavigation();
}


function showPrevPage() {
  showPage(+currentPage - 1);
}


function showNextPage() {
  showPage(+currentPage + 1);
}


function updateNavigation() {

  if (currentPage == 0) {
    $("#tutorial-prev").enabled = false;
  } else {
    $("#tutorial-prev").enabled = true;
  }

  if (currentPage == tutorialPages.length - 1) {
    $("#tutorial-next").enabled = false;
  } else {
    $("#tutorial-next").enabled = true;
  }
}


function toggleTutorial() {
  $.GetContextPanel().ToggleClass('tutorial-hidden');
  Game.EmitSound("ui_quit_menu_fadeout");
}


(function () {
  initTutorial();
})();