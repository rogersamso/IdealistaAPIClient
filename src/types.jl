import Base: @kwdef # these fields must be in the search fields


abstract type SearchFields end
abstract type PropertyFields <: SearchFields end


@kwdef struct Search <: SearchFields
    country::String
    operation::String
    propertyType::String
    center::String
    distance::Union{<:Int, Nothing}=nothing
    locationId::Union{<:AbstractString, Nothing}=nothing
    maxItems::Union{<:Int, Nothing}=nothing
    numPage::Union{<:Int, Nothing}=nothing
    maxPrice::Union{<:Number, Nothing}=nothing
    minPrice::Union{<:Number, Nothing}=nothing
    sinceDate::Union{<:AbstractString, Nothing}=nothing
    order::Union{<:AbstractString, Nothing}=nothing
    sort::Union{<:AbstractString, Nothing}=nothing
    adIds::Union{<:Int, Nothing}=nothing
    hasMultimedia::Union{Bool, Nothing}=nothing

    function Search(country, operation, propertyType, center, distance, locationId, maxItems, numPage, maxPrice, minPrice, sinceDate, order, sort, adIds, hasMultimedia)
        
        country ∉  ["es", "pt", "it"] && error("Country field can only be es, pt or it")
        operation ∉ ["sale", "rent"] && error("Only sell and rent operations are allowed")
        propertyType ∉ ["homes", "offices", "premises", "garages", "bedrooms"] && error("propertyType can only take homes, offices, premises, garages or bedrooms")
        sort!=nothing && !in(sort, ["asc", "desc"]) && error("the sort field can only be set to asc or desc")
        sinceDate!=nothing && !in(sinceDate, ["W", "M", "T", "Y"]) && error("the sinceDate field only accepts W, M, T, Y")
        
        # TODO should also limit the values of the sort field, depending on the given propertyType field.

        distance==nothing && locationId==nothing && error("Provide either distance of locationId")
        distance!=nothing && locationId!=nothing && error("Provide either distance of locationId, but not both")
        
        new(country, operation, propertyType, center, distance, locationId, maxItems, numPage, maxPrice, minPrice, sinceDate, order, sort, adIds, hasMultimedia)  
    end
end

@kwdef struct Garages <: PropertyFields 
    bankOffer::Union{Bool, Nothing}=nothing
    automaticDoor::Union{Bool, Nothing}=nothing
    motorcycleParking::Union{Bool, Nothing}=nothing
    security::Union{Bool, Nothing}=nothing
end

@kwdef struct Premises <: PropertyFields
    minSize::Union{<:Number, Nothing}=nothing
    maxSize::Union{<:Number, Nothing}=nothing
    virtualTour::Union{Bool, Nothing}=nothing
    location::Union{<:AbstractString, Nothing}=nothing
    corner::Union{Bool, Nothing}=nothing
    airConditioning::Union{Bool, Nothing}=nothing
    smokeVentilation::Union{Bool, Nothing}=nothing
    heating::Union{Bool, Nothing}=nothing
    transfer::Union{Bool, Nothing}=nothing
    buildingTypes::Union{<:AbstractString, Nothing}=nothing
    bankOffer::Union{Bool, Nothing}=nothing

    function Premises(minSize, maxSize, virtualTour, location, corner, airConditioning, smokeVentilation, heating, transfer, buildingTypes, bankOffer)
        
        ~isnothing(minSize) && ((60 <= minSize <= 1000) || error("minimum premise size must be between 60 and 1000 m²"))
        ~isnothing(maxSize) && ((60 <= maxSize <= 1000) || error("maximum premise size must be between 60 and 1000 m²"))
        location!=nothing && ∉(location, ["shoppingcenter", "street", "mezzanine", "underground", "others"]) && error("location can only take values of shoppingcenter, street, mezzanine, underground or other")
        buildingTypes!=nothing && ∉(buildingTypes, ["premises", "industrialBuilding"]) && error("buildingTypes can only take values of premises or industrialBuilding")
        bankOffer!=nothing && @info("bankOffer only applies in Spain")

        new(minSize, maxSize, virtualTour, location, corner, airConditioning, smokeVentilation, heating, transfer, buildingTypes, bankOffer)
    end 
end


