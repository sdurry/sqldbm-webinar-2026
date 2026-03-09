with 

source as (

    select * from {{ source('operations', 'customer') }}

),

renamed as (

    select *

    from source

)

select * from renamed