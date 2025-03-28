{{config(materialized= 'table',schema= env_var('DBT_TRANSFORMSCHEMA','TRANFORMING_DEV'))}}
 
  with recursive managers
      -- Column names for the "view"/CTE
    (indent, office, employee_id, employee_name, employee_title, manager_id, manager_name, manager_title)
    as
      -- Common Table Expression
      (
 
        -- Anchor Clause
        select '*' as indent, office, empid as employee_id, firstname as employee_name, title as employee_title, empid as manager_id, firstname as manager_name, title as manager_title
          from {{ref('stg_employees')}}
          where title = 'President'
 
        union all
 
        -- Recursive Clause
        select indent || '*', e.office,
            e.empid as employee_id, e.firstname as employee_name, e.title as employee_title,
            m.employee_id, m.employee_name, m.employee_title
          from {{ref('stg_employees')}} as e join managers as m
            on e.reportsto = m.employee_id
      ),
 
      offices (officeid, officecity, officestate, officecountry)
      as
      (
      select ho.office, so.officecity, so.officestateprovince, so.officecountry
      from {{ref('stg_hub_offices')}} as ho inner join {{ref('stg_sat_offices')}} as so
      on ho.officehashkey = so.officehashkey
 
      )
 
  -- This is the "main select".
  select m.indent, m.employee_id, m.employee_name, m.employee_title, m.manager_id, m.manager_name, m. manager_title, o.officecity,
  IFF(o.officestate is null, 'NA', o.officestate) as officestate,
  o.officecountry
    from managers as m left join offices as o on
    m.office = o.officeid