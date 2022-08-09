# IdealistaAPIClient

Simple Julia client for the Idealista Search API.


## Requirements

The idealista APIKEY and SECRET must be defined as environmental variables in the startup.jl file.

Use [this link](https://developers.idealista.com/access-request) to request an APIKEY and SECRET.


## Installation instructions

At the Julia REPL, using Pkg; Pkg.add("IdealistaAPIClient")

## Utilization example

```julia
using IdealistaAPIClient

# define search fields
search_fields = (country="es", center="40.430,-3.702", propertyType="homes", distance=15000, operation="sale", bedrooms="1,2,3,4", swimmingPool=true)

response_body = search(;search_fields...)

```


## Valid search fields

This is the list of basic search fields (non property-type-specific). 

| Name                     | Data type | Description                                              | Extra info                                          |
---------------------------|-----------|----------------------------------------------------------|-----------------------------------------------------|
| country (required)       | string    | es/it/pt                                                 | values: es, it, pt                                  |
| operation (required)     | string    |                                                          | values: sale, rent                                  |
| propertyType (required)  | string    |                                                          | values: homes, offices, premises, garages, bedrooms |
| center                   | string    | geographic coordinates (WGS84) (latitude,longitude)      | example: “40.123,-3.242”                            |
| locale                   | string    | search language for summary                              | values: es, it, pt, en, ca                          |
| distance                 | double    | distance to center, in metres (ratio)                    |                                                     |
| locationId               | string    | idealista location code 	                          |                                                     |
| maxItems                 | integer   | items per page                                           | 50 as maximum                                       |
| numPage                  | integer   | page number (for pagination)                             | (1,2,3..n)                                          |
| maxPrice                 | double    | maximun price in response                                |
| minPrice                 | double    | minimun price in response                                |
| sinceDate                | sinceDate |                                                          | W:last week, M: last month, T:last day (for rent except rooms), Y: last 2 days (sale and rooms) |
| order                    | string    |                                                          | allowed values by property type: garages, premises, offices, homes, rooms |
| sort                     | string    |                                                          | values: asc, desc                                   | 
| adIds                    | integer   | filter by adid                                           | multivalued field                                   |
| hasMultimedia            | Boolean   | retrieve properties with pictures or video or virtual tour|                                                     |

You must specify a center + distance or locationId in each request.

Specific filters exist for garages, premises, offices, homes and rooms. Check the documentation you get when requesting the API key for details.