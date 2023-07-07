# NHR-data-dictionary

 <hr>

 **Omschrijving**:    Opstellen van data dictionary op basis van de pdf handboeken van de NHR          
 **Auteurs**:        Stephan van der Zwaard [s.vanderzwaard@amsterdamumc.nl]                                                      
 **Datum:**         22-06-2023                                                                                                 
 **Versie:**      1.0                                                                                                        
 **R.versie:**    4.2.1 (2022-06-23)   
 
 <hr>
 
  <h2> Project documentatie </h2>

 <hr>
 
**Achtergrond**:  De Nederlandse Hart Registratie (NHR) bewaakt de kwaliteit van hartzorg in Nederland middels meerdere kwaliteitsregistraties. Hiervoor zijn meerdere handboeken opgesteld (in pdf) waarin relevante variabelen voor elke registratie benoemd zijn. Probleem is dat doordat variabelen alleen zichtbaar zijn in pdf, deze moeilijk doorzoekbaar zijn en er geen andere bestaande data dictionary aanwezig is.

**Doelstelling**: Doel van dit project is om een doorzoekbare data dictionary op te stellen op basis van de bestaande handboeken van de NHR. Hiervoor is een automatisch script voor geschreven. 

**Over de NHR**: Het is de missie van de NHR om bij te dragen aan de kwaliteitsbewaking en -bevordering binnen de hartzorg in Nederland. De NHR verwezenlijkt dit doel door, namens de aangesloten ziekenhuizen en in intensieve samenwerking met gemandateerde artsen, kwaliteitsregistraties in stand te houden. Door de integrale, kwalitatief hoogwaardige en innovatieve kwaliteitsregistraties kunnen artsen kwaliteit van zorg bewaken en verbeteren. Op deze manier wordt het belang van de hartpatiënt gediend.

**Over de registraties**: Voor de selectie van de NHR-variabelensets is de NHR-methode in het leven geroepen. Hiermee beogen de registratiecommissies en de NHR gezamenlijk maximaal relevante inzichten te creëren met kwaliteitsdata, tegen zo min mogelijk registratielast. Het betreft een set van indicatoren en case-mixfactoren. De Value Based HealthCare (VHBC) theorie zal daarbij een van de uitgangspunten zijn. Lees meer over de [NHR methode](https://nhr.nl/wp-content/uploads/2021/11/Methode-NHR-versie-4.0.pdf) of bekijk de [handboeken van de registraties](https://nhr.nl/handboeken/), waaronder:

- Ablatie
- Atriumfibrilleren
- Cardiochirurgie
- ConHC
- Hartfalen
- KinCOR CONCOR
- Pacemaker/ICD
- PCI
- THI

 <hr>
 
<h4> Main script </h3>

Het main script wordt gebruikt om de data dictionary op te stellen op basis van de NHR handboeken. Dit script roept andere subfuncties en scripts aan die zich in de `scripts` subfolder bevinden.
                                                                                                    
<br>                                                                                                                          
<h4> Handbooks/ </h3>

De `Handbooks` subfolder bevat alle handboeken met relevante variable beschrijvingen in pdf-formaat.

<br>                                                                                                                          
<h4> Scripts/ </h3>

De `Scripts` subfolder bevat alle benodigde code om de variabelen die genoemd worden in de handboeken om te zetten in een doorzoekbare data dictionary. Hiervoor wordt ook de nodige processing gedaan. 


<hr>
