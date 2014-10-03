CREATE TABLE simplified_countries AS
SELECT
 cat,
 fips_cntry,
 cntry_name,
 area,
 pop_cntry,
 st_union(the_geom) AS the_geom
FROM world_borders
GROUP BY 
 cat,
 fips_cntry,
 cntry_name,
 area,
 pop_cntry;