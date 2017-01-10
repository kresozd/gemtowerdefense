var selectedHero = '';
var playerLevel = 1;
var heroPreviews = {};
var previewLoadingQueue = [];
var previewSchedule = 0;

var allHeroes = {
  crystal_maiden: {
    name: 'npc_dota_hero_crystal_maiden',
    level: 1
  },
  vengefulspirit: {
    name: 'npc_dota_hero_vengefulspirit',
    level: 1
  },
  sniper: {
    name: 'npc_dota_hero_sniper',
    level: 1
  },
  enchantress: {
    name: 'npc_dota_hero_enchantress',
    level: 1
  },
  invoker: {
    name: 'npc_dota_hero_invoker',
    level: 2
  },
  nervermore: {
    name: 'npc_dota_hero_nevermore',
    level: 2
  },
  zeus: {
    name: 'npc_dota_hero_zuus',
    level: 2
  }
}



function addHeroButtons() {
  for (var hero in allHeroes) {
    var heroName = allHeroes[hero].name;
    var heroContainer = $('#hero-list');
    var heroButton = $.CreatePanel('Panel', heroContainer, heroName);
    var isAvailable = playerLevel < allHeroes[hero].level;
    heroButton.SetHasClass('hero-not-available', isAvailable);
    heroButton.BLoadLayoutSnippet('hero-button');
    heroButton.FindChildTraverse('hero-image').heroname = heroName;
    addButtonEvent(heroButton, heroName, isAvailable);
  }
}


function addButtonEvent(button, heroName) {
  button.SetPanelEvent(
    'onactivate',
    function(heroName, isAvailable) {
      return function() {

        if (selectedHero == heroName) {
          return;
        }

        var heroTitle = $('#hero-name-title');
        var isAvailable = button.BHasClass('hero-not-available');

        if (selectedHero) {
          $('#' + selectedHero).RemoveClass('hero-selected');
          heroPreviews[selectedHero].style.visibility = 'collapse';
        }

        button.AddClass('hero-selected');
        heroTitle.text = $.Localize('#' + heroName).toUpperCase();
        heroPreviews[heroName].style.visibility = 'visible';
        heroPreviews[heroName].SetHasClass('hero-not-available', isAvailable);
        
        selectedHero = heroName;

        $('#pick-hero-button').disabled = isAvailable;
        $('#pick-hero-button').SetHasClass('pick-hero-disabled', isAvailable)
      }
    }
  (heroName));
}


function PreloadPreview(hero, value) {
  var previewList = $('#hero-preview-list');
  var preview = $.CreatePanel('Panel', previewList, '');
  preview.AddClass('hero-preview');

  previewList.MoveChildAfter(preview, $('#hero-abilities'));
  preview.style.visibility = 'collapse';

  var loading = $.CreatePanel('Panel', preview, '');
  loading.AddClass('loading-image');
  loading.AddClass('hero-preview-loading'); 

  var queueElement = {
    container: preview,
    children: value,
    loadingImage: loading
  };

  previewLoadingQueue.push(queueElement);

  return preview;
}


function PreloadHeroPreviews(heroes) {
  for (var hero in heroes) {
    var heroName = heroes[hero].name;
      heroPreviews[heroName] = PreloadPreview(heroName, "<DOTAScenePanel antialias='true' class='hero-preview-scene' unit='" + heroName + "' always-cache-composition-layer='true'/>");
  }
}


function CheckPreviews() {
  $.Schedule(0.01, CheckPreviews);

  var somethingIsLoading = false;
  var notLoadedContainer = null;

  for (var data of previewLoadingQueue) {
    var container = data.container;
    var children = container.Children();
    var hasScene = false;

    for (var child of children) {
      if (child.paneltype == 'DOTAScenePanel') {
        hasScene = true;

        if (!child.BHasClass('SceneLoaded')) {
          somethingIsLoading = true;
          break;
        }
      }
    }

    if (somethingIsLoading) {
      break;
    }

    if (!hasScene && !notLoadedContainer) {
      notLoadedContainer = data;
    }
  }

  if (!somethingIsLoading && !!notLoadedContainer) {
    notLoadedContainer.container.BCreateChildren(notLoadedContainer.children);
    notLoadedContainer.loadingImage.DeleteAsync(0);
  }
}


function pickHero() {
  if ($('#pick-hero-button').disabled || !selectedHero) {
    $.Msg('Scooby Doo where are you');
    return;
  }

  GameEvents.SendCustomGameEventToServer('player_selected_hero', {selected_hero : selectedHero});
  endHeroSelection();
}


function endHeroSelection() {
  var Root = $.GetContextPanel();
  Root.style.opacity = 0;
  $.Schedule(1.5, function() {
    Root.DeleteAsync(0);
  });
}


function updateProfileLevel() {
  var profileContainer = $('#player-level-container');
  var playerLevel = $.CreatePanel('Panel', profileContainer, '');
  playerLevel.BLoadLayout("file://{resources}/layout/custom_game/player_level.xml", false, false);
}


(function() {
  $('#pick-hero-button').disabled = true;

  CustomNetTables.SubscribeNetTableListener('game_state', endHeroSelection);

  updateProfileLevel();
  CheckPreviews();
  PreloadHeroPreviews(allHeroes);
  addHeroButtons();

  var players = Game.GetAllPlayerIDs();
  var panel = $('#players-states').FindChildrenWithClassTraverse('players-states-item');

  for (var i = 0; i < players.length; i++) {
    var playerInfo = Game.GetPlayerInfo(i);
    var target = panel[i];

    for (var j = 0; j < target.GetChildCount(); j++) {
      target.GetChild(j).steamid = playerInfo.player_steamid;
      target.style.visibility = 'visible';
    }
	}

})();