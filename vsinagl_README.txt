Ahoj, pridal jsem par zmen, ktere opravili errory u francinettu, jeste to ale neni kompletni reseni. Jsou tam po upravach memory leaky, jak v trippouille tak francinette
---->  v error.log jsou errorove hlasky ktere dal francinette.

MOJE ZMENY:
=================================================================
---->  upravil jsem: volani read funkce, mel si tam standartni velikost cteni na 1byte, je treba specifikovat tolik bajtu, kolik je v ulozeno v BUFFER_SIZE promenne.
---->  pridal jsem na zacatek get_next_line funkce cekovani erroru
----> vsechny zmeny maji komentar v kodu, kdyz sjedes norminette poznas kde jsem to vsude upravoval.
=================================================================