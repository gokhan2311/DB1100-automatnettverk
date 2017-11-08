-- join

use Automatnettverk;

select *
from vare;

select *
from kategori;


select *
from vare inner join kategori; -- for langt?!


select *
from vare inner join kategori
on vare.kategoriID = kategori.kategoriID
order by vareID;


-- inner, right, left,
select * from Lokasjon natural join Automat;
-- select * from Kategori natural join Vare;

-- natural
