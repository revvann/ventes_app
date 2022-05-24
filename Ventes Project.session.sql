select table_name,
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_name in ('trprospect')
order by table_name,
    ordinal_position;
-- select column_name,
--     data_type,
--     character_maximum_length,
--     column_default,
--     is_nullable
-- from INFORMATION_SCHEMA.COLUMNS
-- where table_name = 'stbpcustomer';
-- select *
-- from INFORMATION_SCHEMA.TABLES
-- where TABLE_SCHEMA = 'public';
-- select *
-- from mscustomer;
-- INSERT INTO mscustomer
-- VALUES (
--         default,
--         null,
--         'Magnum P.I.',
--         '081211113333',
--         'Jl. Bahagia Raya, Kel. Gebang Raya, Kec. Periuk, Kota Tangerang',
--         18,
--         36,
--         3671,
--         367108,
--         null,
--         '34435',
--         -6.180482,
--         106.589175,
--         null,
--         1,
--         now(),
--         1,
--         now(),
--         true
--     );
select *
from msuserdt
where userdtbpid = (
        select userdtbpid
        from msuserdt
        where userid = 18
    );
select *
from mstype;