// File: mudf2neo4j.cypher
// Prepared by: www.FactMiners.org (@FactMiners, www.FactMiners.org) and Jim Salmons (@Jim_Salmons)
// Prepared for: National Day of Civic Hacking 2014
// Version: 0.1
// Date: 01 June 2014
// 
//
// The Cypher queries in this file can be copied and pasted into a Neo4j 
// browser active on an empty database and executed to load the
// Museums Universal Data File (MUDF) into Neo4j.
// 
// These queries assume you are running Neo4j 2.1 or above as we use
// the 2.1 new LOAD CVS feature.
//
// Four fields in the MUDF CSV input file were selected to be 'node-ified' and related...
//
// You may need this if you have memory issues while importing...
// USING PERIODIC COMMIT
//
// DISCIPL
// Code 	Discipline 
// ART 		Art Museums 
// BOT 		Arboretums, Botanical Gardens, & Nature Centers 
// CMU 		Children's Museums 
// GMU 		Uncategorized or General Museums 
// HSC 		Historical Societies, Historic Preservation 
// HST 		History Museums 
// NAT 		Natural History & Natural Science Museums 
// SCI 		Science & Technology Museums & Planetariums 
// ZAW 		Zoos, Aquariums, & Wildlife Conservation
// Create the Discipline nodes as members of a labeled set
CREATE
	(:Discipline { code : "ART", name : "Art Museums"}),
	(:Discipline { code : "BOT", name : "Arboretums, Botanical Gardens, & Nature Centers"} ),
	(:Discipline { code : "CMU", name : "Children's Museums"} ), 
	(:Discipline { code : "GMU", name : "Uncategorized or General Museums"} ),
	(:Discipline { code : "HSC", name : "Historical Societies, Historic Preservation"} ),
	(:Discipline { code : "HST", name : "History Museums"} ),
	(:Discipline { code : "NAT", name : "Natural History & Natural Science Museums"} ),
	(:Discipline { code : "SCI", name : "Science & Technology Museums & Planetariums"} ), 
	(:Discipline { code : "ZAW", name : "Zoos, Aquariums, & Wildlife Conservation"} )
//
// INCOMECD
// Code 	Description 
// 0 		$0 
// 1 		$1 to $9,999 
// 2 		$10,000 to $24,999 
// 3 		$25,000 to $99,999 
// 4 		$100,000 to $499,999 
// 5 		$500,000 to $999,999 
// 6 		$1,000,000 to $4,999,999 
// 7 		$5,000,000 to $9,999,999 
// 8 		$10,000,000 to $49,999,999
// 9 		$50,000,000 to greater
// Create the Income Range nodes as members of a labeled set
CREATE
	(:Income_range {code : "0", description : "$0"} ),
	(:Income_range {code : "1", description : "$1 to $9,999"} ),
	(:Income_range {code : "2", description : "$10,000 to $24,999"} ),
	(:Income_range {code : "3", description : "$25,000 to $99,999"} ),
	(:Income_range {code : "4", description : "$100,000 to $499,999"} ),
	(:Income_range {code : "5", description : "$500,000 to $999,999"} ),
	(:Income_range {code : "6", description : "$1,000,000 to $4,999,999"} ),
	(:Income_range {code : "7", description : "$5,000,000 to $9,999,999"} ),
	(:Income_range {code : "8", description : "$10,000,000 to $49,999,999"} ),
	(:Income_range {code : "9", description : "$50,000,000 to greater"} )
//
// LOCALE4
// Code 	(Name) 	Description (Orig. LOCALE4 minus 'name prefix' and dropping ' - ' btw name and desc) 
// 1		City 	Territory inside an urbanized area and inside a principal city
// 2		Suburb 	Territory inside an urbanized area but outside a principal city  
// 3		Town	Territory inside an urban cluster that is outside an urbanized area 
// 4		Rural 	Census-defined rural territory that is outside an urbanized area or urbanized cluster.
// Create the Locale nodes as members of a labeled set
CREATE
	(:Locale {code : "1", name: "City", description : "Territory inside an urbanized area and inside a principal city"} ),
	(:Locale {code : "2", name: "Suburb", description : "Territory inside an urbanized area but outside a principal city"} ),
	(:Locale {code : "3", name: "Town", description : "Territory inside an urban cluster that is outside an urbanized area"} ),
	(:Locale {code : "4", name: "Rural", description : "Census-defined rural territory that is outside an urbanized area or urbanized cluster"} )
