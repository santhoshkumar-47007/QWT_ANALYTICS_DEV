{{config(materialized = 'table') }}
 
select
ho.officehashkey,
current_timestamp as loaddate,
ro.officeaddress,
ro.officepostalcode,
ro.officecity,
ro.officestateprovince,
ro.officephone,
ro.officefax,
ro.officecountry
from
{{ref('stg_hub_offices')}} as ho
inner join
{{source('qwt_raw', 'raw_offices')}} as ro
on ho.office = ro.office