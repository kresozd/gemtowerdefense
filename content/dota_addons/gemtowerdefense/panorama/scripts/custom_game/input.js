var MAX_ROUND = 48;
var MIN_ROUND = 0;


function updateNumValue(value) {
  var textEntry = $('#round-value');
  textEntry.text = textEntry.text.replace(/\D/g,'');

  var oldValue = textEntry.text ? parseInt(textEntry.text) : 0;
  var newValue = oldValue + parseInt(value);

  if (newValue <= MIN_ROUND) {
    newValue = 1;
  } else if (newValue > MAX_ROUND) {
    return;
  }
  textEntry.text = newValue;
}