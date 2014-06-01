mudf2Neo4j - MUDF Import to Neo4j
==========

This National Day of Civic Hacking 2014 project gets the The Museum Universe Data File (MUDF, containing basic identifying information of known museums in the United States) into the Neo4j graph database.

Organization source: Institute of Museum and Library Services (http://www.imls.gov)
Data file 'home' page: http://www.imls.gov/research/museum_universe_data_file.aspx

The files in this directory include:

* MUDF_Documentation_2014q3.pdf - This 12-page document details the format of the MUDF file as well as provide full information about the source and use of this public data file from the Institute of Museum and Library Services.
* mudf14q3pub_csv.zip which is the original source of the MUDF provide by the IMLS
* mudf14q3pub_TitleCase.csv - This 7.5 MD file can be loaded remotely via this file's GitHub URL, however it is usually a better choice to download the file and import it locally.
* mudf2neo4j.cypher - This small file contains the Cypher graph database query statements to create the Museums Universe (USA) database in Neo4j. You may simply copy and paste its content into the query input pane of your Neo4j browser, or you may provide this file as a parameter to a Neo4j-shell session.
* README.md - This file

NOTE: The mudf2neo4j.cypher script assumes you are running 2.1 or later Neo4j as it uses the LOAD CSV command introduced in 2.1.
