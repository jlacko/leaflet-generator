# leaflet-generator

Toto je repozitář zdrojového kódu pro generátor leafletových map. Vlastní aplikace běží na www.jla-data.net/cze/jla-leaflet-generator/.

Javascriptová knihovna [leaflet](https://leafletjs.com/) je praktický nástroj pro tvorbu interaktivních map a přesvědčivou vizualizaci prostorových dat.

V zájmu obecnosti řešení jde nástroj poměrně složitý, což může mít za následek obtíže pro uživatele, jejichž silné stránky jsou jinde než v technice.

Tato jednoduchá aplikace umožňuje vytvořit z nahraného excelového souboru technicky korektní leaflet mapu, a uložit jí jako HTML soubor pro další použití; například je možné jí zobrazit na stránkách internetu v iframe (které zde neukážu, protože ho GitHub nepodporuje :).

<p align="center">
  <img src="https://github.com/jlacko/leaflet-generator/blob/master/data-raw/screenshot.png?raw=true" alt="náhled na výstup"/>
</p>


Stránka očekává jako vstup excelový soubor se 6 sloupci:

* *id* coby klíč, tučný nadpis popisku

* *lng* coby zeměpisná délka; v Čechách a na Moravě by měla být někde mezi 12 a 18

* *lat* coby zeměpisná šířka; v Čechách a na Moravě by měla být někde mezi 48 a 51

* *kategorie* určuje barvu bodů

* *popisek* tělo popisku; může obsahovat HTML kód

Vzorek dat v očekávané struktuře je možné stáhnout [na tomto odkazu](https://github.com/jlacko/leaflet-generator/blob/master/data-raw/vzorek.xlsx?raw=true).
