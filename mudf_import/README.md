mudf2Neo4j - MUDF Import to Neo4j
==========

This [National Day of Civic Hacking 2014](http://hackforchange.org/) project gets the The Museum Universe Data File (MUDF, containing basic identifying information of known museums in the United States) into the Neo4j graph database.

Organization source: [Institute of Museum and Library Services](http://www.imls.gov)
Data file 'home' page: http://www.imls.gov/research/museum_universe_data_file.aspx

The files in this directory include:

* __MUDF_Documentation_2014q3.pdf__ - This 12-page document details the format of the MUDF file as well as provide full information about the source and use of this public data file from the Institute of Museum and Library Services.
* __mudf14q3pub_csv.zip__ which is the original source of the MUDF provide by the IMLS
* __mudf14q3pub_TitleCase.csv__ - This 7.5 MD file can be loaded remotely via this file's GitHub URL, however it is usually a better choice to download the file and import it locally.
* __mudf2neo4j.cypher__ - This small file contains the Cypher graph database query statements to create the Museums Universe (USA) database in Neo4j. You may simply copy and paste its content into the query input pane of your Neo4j browser, or you may provide this file as a parameter to a Neo4j-shell session.
* __README.md__ - This file

> NOTE: The __mudf2neo4j.cypher__ script assumes you are running Neo4j 2.1 or later as it uses the LOAD CSV command introduced in 2.1.

## Data Model and Import Strategy

![A Sample Cypher Query on the MUDF dataset](https://raw.githubusercontent.com/FactMiners/mudf2Neo4j/master/mudf_import/images/museums_universe_query_sample.png)

The supplied CSV file contains descriptive information on over 35,000 U.S.-based GLAMs (Galleries, Libraries, Archives, and Museums, etc.). The data is gathered from a variety of sources. The data in the original CSV is -- for some good reason, we suppose -- in ALL CAPS. As we intend to use this dataset in user-friendly apps and educational materials, we performed a bulk curation on the source file to provide "Title Case" to the appropriate fields/columns. In addition, we did a bulk find and replace to tweak the ordinal references, e.g. 1st, 2nd, 3rd from the Title Cased 1St, 2Nd, 3Rd.

The MUDF Documentation PDF details the source and data field format of each column in the CSV file. A number of these fields are fine-grained bits related to demographic and geo-location information used for policy and program administration. Any field that was sufficiently obscure as to not be readily needed in a user-based "information discovery" app was excluded from the import. There are comments in the import script detailing where and how easy it is to adjust the data import configuration.

### The Data Model

__Each 'Museum' and its Properties__

Each row in the supplied MUDF file has information about a given 'museum' (so many flavors - See 'Discipline'). The "user-friendly" columns selected for the default import are as follows...

Column | Description
------ | ------
MID | Unique museum identifier 
NAME | Name of institution 
ALTNAME | Alternative name of institution 
ADDRESS | Address institution, Street address 
CITY | Address institution, City 
STATE | Address institution, State 
ZIP5 | Address institution, Postal zip code 
PHONE | Institution phone number 
WEBURL | Institution website address 
LATITUDE | Latitude of institution's address; this field consists of two integers and six decimal places, with an explicit decimal point, decimal degree format, World Geodetic System Datum 1984; determined by geocoding service. 
LONGITUDE | Longitude of institution's address; this field consists of a negative sign, three integers and six decimal places, with an explicit decimal point, decimal degree format, World Geodetic System Datum 1984; determined by geocoding service. 

#### The Four 'Node-ified' Properties

Four of the columns of interest are filled with codes that relate a given museum to a small number of property values that can be valuably "node-ified." That is, we're creating found sets of labeled Neo4j nodes that represent these distinct values and provide an explicit relationship link to connect the museum to its associated value -- as opposed to using a node property.

The four "node-ified" columns in the MUDF file are as follows...

__DISCIPL__

Each Discipline node represents an "archetype" node for a Museum discipline or type.

Code 	| Discipline
-------- | ----------- 
ART 	| Art Museums 
BOT 	| Arboretums, Botanical Gardens, & Nature Centers 
CMU 	| Children's Museums 
GMU 	| Uncategorized or General Museums 
HSC 	| Historical Societies, Historic Preservation 
HST 	| History Museums 
NAT 	| Natural History & Natural Science Museums 
SCI 	| Science & Technology Museums & Planetariums 
ZAW 	| Zoos, Aquariums, & Wildlife Conservation

Each Museum node will have one IS_TYPE relationship link to its designated Discipline.

__INCOMECD__

Income Codes relate to the amount of income shown on the most recent Form 990 series return filed by the organization. Information comes from Internal Revenue Service (IRS) Business Master File, March, 2014.

Code 	| Description
-------- | ---------: 
0 	| $0 
1 	| $1 to $9,999 
2 	| $10,000 to $24,999 
3 	| $25,000 to $99,999 
4 	| $100,000 to $499,999 
5 	| $500,000 to $999,999 
6 	| $1,000,000 to $4,999,999 
7 	| $5,000,000 to $9,999,999 
8 	| $10,000,000 to $49,999,999
9 	| $50,000,000 to greater

Each Museum node will have one IN_RANGE relationship link to its designated Income_Range. (This field is a convenient but potentially deceptive proxy property for a museum's "size" or "scope". It should be noted that some small museums may be "well-heeled" while large museums may have very small revenue streams. There is not field that explicitly details the visitor/contact scale of an institution.)

__LOCALE4__

 National Center for Education Statistics (NCES) Urban-Centric Locale Codes classification; based on geocoded address of institution. Additional information can be found at the following site: https://nces.ed.gov/ccd/rural_locales.asp 

Code 	| Name 		| Description 
-------- | ----------- | --------
1		| City 		| Territory inside an urbanized area and inside a principal city
2		| Suburb 	| Territory inside an urbanized area but outside a principal city  
3		| Town 		| Territory inside an urban cluster that is outside an urbanized area 
4		| Rural 	| Census-defined rural territory that is outside an urbanized area or urbanized cluster.

Each Museum node will have one IN_LOCALE relationship link to its designated Locale.

__AAMREG__

Museum Regions are determined by the American Alliance of Museums (AAM). Additional information can be found at the following site: http://www.aam-us.org/. 

Code 	| Name 			| Description 
-------- | -----------	| --------
1		| New England	| Connecticut, Massachusetts, Maine, New Hampshire, Rhode Island, Vermont 
2		| Mid-Atlantic 	| District of Columbia, Delaware, Maryland, New Jersey, New York, Pennsylvania 
3		| Southeastern	| Alabama, Arkansas, Florida, Georgia, Kentucky, Louisiana, Mississippi, North Carolina, South Carolina, Tennessee, Virginia, West Virginia
4		| Midwest		| Iowa, Illinois, Indiana, Michigan, Minnesota, Missouri, Ohio, Wisconsin 
5		| Mount Plains 	| Colorado, Kansas, Montana, North Dakota, Nebraska, New Mexico, Oklahoma, South Dakota, Texas, Wyoming 
6		| Western		| Alaska, Arizona, California, Hawaii, Idaho, Nevada, Oregon, Utah, Washington

Each Museum node will have one IN_REGION relationship link to its designated AAM (American Association of Museums) region.
