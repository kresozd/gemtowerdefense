

function updateRound(table, key, data) {
  if (key == 'current_round') {
    $('#round-value').text = data.value;
  }
}


(function() {
  CustomNetTables.SubscribeNetTableListener('game_state', updateRound);
})();