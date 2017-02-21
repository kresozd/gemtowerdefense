function setupTooltip() {
  var tower = $.GetContextPanel().GetAttributeString( "towerName", "not-found" );
  var towerType = $.GetContextPanel().GetAttributeString( "towerType", "not-found" );

  $.GetContextPanel().AddClass('tower-' + towerType.toLowerCase());

  $('#tooltip-title').text = $.Localize('#' + tower);
  $('#tooltip-type').text = "Type: <span class=\"tooltip-type-mod\">" + $.Localize('#' + towerType) + "</span>";
  $( '#tooltip-desc' ).text = $.Localize('#' + tower + '_description');
}