//
// AAMREG
// Code Name 			Description 
// 1	New England		Connecticut, Massachusetts, Maine, New Hampshire, Rhode Island, Vermont 
// 2	Mid-Atlantic	District of Columbia, Delaware, Maryland, New Jersey, New York, Pennsylvania 
// 3	Southeastern	Alabama, Arkansas, Florida, Georgia, Kentucky, Louisiana, Mississippi, North Carolina, South Carolina, Tennessee, Virginia, West Virginia
// 4	Midwest			Iowa, Illinois, Indiana, Michigan, Minnesota, Missouri, Ohio, Wisconsin 
// 5	Mount Plains 	Colorado, Kansas, Montana, North Dakota, Nebraska, New Mexico, Oklahoma, South Dakota, Texas, Wyoming 
// 6	Western			Alaska, Arizona, California, Hawaii, Idaho, Nevada, Oregon, Utah, Washington
// Create the AAM Region nodes as members of a labeled set
CREATE
	(:AAM_region {code : "1", name : "New England", description : "Connecticut, Massachusetts, Maine, New Hampshire, Rhode Island, Vermont"} ),
	(:AAM_region {code : "2", name : "Mid-Atlantic", description : "District of Columbia, Delaware, Maryland, New Jersey, New York, Pennsylvania"} ),
	(:AAM_region {code : "3", name : "Southeastern", description : "Alabama, Arkansas, Florida, Georgia, Kentucky, Louisiana, Mississippi, North Carolina, South Carolina, Tennessee, Virginia, West Virginia"} ),
	(:AAM_region {code : "4", name : "Midwest", description : "Iowa, Illinois, Indiana, Michigan, Minnesota, Missouri, Ohio, Wisconsin"} ),
	(:AAM_region {code : "5", name : "Mount Plains", description : "Colorado, Kansas, Montana, North Dakota, Nebraska, New Mexico, Oklahoma, South Dakota, Texas, Wyoming"} ),
	(:AAM_region {code : "6", name : "Western", description : "Alaska, Arizona, California, Hawaii, Idaho, Nevada, Oregon, Utah, Washington"} )
//
//
// Now the BIG LOAD of 35,000+ U.S. LAMs.
// NOTE: You must edit the path of the LOAD CSV command to point to your local copy
// of the MUDF file.
//
// Default field selection is: MID, NAME, ALTNAME, ADDRESS, CITY, STATE, ZIP5,
// PHONE, WEBURL, LATITUDE, and LONGITUDE. If you want to add or remove 
// MUDF fields to the CREATE statement below. Refer to the PDF document that
// details the MUDF file.
//
WITH count(*) as not_used
// If you are unable to import this file via the remote URL, you will need to download the source 
// file and edit this path to point to your local copy.
LOAD CSV WITH HEADERS FROM
  'file:https://raw.githubusercontent.com/FactMiners/mudf2Neo4j/master/mudf_import/mudf14q3pub_TitleCase.csv'
  AS line
CREATE (lam:Museum {
	mid : line.MID,
	name : line.NAME,
	alt_name : line.ALTNAME,
	address : line.ADDRESS,
	city : line.CITY,
	state : line.STATE,
	zip : line.ZIP5,
	phone : line.PHONE,
	url : line.WEBURL,
	lat : line.LATITUDE,
	lon : line.LONGITUDE
})
WITH lam, line
// Find the appropriate Discipline, Income_range, Locale, and AAM_region and relate to them
MATCH 
	(dis:Discipline { code: line.DISCIPL}), 
	(inc:Income_range { code: line.INCOMECD}),
	(loc:Locale { code: line.LOCALE4}),
	(aam:AAM_region { code: line.AAMREG})
CREATE
	(lam)-[:IS_TYPE]->(dis),
	(lam)-[:IN_RANGE]->(inc),
	(lam)-[:IN_LOCALE]->(loc),
	(lam)-[:IN_REGION]->(aam)
//
// If these queries run as intended, the feedback message you see 
// (assuming you've kept the default field configuration) will be as follows:
//
// Added 35173 labels, created 35173 nodes, set 386652 properties, created 102276 relationships...
