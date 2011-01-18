// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function textCounter(textarea, countdown, maxlimit)
{
  textareaid = document.getElementById(textarea);
  if (textareaid.value.length > maxlimit)
    textareaid.value = textareaid.value.substring(0, maxlimit);
  else
    document.getElementById(countdown).value = (maxlimit-textareaid.value.length);
}