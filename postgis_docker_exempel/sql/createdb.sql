create extension postgis;

CREATE TABLE geodata (
  id serial primary key,
  modified timestamp with time zone default now(),
  created timestamp with time zone default now(),
  name varchar(40),
  geom geometry(POLYGON,4326)
);

INSERT INTO geodata (name, geom)
VALUES
(
    'En polygon',
    ST_Force2D(ST_GeomFromGeoJSON
    (
        '{
            "type":"Polygon",
            "coordinates": [[
                [-104.05, 48.99],
                [-97.22,  48.98],
                [-96.58,  45.94],
                [-104.03, 45.94],
                [-104.05, 48.99]
            ]],
            "crs":{"type":"name","properties":{"name":"EPSG:4326"}}
        }'
    ))
);