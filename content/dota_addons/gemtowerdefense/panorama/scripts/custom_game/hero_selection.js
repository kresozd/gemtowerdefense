GameUI.CustomUIConfig().player_level = 1;
var playerLevel = GameUI.CustomUIConfig().player_level;
var selectedHero = '';
var pickedHero = '';
var heroPreviews = {};
var heroButtons = {};
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
    level: 1
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


function initHeroButtons() {
  var heroContainer = $('#hero-list');
  
  for (var hero in allHeroes) {
    var isPicked = false;
    var heroName = allHeroes[hero].name;
    var isAvailable = checkHeroLevel(hero);

    var heroButton = heroContainer.FindChild(heroName);
    
    if (heroButton === null) {
      heroButton = $.CreatePanel('Panel', heroContainer, heroName);
      heroButton.BLoadLayoutSnippet('hero-button');
      heroButton.FindChildTraverse('hero-image').heroname = heroName;
    }
    
    heroButton.SetHasClass('hero-locked', !isAvailable);

    heroButtons[heroName] = {
      button: heroButton,
      isAvailable: isAvailable
    }
    
    updateHeroButton(heroName, isAvailable);
    addHeroButtonEvent(heroButton, heroName);
  }
}


function checkHeroLevel(hero) {
  return playerLevel >= allHeroes[hero].level;
}


function addHeroButtonEvent(button, heroName) {
  
  var onActivate = function() {
    if (selectedHero == heroName || pickedHero) {
      return;
    }

    var isAvailable = heroButtons[heroName].isAvailable;

    if (selectedHero) {
      $('#' + selectedHero).RemoveClass('hero-selected');
      heroPreviews[selectedHero].style.visibility = 'collapse';
    }

    button.AddClass('hero-selected');
    $('#hero-name-title').text = $.Localize('#' + heroName).toUpperCase();
    heroPreviews[heroName].style.visibility = 'visible';

    updateHeroButton(heroName);
    updatePickButton(isAvailable);

    selectedHero = heroName;
    GameEvents.SendCustomGameEventToServer('player_selected_hero', {hero: selectedHero});
  }

  button.SetPanelEvent('onactivate', onActivate);
}


// fake queries for multiplayer debugging
$.Schedule(5, function() {
  updateHeroButtons('', '', {
    picked: {
      1: 'npc_dota_hero_crystal_maiden',
      2: 'npc_dota_hero_vengefulspirit',
    }
  });
});


$.Schedule(10, function() {
  updateHeroButtons('', '', {
    picked: {
      1: 'npc_dota_hero_crystal_maiden',
      2: 'npc_dota_hero_vengefulspirit',
      3: 'npc_dota_hero_invoker',
    }
  });
});


function updateHeroButton(heroName) {
  var heroButton = heroButtons[heroName];
  var isAvailable = heroButton.isAvailable;

  heroPreviews[heroName].SetHasClass('hero-not-available', !isAvailable && pickedHero !== heroName);
  heroButton.button.SetHasClass('hero-not-available', !isAvailable);
}


function updateHeroButtons(table, key, data) {
  var pickedHeroes = data.picked || {};

  for (var player in pickedHeroes) {
    var hero = pickedHeroes[player];

    heroButtons[hero].isAvailable = false;
    updateHeroButton(hero);

    if (selectedHero == hero) {
      updatePickButton(false);
    }

    var data = {};
    data.player = player;
    data.hero = hero;

    updatePlayerState(data, true);
  }
}


function updatePickButton(isEnabled) {
  $('#pick-hero-button').enabled = isEnabled;
}


function preloadPreview(hero, value) {
  var previewList = $('#hero-preview-list');
  var preview = $.CreatePanel('Panel', previewList, '');
  preview.AddClass('hero-preview');

  previewList.MoveChildAfter(preview, $('#hero-abilities'));
  preview.style.visibility = 'collapse';

  var loading = $.CreatePanel('Panel', preview, '');
  loading.AddClass('preloader' );

  var queueElement = {
    container: preview,
    children: value,
    loadingImage: loading
  };

  previewLoadingQueue.push(queueElement);

  return preview;
}


function preloadHeroPreviews(heroes) {
  for (var hero in heroes) {
    var heroName = heroes[hero].name;
    heroPreviews[heroName] = preloadPreview(heroName, "<DOTAScenePanel antialias='true' class='hero-preview-scene' unit='" + heroName + "' always-cache-composition-layer='true' />");
  }
}


function checkPreviews() {
  $.Schedule(0.01, checkPreviews);

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
  if (!selectedHero || pickedHero) {
    $.Msg('Scooby Doo where are you');
    return;
  }

  GameEvents.SendCustomGameEventToServer('player_picked_hero', {hero : selectedHero});
  pickedHero = selectedHero;
  $('#hero-selection-rays').RemoveClass('is-hidden');
  switchButtons();
}


function endHeroSelection() {
  var Root = $.GetContextPanel();
  Root.style.opacity = 0;

  $.Schedule(1.5, function() {
    Root.DeleteAsync(0);
  });
}


function initProfileLevel() {
  var profileContainer = $('#player-level-container');
  var playerLevel = $.CreatePanel('Panel', profileContainer, '');
  playerLevel.BLoadLayout("file://{resources}/layout/custom_game/player_level.xml", false, false);
}


function initPlayerState(id, playerInfo) {
  var playerContainer = $('#player-state');
  var steamid = playerInfo.player_steamid;
  var playerItem = $.CreatePanel('Panel', playerContainer, 'player-state-' + id);

  playerItem.BLoadLayoutSnippet('player-state');

  var userName = playerItem.FindChildTraverse('player-username');
  userName.steamid = steamid;
  userName.style.color = GameUI.CustomUIConfig().player_colors[id];

  playerItem.FindChildTraverse('player-avatar').steamid = steamid;
}


function updatePlayerState(data, isPicked) {
  var hero = data.hero;
  var player = data.player;
  var playerState = $('#player-state-' + player);

  if (playerState) {
    playerState.FindChildTraverse('player-state-hero').heroname = hero;
    playerState.SetHasClass('player-state-picked', !!isPicked);
  }
}


// A bit of a hack due to lack of css property 'animation-fill-mode' in panorama 
function switchButtons() {
  $('#hero-selection-footer').AddClass('animation-run');

  $.Schedule(.85, function() {
    $('#hero-selection-footer').RemoveClass('animation-run');
    $('#hero-selection-footer').AddClass('animation-end');
  });
}


function test() {
}


function onTimeUpdate(data) {
  $('#hero-selection-timer').text = data.time;
}


(function() {
  $('#pick-hero-button').enabled = false;

  GameEvents.Subscribe("player_selected_hero_client", updatePlayerState);
  // GameEvents.Subscribe("picking_done", endHeroSelection);
  GameEvents.Subscribe("picking_time_update", onTimeUpdate);
  CustomNetTables.SubscribeNetTableListener('game_state', updateHeroButtons);

  checkPreviews();
  preloadHeroPreviews(allHeroes);
  initHeroButtons();
  initProfileLevel();

  var players = Game.GetAllPlayerIDs();

  for (var i = 0; i < players.length; i++) {
    var playerInfo = Game.GetPlayerInfo(0);
    initPlayerState(i, playerInfo);
	}
})();