@kwdef struct Homes <: PropertyFields
    minSize::Union{<:Number, Nothing}=nothing
    maxSize::Union{<:Number, Nothing}=nothing
    virtualTour::Union{Bool, Nothing}=nothing
    flat::Union{Bool, Nothing}=nothing
    penthouse::Union{Bool, Nothing}=nothing
    duplex::Union{Bool, Nothing}=nothing
    studio::Union{Bool, Nothing}=nothing
    chalet::Union{Bool, Nothing}=nothing
    countryHouse::Union{Bool, Nothing}=nothing
    bedrooms::Union{<:AbstractString, Nothing}=nothing
    bathrooms::Union{<:AbstractString, Nothing}=nothing
    preservation::Union{<:AbstractString, Nothing}=nothing
    newDevelopment::Union{Bool, Nothing}=nothing
    furnished::Union{<:AbstractString, Nothing}=nothing
    bankOffer::Union{Bool, Nothing}=nothing
    garage::Union{Bool, Nothing}=nothing
    terrace::Union{Bool, Nothing}=nothing
    exterior::Union{Bool, Nothing}=nothing
    elevator::Union{Bool, Nothing}=nothing
    swimmingPool::Union{Bool, Nothing}=nothing
    airConditioning::Union{Bool, Nothing}=nothing
    storeRoom::Union{Bool, Nothing}=nothing
    clotheslineSpace::Union{Bool, Nothing}=nothing
    builtinWardrobes::Union{Bool, Nothing}=nothing
    subTypology::Union{<:AbstractString, Nothing}=nothing

    function Homes(minSize, maxSize, virtualTour, flat, penthouse, duplex, studio, chalet, countryHouse, bedrooms, bathrooms, preservation, newDevelopment, furnished, bankOffer, garage, terrace, exterior, elevator, swimmingPool, airConditioning, storeRoom, clotheslineSpace, builtinWardrobes, subTypology)
 
        ~isnothing(minSize) && ((60 <= minSize <= 1000) || error("minimum house size must be between 60 and 1000 m²"))
        ~isnothing(maxSize) && ((60 <= maxSize <= 1000) || error("maximum house size must be between 60 and 1000 m²"))
        ~isnothing(bedrooms) && !(eltype(parse.(Int, split(bedrooms, ","))) <: Int) && error("number of bedrooms musth be given as a string of integers separate by ,")
        ~isnothing(bathrooms) && !(eltype(parse.(Int, split(bathrooms, ","))) <: Int) && error("number of bathrooms musth be given as a string of integers separate by ,")
        ~isnothing(preservation) && ∉(preservation, ["good", "renew"]) && error("preservation can only take values of good or renew")
        ~isnothing(furnished) && ∉(furnished, ["furnished", "furnishedKitchen"]) && error("furnished only takes values of furnished or furnishedKitchen")
        ~isnothing(bankOffer) && @info("bankOffer only applies in Spain")
        ~isnothing(subTypology) && ∉(subTypology, ["independantHouse", "semidetachedHouse", "terracedHouse"]) && error("subTypology only accepts values of independantHouse, semidetachedHouse or terracedHouse")

        new(minSize, maxSize, virtualTour, flat, penthouse, duplex, studio, chalet, countryHouse, bedrooms, bathrooms, preservation, newDevelopment, furnished, bankOffer, garage, terrace, exterior, elevator, swimmingPool, airConditioning, storeRoom, clotheslineSpace, builtinWardrobes, subTypology)
    end
end


@kwdef struct Offices <: PropertyFields
    minSize::Union{<:Number, Nothing}=nothing
    maxSize::Union{<:Number, Nothing}=nothing
    layout::Union{<:AbstractString, Nothing}=nothing
    buildingType::Union{<:AbstractString, Nothing}=nothing
    garage::Union{Bool, Nothing}=nothing
    hotWater::Union{Bool, Nothing}=nothing
    heating::Union{Bool, Nothing}=nothing
    elevator::Union{Bool, Nothing}=nothing
    airConditioning::Union{Bool, Nothing}=nothing
    security::Union{Bool, Nothing}=nothing
    exterior::Union{Bool, Nothing}=nothing
    bankOffer::Union{Bool, Nothing}=nothing
    
    function Offices(minSize, maxSize, layout, buildingType, garage, hotWater, heating, elevator, airConditioning, security, exterior, bankOffer)

       ~isnothing(minSize) && ((60 <= minSize <= 1000) || error("minimum office size must be between 60 and 1000 m²"))
       ~isnothing(maxSize) && ((60 <= maxSize <= 1000) || error("maximum office size must be between 60 and 1000 m²"))
       ~isnothing(layout) && ∉(layout, ["withWalls", "openPlan"]) && error("layout can only take vues withWalls and openPlan")
       ~isnothing(buildingType) && ∉(buildingType, ["exclusive", "mixed"]) && error("buildingType can only take values of exclusive or mixed")
       ~isnothing(bankOffer) && @info("bankOffer only works in Spain")

       new(minSize, maxSize, layout, buildingType, garage, hotWater, heating, elevator, airConditioning, security, exterior, bankOffer)
   end

end

@kwdef struct Bedrooms <: PropertyFields
    housemates::Union{<:AbstractString, Nothing}=nothing
    smokePolicy::Union{<:AbstractString, Nothing}=nothing
    petsPolicy::Union{<:AbstractString, Nothing}=nothing
    gayPartners::Union{Bool, Nothing}=nothing
    newGender::Union{<:AbstractString, Nothing}=nothing

    function Bedrooms(housemates, smokePolicy, petsPolicy, gayPartners, newGender)
        
        ~isnothing(smokePolicy) && ∉(smokePolicy, ["allowed", "disallowed"]) & error("the only valid values for smokePolicy are allowed or disallowed")
        ~isnohing(petsPolicy) && ∉(petsPolicy, ["allowed", "disallowed"]) & error("the only valid values for petsPolicy are allowed or disallowed")
        ~isnothing(newGender) && ∉(newGender, ["male", "female"]) && error("newGender can only take values of male or female")
        
        new(housemates, smokePolicy, petsPolicy, gayPartners, newGender)
     end
end

