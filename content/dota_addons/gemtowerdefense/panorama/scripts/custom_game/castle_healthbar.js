

function updateCastleHealth(table, key, data) {
  if (key == 'gem_castle_health') {
    var health = data.value;
    $("#castle-health-value").text = health + '%';
    $("#castle-health-progress").style.width = health > 0 ? health + '%' : '0%';
  }
}


(function() {
  CustomNetTables.SubscribeNetTableListener( 'game_state', updateCastleHealth );
})();