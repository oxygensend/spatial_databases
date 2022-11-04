import geopandas as gpd
from sqlalchemy import create_engine
import getopt, sys

# create the sqlalchemy connection engine
db_connection_url = "postgresql://postgres:postgres@127.0.0.1:5432/lab3"
con = create_engine(db_connection_url)

# read in the datao
opts, args = getopt.getopt(sys.argv[1:], 'x',['filename=']);

filename = args[0]
table = args[1]

gdf = gpd.read_file(filename)

# Drop nulls in the geometry column
print('Dropping ' + str(gdf.geometry.isna().sum()) + ' nulls.')
gdf = gdf.dropna(subset=['geometry'])

# Push the geodataframe to postgresql
gdf.to_postgis(table, con, index=True, if_exists='replace') 