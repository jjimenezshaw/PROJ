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

-----
-- Try with two steps and an axiliary CRS HTR07_INTERMEDIATE in between
INSERT INTO "geodetic_datum" VALUES(
    'PROJ',	'HTR07_INTERMEDIATE_DATUM',	'HTR07_INTERMEDIATE datum',	NULL,
    'EPSG',	'7019', -- ellipsoid
    'EPSG',	'8901',	-- prime meridian
    '2025-03-05', -- publication date
    NULL,NULL,NULL,NULL,
    0);
INSERT INTO "usage" VALUES(
    'PROJ','HTR07_INTERMEDIATE_DATUM_USAGE','geodetic_datum','PROJ','HTR07_INTERMEDIATE_DATUM',
    'EPSG','3254','EPSG','1153');

INSERT INTO "geodetic_crs" VALUES(
    'PROJ','HTR07_INTERMEDIATE','HTR07_INTERMEDIATE',NULL, -- PROJ CRS
    'geographic 2D','EPSG','6422', -- geographic 3D
    'PROJ','HTR07_INTERMEDIATE_DATUM', -- datum
    NULL,
    0);
INSERT INTO "usage" VALUES(
    'PROJ', 'HTR07_INTERMEDIATE_USAGE', 'geodetic_crs',
    'PROJ', 'HTR07_INTERMEDIATE',
    'EPSG','3254', -- extent: Greece - onshore
    'EPSG','1027'  -- scope
);

INSERT INTO other_transformation VALUES(
    'PROJ','EPSG_4258_TO_HTR07_INTERMEDIATE_GRID','ETRS89 to HTR07_INTERMEDIATE',
    'Transformation based on grid by HEPOS using HTR07_INTERMEDIATE',
    'PROJ','PROJString',
    '+proj=pipeline
    +step +proj=unitconvert +xy_in=deg +xy_out=rad
    +step +proj=axisswap +order=2,1
    +step +proj=tmerc +lat_0=0 +lon_0=24 +k=0.9996 +x_0=500000 +y_0=-2000000 +ellps=GRS80 +units=m
    +step +proj=gridshift +grids=p4_gr_hepos_grid_in_ggrs87.tif
    +step +inv +proj=tmerc +lat_0=0 +lon_0=24 +k=0.9996 +x_0=500000 +y_0=-2000000 +ellps=GRS80 +units=m
    +step +proj=unitconvert +xy_in=rad +xy_out=deg
    +step +proj=axisswap +order=2,1
    ',
    'EPSG','4258', -- source CRS (ETRS89)
    'PROJ','HTR07_INTERMEDIATE', -- target CRS
    0.01, -- Accuracy
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
    0);
INSERT INTO "usage" VALUES(
    'PROJ', 'EPSG_4258_TO_HTR07_INTERMEDIATE_GRID_USAGE', 'other_transformation',
    'PROJ', 'EPSG_4258_TO_HTR07_INTERMEDIATE_GRID',
    'EPSG','3254', -- area of use: Greece onshore
    'EPSG','1189' -- scope: GIS
    );

INSERT INTO "helmert_transformation" VALUES(
    'PROJ','HTR07_INTERMEDIATE_TO_GGRS87','HTR07_INTERMEDIATE to GGRS87',
    'Description','EPSG','9607','Coordinate Frame rotation (geog2D domain)',
    'PROJ','HTR07_INTERMEDIATE',
    'EPSG','4121',
    0.02, -- accuracy
    203.437,-73.461,-243.594, -- x,y,z
    'EPSG','9001', -- meters
    -0.170, -0.060, -0.151, -- rx,ry,rz
    'EPSG','9104', -- arcsec
    -0.294,'EPSG','9202', -- scale
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
    'HEPOS',
    0);
INSERT INTO "usage" VALUES(
    'PROJ', 'HTR07_INTERMEDIATE_TO_GGRS87_USAGE','helmert_transformation',
    'PROJ','HTR07_INTERMEDIATE_TO_GGRS87',
    'EPSG','3254', -- area of use: Greece onshore
    'EPSG','1189' -- scope: GIS
);

INSERT INTO "concatenated_operation" VALUES(
    'PROJ','ETRS89_TO_GGRS87_HEPOS','ETRS89 (EPSG:4258) to GGRS87 (EPSG:4121)',
    'Transformation based on grid by HEPOS',
    'EPSG','4258',
    'EPSG','4121',NULL,NULL,
    0);
INSERT INTO "concatenated_operation_step" VALUES('PROJ','ETRS89_TO_GGRS87_HEPOS',1,'PROJ','EPSG_4258_TO_HTR07_INTERMEDIATE_GRID','forward');
INSERT INTO "concatenated_operation_step" VALUES('PROJ','ETRS89_TO_GGRS87_HEPOS',2,'PROJ','HTR07_INTERMEDIATE_TO_GGRS87','forward');
INSERT INTO "usage" VALUES(
    'PROJ','ETRS89_TO_GGRS87_HEPOS_USAGE','concatenated_operation',
    'PROJ','ETRS89_TO_GGRS87_HEPOS',
    'EPSG','3254','EPSG','1189');

-- INSERT INTO "concatenated_operation" VALUES(
--     'PROJ','WGS84_TO_GGRS87_HEPOS','ETRS89 (EPSG:4326) to GGRS87 (EPSG:4121)',
--     'Transformation based on grid by HEPOS',
--     'EPSG','4326',
--     'EPSG','4121',
--     0.9, -- accuracy, to be less than EPSG:1272
--     NULL,
--     0);
-- INSERT INTO "concatenated_operation_step" VALUES('PROJ','WGS84_TO_GGRS87_HEPOS',1,'EPSG','1149','reverse');
-- INSERT INTO "concatenated_operation_step" VALUES('PROJ','WGS84_TO_GGRS87_HEPOS',2,'PROJ','EPSG_4258_TO_HTR07_INTERMEDIATE_GRID','forward');
-- INSERT INTO "concatenated_operation_step" VALUES('PROJ','WGS84_TO_GGRS87_HEPOS',3,'PROJ','HTR07_INTERMEDIATE_TO_GGRS87','forward');
-- INSERT INTO "usage" VALUES(
--     'PROJ','WGS84_TO_GGRS87_HEPOS_USAGE','concatenated_operation',
--     'PROJ','WGS84_TO_GGRS87_HEPOS',
--     'EPSG','3254','EPSG','1189');


-- Change GGRS87 to WGS84 into ETRS89
INSERT INTO "helmert_transformation" VALUES(
    'PROJ','GGRS87_TO_ETRS89','GGRS87 to ETRS89 (1)','',
    'EPSG','9603','Geocentric translations (geog2D domain)','EPSG','4121','EPSG','4258',
    1.0,-199.87,74.79,246.62,'EPSG','9001',
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Hel-Grc',
    0);
INSERT INTO "usage" VALUES('PROJ','GGRS87_TO_ETRS89_USAGE','helmert_transformation','PROJ','GGRS87_TO_ETRS89','EPSG','3254','EPSG','1041');

UPDATE "helmert_transformation_table" SET deprecated='1' WHERE auth_name = 'EPSG' AND code = '1272';
-----

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
    1);
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
    1);
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
