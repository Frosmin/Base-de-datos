CREATE TABLE bitacora_premio (
    id SERIAL PRIMARY KEY,
    codpremio integer,
    nombrepremio VARCHAR(100),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--creamos la tabla basica donde queremos guardar todo lo que se modifique en la tabla premio

create function funcion_premio() returns trigger
as
    $$
    begin
    insert into bitacora_premio (codpremio, nombrepremio,fecha) values (old.codpremio, old.nombrepremio, now());

    return new;
    end
    $$
    language plpgsql;
--funcion donde que guarda todo lo antiguo en la tabla bitacora_premio mas la fecha actual

create trigger triger_premio before update on premio
for each row
execute procedure funcion_premio();
--triger que se activa cuando se hace la update en la tabla premio


UPDATE public.premio SET nombrepremio = 'Premios sur3' WHERE codpremio = 17;
--ejemplo de la update 