function setupTooltip() {
  var strTest = $.GetContextPanel().GetAttributeString( "nameid", "not-found" );
  $('#tooltip-title').text = $.Localize('#gem_' + strTest);
  $('#tooltip-type').text = "Type: " + $.Localize('#gem_' + strTest + '_type');
  $( '#tooltip-desc' ).text = "Description: " + $.Localize('#gem_' + strTest + '_description');
}