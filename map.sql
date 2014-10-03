create table bh_test1 as 
select 
    fips_cntry, the_geom
from world_borders f
where st_area(the_geom) = (
                            select
                                max(st_area(the_geom))
                            from world_borders 
                            where f.fips_cntry = world_borders.fips_cntry
                           );
                           
create table bh_test2 as 
select
    w.fips_cntry,
    ST_Translate(scale(w.the_geom, s.size, s.size),
                 s.size * -1 * (ST_Xmin(the_geom)+ST_XMax(the_geom))/2 + ((ST_Xmin(the_geom)+ST_XMax(the_geom))/2),
                 s.size * -1 * (ST_Ymin(the_geom)+ST_YMax(the_geom))/2 + ((ST_Ymin(the_geom)+ST_YMax(the_geom))/2)
                ) as thegeom_scaled
from scale s
inner join bh_test1 w 
    on s.id = w.fips_cntry
;