function setupTooltip() {
  var strTest = $.GetContextPanel().GetAttributeString( "nameid", "not-found" );
  $('#TooltipTitle').text = $.Localize('#gem_' + strTest);
  $('#TooltipType').text = "Type: " + $.Localize('#gem_' + strTest + '_type');
  $( '#TooltipDesc' ).text = "Description: " + $.Localize('#gem_' + strTest + '_description');
}