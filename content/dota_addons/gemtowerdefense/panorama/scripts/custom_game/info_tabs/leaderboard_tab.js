var activeTab = 0;
var tabs = $('#leaderboard-tabs').Children();
var buttons = $('#leaderboard-nav').FindChildrenWithClassTraverse('leaderboard-button');
var leaderboards = ['one-player', 'two-player', 'three-player', 'four-player'];

function activateLeaderboardTab(num) {
  if (num !== activeTab) {
    tabs[activeTab].RemoveClass("leaderboard-tab-activated");
    tabs[num].AddClass("leaderboard-tab-activated");

    buttons[num].AddClass("leaderboard-button-active");
    buttons[activeTab].RemoveClass("leaderboard-button-active");

    activeTab = num;
  }
}

// temporary just for showcase
function addLeaderboardWinners() {
  var localInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());
  var localSteam = localInfo.player_steamid;

  for (var name of leaderboards) {

    var leaderboardPanel = $('#leaderboard-' + name).GetChild(0);

    for (var i = 1; i <= 10; i++) {

      var leaderboardItem = $.CreatePanel('Panel', leaderboardPanel, '');
      leaderboardItem.BLoadLayoutSnippet(name + '-item');
      
      if (i <= 3) {
        leaderboardItem.AddClass('leaderboard-top');
      }

      leaderboardItem.FindChildTraverse('leaderboard-place-value').text = i + '.';
      var players = leaderboardItem.FindChildTraverse('leaderboard-players'); 

      for (var j = 0; j < players.GetChildCount(); j++) {

        if (name == 'one-player') {
          var steam = randomSteam(localSteam);
          players.GetChild(0).steamid = steam;
          players.GetChild(1).steamid = steam;
          continue;
        }

        players.GetChild(j).steamid = randomSteam(localSteam);
      }
    }
  }
}


function randomSteam(steam) {
  var random = Math.floor(Math.random() * (99 - 10 + 1)) + 10;
  result = steam.slice(0, -2) + random;
  
  return result;
}


(function() {
  addLeaderboardWinners();
})();