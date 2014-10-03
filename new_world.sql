CREATE OR REPLACE FUNCTION new_world(text, text)
    RETURNS void AS
$$
    DECLARE
        old ALIAS FOR $1;
        new ALIAS FOR $2;
    BEGIN

        EXECUTE '
DROP TABLE
IF EXISTS ' || quote_ident( new ) || '
CASCADE';

        /***** CREATE THE NEW TABLE *****/
        
        EXECUTE '
CREATE TABLE ' || quote_ident( new ) || '
WITH oids AS
SELECT objectid  ,
       country   ,
       featurecla,
       sov       ,
       geometryn( the_geom,
                  generate_series( 1,
                                   numgeometries( the_geom )
                                 )
                 ) AS the_geom
FROM   ' || quote_ident( OLD ) ;

        /***** remove the old table *****/

        EXECUTE '
DROP TABLE
IF EXISTS ' || quote_ident( new || '_too') || '
CASCADE';

        /***** CREATE THE NEW TABLE *****/
        
        EXECUTE '
CREATE TABLE ' || quote_ident( new || '_too') || '
WITH oids AS
     (SELECT  objectid  ,
              country   ,
              featurecla,
              sov       ,
              the_geom
     FROM     ' || quote_ident( new ) || '
     WHERE    country = ''Indonesia''
     ORDER BY st_area(the_geom) DESC LIMIT 11
     )
 
UNION
      ( SELECT  objectid ,
               country   ,
               featurecla,
               sov       ,
               the_geom
      FROM     ' || quote_ident( new ) || '
      WHERE    country = ''Canada''
      ORDER BY st_area(the_geom) DESC LIMIT 5
      )
 
UNION
      ( SELECT  objectid ,
               country   ,
               featurecla,
               sov       ,
               the_geom
      FROM     ' || quote_ident( new ) || '
      WHERE    country = ''Japan''
      ORDER BY st_area(the_geom) DESC LIMIT 5
      )
 
UNION
      ( SELECT  objectid ,
               country   ,
               featurecla,
               sov       ,
               the_geom
      FROM     ' || quote_ident( new ) || '
      WHERE    country = ''Philippines''
      ORDER BY st_area(the_geom) DESC LIMIT 11
      )
 
UNION
      ( SELECT  objectid ,
               country   ,
               featurecla,
               sov       ,
               the_geom
      FROM     ' || quote_ident( new ) || '
      WHERE    country = ''Malaysia''
      ORDER BY st_area(the_geom) DESC LIMIT 3
      )
 
UNION
      ( SELECT  objectid ,
               country   ,
               featurecla,
               sov       ,
               the_geom
      FROM     ' || quote_ident( new ) || '
      WHERE    country = ''Greece''
      ORDER BY st_area(the_geom) DESC LIMIT 5
      )
 
UNION
      ( SELECT  objectid ,
               country   ,
               featurecla,
               sov       ,
               the_geom
      FROM     ' || quote_ident( new ) || '
      WHERE    country = ''New Zealand''
      ORDER BY st_area(the_geom)  DESC LIMIT 2
      )
 
UNION
      ( SELECT objectid ,
              country   ,
              featurecla,
              sov       ,
              the_geom
      FROM    ' || quote_ident( new ) || ' w
      WHERE   st_area(the_geom) =
              ( SELECT MAX(st_area(the_geom))
              FROM    ' || quote_ident( new ) || ' AS f
              WHERE   f.country = w.country
              
              )
      )';
    
    END;
$$
LANGUAGE 'plpgsql' VOLATILE;

