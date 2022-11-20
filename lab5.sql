CREATE EXTENSION POSTGIS;


DROP TABLE  IF EXISTS objects;
CREATE TABLE objects(id SERIAL PRIMARY KEY, geom geometry, name VARCHAR);

-- Zad 1

INSERT INTO objects(geom, name) VALUES 
    (ST_Collect(ARRAY[
        ST_GeomFromText('LINESTRING(0 1 ,1 1)'), 
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(1 1,2 0, 3 1)')),
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(3 1,4 2, 5 1)')),
        ST_GeomFromText('LINESTRING(5 1 ,6 1)')
    ]),'object1'),
    (ST_Collect(ARRAY[
        ST_GeomFromText('LINESTRING(10 6 ,14 6)'), 
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(14 6,16 4, 14 2)')),
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(14 2,12 0, 10 2)')),
        ST_GeomFromText('LINESTRING(10 2 ,10 6)'),
        ST_CurveToLine(ST_GeomFromText('CIRCULARSTRING(11 2,12 3, 13 2, 12 1, 11 2)'))]),
        'object2'),
    (ST_MakePolygon(ST_GeomFromText('LINESTRING(7 15, 10 17, 12 13, 7 15)')), 'object3'),
    (ST_LineFromMultiPoint(St_GeomFromText('MULTIPOINT(20 20, 25 25,27 24, 25 22, 26 21, 22 19, 20.5 19.5)')), 'object4'),
    (ST_Collect(ST_GeomFromText('POINT(30 30 59)'), ST_GeomFromText('POINT(38 32 234)')), 'object5'),
    (ST_Collect(ST_GeomFromText('LINESTRING(1 1, 3 2)'), ST_GeomFromText('POINT(4 2)')), 'object6')

select * from objects;


-- Zad 2

select ST_Area(ST_Buffer(ST_ShortestLine(object3.geom, object4.geom),5)) from 
        (select geom from objects where name='object3') as object3, 
        (select geom from objects where name='object4') as object4

-- Zad 3

update objects  set geom = ST_MakePolygon(ST_AddPoint(geom, ST_PointN(geom,1))) where name='object4';

-- Zad 4

INSERT INTO objects(geom, name) 
    (select St_Collect(object3.geom, object4.geom), 'object7' from 
        (select geom from objects where name='object3') as object3, 
        (select geom from objects where name='object4') as object4
    )


select * from objects;

-- Zad 5

select ST_Area(St_Buffer(geom, 5)) from objects where ST_HasArc(ST_LineToCurve(geom)) = false;