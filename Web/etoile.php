<?php
function etoile(float $note)
{
	if ($note < 0.5) {
		echo '<img id="etoile" src="include/img/etoile/etoile-0.png">';
	} else if ($note >= 0.5 && $note < 1) {
		echo '<img id="etoile" src="include/img/etoile/etoile-05.png">';
	} else if ($note >= 1 && $note < 1.5) {
		echo '<img id="etoile" src="include/img/etoile/etoile-1.png">';
	} else if ($note >= 1.5 && $note < 2) {
		echo '<img id="etoile" src="include/img/etoile/etoile-15.png">';
	} else if ($note >= 2 && $note < 2.5) {
		echo '<img id="etoile" src="include/img/etoile/etoile-2.png">';
	} else if ($note >= 2.5 && $note < 3) {
		echo '<img id="etoile" src="include/img/etoile/etoile-25.png">';
	} else if ($note >= 3 && $note < 3.5) {
		echo '<img id="etoile" src="include/img/etoile/etoile-3.png">';
	} else if ($note >= 3.5 && $note < 4) {
		echo '<img id="etoile" src="include/img/etoile/etoile-35.png">';
	} else if ($note >= 4 && $note < 4.5) {
		echo '<img id="etoile" src="include/img/etoile/etoile-4.png">';
	} else if ($note >= 4.5 && $note < 5) {
		echo '<img id="etoile" src="include/img/etoile/etoile-45.png">';
	} else if ($note = 5) {
		echo '<img id="etoile" src="include/img/etoile/etoile-5.png">';
	}
}
?>