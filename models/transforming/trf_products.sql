{{config(materialized= 'table',schema= env_var('DBT_TRANSFORMSCHEMA','TRANFORMING_DEV'))}}

select
p.productid,
p.productname,
s.CompanyName as suppliercompany,
s.ContactName as suppliercontact,
s.city as suppliercity,
c.categoryname,
p.quantityperunit,
p.unitcost,
p.unitprice,
p.unitsinstock,
p.unitsonorder,
IFF(p.unitsonorder > p.unitsinstock, 'Not Available', 'Available') as StockAvailability
from
{{ref("stg_products")}} as p
inner join 
{{ref('trf_suppliers')}} as s
on p.SupplierID= s.SupplierID
inner join
{{ref('lkp_categories')}} as c
on p.categoryid=c.categoryid