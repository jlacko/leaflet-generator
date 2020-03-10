# leaflet-generator

This is the English version of source code for leaflet map generator. The English version of the app is running on www.jla-data.net/eng/jla-leaflet-generator/  (on www.jla-data.net/cze/jla-leaflet-generator/ is the Czech version - the two versions are in principle indentical).

Javascript library [leaflet](https://leafletjs.com/) is a practical, if not excactly user friendly, tool for creating of interactive maps.

This shiny app aims to sidestep the need to master either Javascript and / or R syntax required to create a valid leaflet map. It will create a downloadable HTML document based on Excel file of GPS coordinates, together with clickable labels with option of using HTML syntax (such as bold & italic script, line breaks and / or hyperlinks to other pages).

This downloadable content can be then re-used in a general HTML context, for example in an iframe (which means that it can not be demonstrated in GitHub context, for iframes are not supported here).

<p align="center">
  <img src="https://github.com/jlacko/leaflet-generator/blob/master/data-raw/screenshot.png?raw=true" alt="náhled na výstup"/>
</p>


The app expects as input an *xlsx* file with 6 columns:

* *id* – primary key, bold first line of a popup
* *lng* – longitude of a point coordinate
* *lat* – latitude of a point coordinate
* *category* – category of points; determines color of markers
* *label* – body of popup; may contain HTML code if required

A sample of data in expected structure can be downloaded by following [this link](https://github.com/jlacko/leaflet-generator/blob/english/data-raw/sample.xlsx?raw=true).
