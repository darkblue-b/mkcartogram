CREATE OR REPLACE FUNCTION mkcartogram(text, text)
    RETURNS void AS
$$
    DECLARE
        world ALIAS FOR $1;
        data ALIAS FOR $2;
    BEGIN


        /***** remove the old table *****/

        EXECUTE '
DROP TABLE
IF EXISTS ' || quote_ident( data || '_map') || '
CASCADE';

        /***** CREATE THE NEW TABLE *****/
        
        EXECUTE '
CREATE TABLE ' || quote_ident( data || '_map') || '
WITH oids AS
SELECT s.sov,
       ST_Translate(scale(w.the_geom, s.param, s.param),
                    s.param * -1 * (ST_Xmin(the_geom)+ST_XMax(the_geom))/2 + ((ST_Xmin(the_geom)+ST_XMax(the_geom))/2),
                    s.param * -1 * (ST_Ymin(the_geom)+ST_YMax(the_geom))/2 + ((ST_Ymin(the_geom)+ST_YMax(the_geom))/2)
                   ) as thegeom_scaled
FROM   ' || quote_ident( data ) || ' s
       INNER JOIN ' || quote_ident( world ) || ' w
       ON
              CASE
                     WHEN s.sov = ''Antigua and Barbuda''
                     THEN s.sov = w.sov
                     ELSE s.sov = w.country
              END' ;
       
    END;
$$
LANGUAGE 'plpgsql' VOLATILE;


