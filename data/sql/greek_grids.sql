--------------------------------
--------------------------------
--------------------------------
-- There is no geographic 3D for GGRS87, so create one for the transformation with the same datum
INSERT INTO "geodetic_crs" VALUES(
    'PROJ','GGRS87_3D','GGRS87',NULL, -- PROJ CRS
    'geographic 3D','EPSG','6423', -- geographic 3D
    'EPSG',6121, -- datum from GGRS87
    NULL,
    0);
INSERT INTO "usage" VALUES(
    'PROJ',
    'PROJ_GGRS87_3D_USAGE',
    'geodetic_crs',
    'PROJ',
    'GGRS87_3D',
    'EPSG','3254', -- extent: Greece - onshore
    'EPSG','1027'  -- scope
);

--- Greek horizontal transformations
INSERT INTO other_transformation VALUES(
    'PROJ','EPSG_4258_TO_EPSG_4121_GRID','ETRS89 to GGRS87 (1)',
    'Transformation based on grid by HEPOS',
    'PROJ','PROJString',
    '+proj=pipeline
    +step +proj=unitconvert +xy_in=deg +xy_out=rad
    +step +proj=axisswap +order=2,1
    +step +proj=push +v_3
    +step +proj=tmerc +lat_0=0 +lon_0=24 +k=0.9996 +x_0=500000 +y_0=-2000000 +ellps=GRS80 +units=m
    +step +proj=gridshift +grids=p4_gr_hepos_grid_in_ggrs87.tif
    +step +inv +proj=tmerc +lat_0=0 +lon_0=24 +k=0.9996 +x_0=500000 +y_0=-2000000 +ellps=GRS80 +units=m
    +step +proj=cart +ellps=GRS80
    +step +proj=helmert +x=203.437 +y=-73.461 +z=-243.594
        +rx=-0.170 +ry=-0.060 +rz=-0.151
        +s=-0.294 +convention=coordinate_frame
    +step +inv +proj=cart +ellps=GRS80
    +step +proj=pop +v_3
    +step +proj=unitconvert +xy_in=rad +xy_out=deg
    +step +proj=axisswap +order=2,1
    ',
    'EPSG','4258', -- source CRS (ETRS89)
    'EPSG','4121', -- target CRS (GGRS87)
    0.05, -- Accuracy
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
    0);
INSERT INTO "usage" VALUES(
    'PROJ',
    'EPSG_4258_TO_EPSG_4121_GRID_USAGE',
    'other_transformation',
    'PROJ',
    'EPSG_4258_TO_EPSG_4121_GRID',
    'EPSG','3254', -- area of use: Greece onshore
    'EPSG','1189' -- scope: GIS
    );

INSERT INTO other_transformation VALUES(
    'PROJ','EPSG_4937_TO_EPSG_4121_GRID','ETRS89 to GGRS87 (2)',
    'Transformation based on grid by HEPOS',
    'PROJ','PROJString',
    '+proj=pipeline
    +step +proj=unitconvert +xy_in=deg +xy_out=rad
    +step +proj=axisswap +order=2,1
    +step +proj=tmerc +lat_0=0 +lon_0=24 +k=0.9996 +x_0=500000 +y_0=-2000000 +ellps=GRS80 +units=m
    +step +proj=gridshift +grids=p4_gr_hepos_grid_in_ggrs87.tif
    +step +inv +proj=tmerc +lat_0=0 +lon_0=24 +k=0.9996 +x_0=500000 +y_0=-2000000 +ellps=GRS80 +units=m
    +step +proj=cart +ellps=GRS80
    +step +proj=helmert +x=203.437 +y=-73.461 +z=-243.594
        +rx=-0.170 +ry=-0.060 +rz=-0.151
        +s=-0.294 +convention=coordinate_frame
    +step +inv +proj=cart +ellps=GRS80
    +step +proj=unitconvert +xy_in=rad +xy_out=deg
    +step +proj=axisswap +order=2,1
    ',
    'EPSG','4937', -- source CRS (ETRS89)
    'PROJ','GGRS87_3D', -- target CRS (GGRS87)
    0.04, -- Accuracy
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
    0);
INSERT INTO "usage" VALUES(
    'PROJ',
    'EPSG_4937_TO_EPSG_4121_GRID_USAGE',
    'other_transformation',
    'PROJ',
    'EPSG_4937_TO_EPSG_4121_GRID',
    'EPSG','3254', -- area of use: Greece onshore
    'EPSG','1189' -- scope: GIS
    );

--- Greek geoid model

-- Compound ETRS89 + Piraeus height
INSERT INTO "compound_crs" VALUES(
    'PROJ','ETRS89_Piraeus_height','ETRS89 + Piraeus height',
    NULL,
    'EPSG','4258',
    'EPSG','5716',0);
INSERT INTO "usage" VALUES(
    'PROJ',
    'ETRS89_Piraeus_height_USAGE',
    'compound_crs',
    'PROJ',
    'ETRS89_Piraeus_height',
    'EPSG','3254',
    'EPSG','1026'
    );


-- geoid model to vertical
INSERT INTO "grid_transformation" VALUES(
    'PROJ','EPSG_4937_TO_EPSG_5716','ETRS89 to Piraeus height',
    NULL,
    'EPSG','9665','Geographic3D to GravityRelatedHeight (gtx)',
    'EPSG','4937', -- source CRS (ETRS89)
    'EPSG','5716', -- target CRS (Piraeus height)
    0.05,
    'EPSG','8666','Geoid (height correction) model file','p4_gr_hepos_geoid_gr_hepos2011.tif',
    NULL,NULL,NULL,NULL,'EPSG','4258',NULL,
    0);
INSERT INTO "usage" VALUES(
    'PROJ',
    'EPSG_4937_TO_EPSG_5716_USAGE',
    'grid_transformation',
    'PROJ',
    'EPSG_4937_TO_EPSG_5716',
    'EPSG','3254', -- area of use: Greece onshore
    'EPSG','1024'  -- unknown
);

-- geoid model to compound
INSERT INTO "grid_transformation" VALUES(
    'PROJ','EPSG_4937_TO_EPSG_4258_5716','ETRS89 to ETRS89 + Piraeus height',
    NULL,
    'EPSG','1092','Geog3D to Geog2D+GravityRelatedHeight (EGM2008)',
    'EPSG','4937',
    'PROJ','ETRS89_Piraeus_height',
    0.05,
    'EPSG','8666','Geoid (height correction) model file','EGM08_REDNAP.txt',
    NULL,NULL,NULL,NULL,'EPSG','4258','IGN-Esp 2008',
    0);
INSERT INTO "usage" VALUES(
    'PROJ',
    'EPSG_4937_TO_EPSG_4258_5716_USAGE',
    'grid_transformation',
    'PROJ',
    'EPSG_4937_TO_EPSG_4258_5716',
    'EPSG','3254', -- area of use: Greece onshore
    'EPSG','1024'  -- unknown
);

---------------------------------------------------------
-- data/sql/grid_alternatives.sql
---------------------------------------------------------
INSERT INTO grid_alternatives(original_grid_name,
                              proj_grid_name,
                              old_proj_grid_name,
                              proj_grid_format,
                              proj_method,
                              inverse_direction,
                              package_name,
                              url, direct_download, open_license, directory)
VALUES
-- Greece
('p4_gr_hepos_geoid_gr_hepos2011.tif','p4_gr_hepos_geoid_gr_hepos2011.tif',NULL,'GTiff','geoid_like',0,NULL,'https://cdn.proj.org/p4_gr_hepos_geoid_gr_hepos2011.tif',1,1,NULL)
 ;
